import { Request, Response } from "express";
import { sendOtp, verifyOtp } from "../services/auth.service";

// Basic email format check
function isValidEmail(email: string): boolean {
  return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email);
}

export const AuthController = {
  async sendOtp(req: Request, res: Response): Promise<void> {
    const { email } = req.body;

    if (!email || !isValidEmail(email)) {
      res.status(400).json({ success: false, message: "A valid email is required" });
      return;
    }

    try {
      await sendOtp(email.toLowerCase().trim());
      res.status(200).json({ success: true, message: "OTP sent to " + email });
    } catch (err) {
      console.error("sendOtp error:", err);
      res.status(500).json({ success: false, message: "Failed to send OTP" });
    }
  },

  async verifyOtp(req: Request, res: Response): Promise<void> {
    const { email, otp } = req.body;

    if (!email || !otp) {
      res.status(400).json({ success: false, message: "email and otp are required" });
      return;
    }

    if (!/^\d{4}$/.test(otp)) {
      res.status(400).json({ success: false, message: "OTP must be a 4-digit number" });
      return;
    }

    try {
      const result = await verifyOtp(email.toLowerCase().trim(), otp);

      if (!result.success) {
        const messages: Record<string, string> = {
          invalid_otp: "Invalid OTP",
          expired: "OTP has expired, please request a new one",
          user_not_found: "No account found for this email",
        };
        res.status(400).json({ success: false, message: messages[result.reason] });
        return;
      }

      // Build response based on profileCompleted
      if (!result.profileCompleted) {
        res.status(200).json({
          message: "OTP Verified",
          token: result.token,
          profileCompleted: false,
        });
      } else {
        res.status(200).json({
          message: "OTP Verified",
          token: result.token,
          profileCompleted: true,
          userData: result.userData,
        });
      }
    } catch (err) {
      console.error("verifyOtp error:", err);
      res.status(500).json({ success: false, message: "Verification failed" });
    }
  },
};
