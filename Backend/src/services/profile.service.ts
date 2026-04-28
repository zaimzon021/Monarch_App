import { db } from "../config/firebase";
import { CreateProfileDTO, User } from "../models/user.model";

const USERS_COL = "users";

async function getUserByEmail(email: string): Promise<{ id: string; data: FirebaseFirestore.DocumentData } | null> {
  const snapshot = await db
    .collection(USERS_COL)
    .where("email", "==", email)
    .limit(1)
    .get();

  if (snapshot.empty) return null;
  const doc = snapshot.docs[0];
  return { id: doc.id, data: doc.data() };
}

export type CreateProfileResult =
  | { success: true; userData: Omit<User, "id"> }
  | { success: false; reason: "user_not_found" | "not_verified" | "already_completed" };

export async function createProfile(dto: CreateProfileDTO): Promise<CreateProfileResult> {
  // 1. Find user by email
  const found = await getUserByEmail(dto.email);
  if (!found) {
    return { success: false, reason: "user_not_found" };
  }

  // 2. Must be verified before completing profile
  if (!found.data.is_verified) {
    return { success: false, reason: "not_verified" };
  }

  // 3. Write profile fields + mark profileCompleted
  const { email, ...profileFields } = dto;
  await db.collection(USERS_COL).doc(found.id).update({
    ...profileFields,
    profileCompleted: true,
  });

  // 4. Return the full updated user doc
  const updated = await db.collection(USERS_COL).doc(found.id).get();
  const userData = updated.data() as Omit<User, "id">;

  return { success: true, userData };
}
