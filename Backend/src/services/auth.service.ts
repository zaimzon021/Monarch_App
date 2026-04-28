import path from "path";
import fs from "fs";
import { db } from "../config/firebase";
import transporter from "../config/mailer";
import { FieldValue, Timestamp } from "firebase-admin/firestore";
import { User } from "../models/user.model";

const USERS_COL = "users";
const OTPS_COL = "otps";
const OTP_EXPIRY_MINUTES = 10;

// ── helpers ──────────────────────────────────────────────────────────────────

function generateOtp(): string {
  return Math.floor(1000 + Math.random() * 9000).toString(); // always 4 digits
}

async function getUserByEmail(email: string): Promise<User | null> {
  const snapshot = await db
    .collection(USERS_COL)
    .where("email", "==", email)
    .limit(1)
    .get();

  if (snapshot.empty) return null;
  const doc = snapshot.docs[0];
  return { id: doc.id, ...doc.data() } as User;
}

function buildOtpDigits(otp: string): string {
  return otp
    .split("")
    .map(
      (d) => `
      <td style="padding: 0 8px;">
        <div style="
          width: 64px;
          height: 76px;
          border: 2.5px solid #FF6B35;
          border-radius: 16px;
          font-size: 36px;
          font-weight: 900;
          color: #FF6B35;
          font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif;
          text-align: center;
          line-height: 76px;
          background: #ffffff;
          box-shadow: 0 4px 16px rgba(255,107,53,0.18);
          letter-spacing: 0;
        ">${d}</div>
      </td>`
    )
    .join("");
}

function loadTemplate(variables: Record<string, string>): string {
  const templatePath = path.join(__dirname, "../templates/otp-email.html");
  let html = fs.readFileSync(templatePath, "utf-8");

  // Replace all {{key}} placeholders
  for (const [key, value] of Object.entries(variables)) {
  html = html.split(`{{${key}}}`).join(value);
  }

  return html;
}

// ── send OTP ─────────────────────────────────────────────────────────────────

export async function sendOtp(email: string): Promise<void> {
  // 1. Create user if they don't exist yet
  const user = await getUserByEmail(email);
  if (!user) {
    await db.collection(USERS_COL).add({
      email,
      is_verified: false,
      profileCompleted: false,
      createdAt: FieldValue.serverTimestamp(),
    });
  }

  // 2. Generate OTP and set expiry
  const otp = generateOtp();
  const expiresAt = new Date(Date.now() + OTP_EXPIRY_MINUTES * 60 * 1000);

  // 3. Upsert OTP doc keyed by email (overwrites any previous OTP)
  await db.collection(OTPS_COL).doc(email).set({
    email,
    otp,
    expiresAt: Timestamp.fromDate(expiresAt),
    createdAt: FieldValue.serverTimestamp(),
  });

  // 4. Build HTML from template
  const html = loadTemplate({
    email,
    expiry: String(OTP_EXPIRY_MINUTES),
    digits: buildOtpDigits(otp),
    year: String(new Date().getFullYear()),
  });

  // 5. Send email
  await transporter.sendMail({
    from: `"Monarch" <${process.env.GMAIL_USER}>`,
    to: email,
    subject: "Your verification code",
    html,
    attachments: [
      {
        filename: "Monarch.png",
        path: path.join(__dirname, "../templates/Monarch.png"),
        cid: "monarch_logo", // referenced as cid:monarch_logo in the HTML
      },
    ],
  });
}

// ── verify OTP ────────────────────────────────────────────────────────────────

export type VerifyResult =
  | {
      success: true;
      token: string;
      profileCompleted: false;
    }
  | {
      success: true;
      token: string;
      profileCompleted: true;
      userData: Omit<User, "id">;
    }
  | { success: false; reason: "invalid_otp" | "expired" | "user_not_found" };

export async function verifyOtp(email: string, otp: string): Promise<VerifyResult> {
  // 1. Check OTP doc exists and matches
  const otpDoc = await db.collection(OTPS_COL).doc(email).get();
  if (!otpDoc.exists) {
    return { success: false, reason: "invalid_otp" };
  }

  const record = otpDoc.data()!;

  if (record.otp !== otp) {
    return { success: false, reason: "invalid_otp" };
  }

  // 2. Check expiry
  const expiresAt: Date = (record.expiresAt as Timestamp).toDate();
  if (new Date() > expiresAt) {
    await otpDoc.ref.delete(); // clean up expired OTP
    return { success: false, reason: "expired" };
  }

  // 3. Fetch user
  const user = await getUserByEmail(email);
  if (!user) {
    return { success: false, reason: "user_not_found" };
  }

  // 4. Mark user as verified + ensure profileCompleted exists
  const updateData: Record<string, unknown> = { is_verified: true };
  if (user.profileCompleted === undefined) {
    updateData.profileCompleted = false;
  }
  await db.collection(USERS_COL).doc(user.id).update(updateData);

  // 5. Delete OTP — one-time use
  await otpDoc.ref.delete();

  // 6. Generate Firebase custom token (passwordless auth for Flutter)
  const { admin } = await import("../config/firebase");
  const token = await admin.auth().createCustomToken(email);

  // 7. Return based on profileCompleted
  if (!user.profileCompleted) {
    return { success: true, token, profileCompleted: false };
  }

  // Fetch fresh user data after the update
  const updatedUser = await getUserByEmail(email);
  const { id, ...userData } = updatedUser!;

  return { success: true, token, profileCompleted: true, userData };
}
