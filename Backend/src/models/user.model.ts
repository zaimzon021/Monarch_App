import { Timestamp } from "firebase-admin/firestore";

export interface LanguageProficiency {
  test: string;   // e.g. "IELTS", "TOEFL"
  score: number;
}

export type FundingType = "scholarship" | "selfFunded";

export interface User {
  id: string;
  email: string;
  is_verified: boolean;
  profileCompleted: boolean;
  createdAt: Timestamp | Date;

  // Profile fields (present only after create-profile)
  fullName?: string;
  location?: string;
  academicLevel?: string;
  gpa?: number;
  studyDestination?: string[];  // Changed to array for multiple destinations
  languageProficiency?: LanguageProficiency[];
  fundingType?: FundingType;
  entranceExams?: string[];
  
  // Soft requirements (optional - boost chances if present)
  hasPersonalStatement?: boolean;
  hasRecommendationLetters?: boolean;
  hasExtracurriculars?: boolean;
  hasWorkExperience?: boolean;
}

export type CreateUserDTO = Pick<User, "email">;

export interface CreateProfileDTO {
  email: string;
  fullName: string;
  location: string;
  academicLevel: string;
  gpa: number;
  studyDestination: string[];  // Changed to array
  languageProficiency: LanguageProficiency[];
  fundingType: FundingType;
  entranceExams: string[];
}
