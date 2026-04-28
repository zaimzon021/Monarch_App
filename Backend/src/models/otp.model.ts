import { Timestamp } from "firebase-admin/firestore";

export interface OtpRecord {
  email: string;
  otp: string;
  expiresAt: Timestamp | Date;
  createdAt: Timestamp | Date;
}
