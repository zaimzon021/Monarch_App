import { Request, Response } from "express";
import { createProfile } from "../services/profile.service";
import { CreateProfileDTO, FundingType, LanguageProficiency } from "../models/user.model";

export const ProfileController = {
  async createProfile(req: Request, res: Response): Promise<void> {
    const {
      email,
      fullName,
      location,
      academicLevel,
      gpa,
      studyDestination,
      languageProficiency,
      fundingType,
      entranceExams,
    } = req.body;

    // ── Validation ────────────────────────────────────────────────────────────

    if (!email || !fullName || !location || !academicLevel) {
      res.status(400).json({
        success: false,
        message: "email, fullName, location, and academicLevel are required",
      });
      return;
    }

    // Validate studyDestination is an array
    if (!Array.isArray(studyDestination) || studyDestination.length === 0) {
      res.status(400).json({
        success: false,
        message: "studyDestination must be a non-empty array (e.g., ['Italy', 'Germany'])",
      });
      return;
    }

    if (typeof gpa !== "number" || gpa < 0 || gpa > 4) {
      res.status(400).json({ success: false, message: "gpa must be a number between 0 and 4" });
      return;
    }

    const validFundingTypes: FundingType[] = ["scholarship", "selfFunded"];
    if (!validFundingTypes.includes(fundingType)) {
      res.status(400).json({
        success: false,
        message: `fundingType must be one of: ${validFundingTypes.join(", ")}`,
      });
      return;
    }

    // languageProficiency — optional array, defaults to []
    const proficiency: LanguageProficiency[] = Array.isArray(languageProficiency)
      ? languageProficiency
      : [];

    for (const entry of proficiency) {
      if (!entry.test || typeof entry.score !== "number") {
        res.status(400).json({
          success: false,
          message: "Each languageProficiency entry must have { test: string, score: number }",
        });
        return;
      }
    }

    // entranceExams — optional array, defaults to []
    const exams: string[] = Array.isArray(entranceExams) ? entranceExams : [];

    const validExams = ["TOLC", "CENS"];
    for (const exam of exams) {
      if (!validExams.includes(exam.toUpperCase())) {
        res.status(400).json({
          success: false,
          message: `Invalid entrance exam "${exam}". Allowed values: ${validExams.join(", ")}`,
        });
        return;
      }
    }

    // ── Call service ──────────────────────────────────────────────────────────

    const dto: CreateProfileDTO = {
      email: email.toLowerCase().trim(),
      fullName: fullName.trim(),
      location: location.trim(),
      academicLevel: academicLevel.trim(),
      gpa,
      studyDestination: studyDestination.map((dest: string) => dest.trim()),
      languageProficiency: proficiency,
      fundingType,
      entranceExams: exams.map((e: string) => e.toUpperCase()),
    };

    try {
      const result = await createProfile(dto);

      if (!result.success) {
        const messages: Record<string, string> = {
          user_not_found: "No account found for this email",
          not_verified: "Email is not verified. Please verify your OTP first",
          already_completed: "Profile has already been completed",
        };
        res.status(400).json({ success: false, message: messages[result.reason] });
        return;
      }

      res.status(200).json({
        success: true,
        message: "Profile created successfully",
        userData: result.userData,
      });
    } catch (err) {
      console.error("createProfile error:", err);
      res.status(500).json({ success: false, message: "Failed to create profile" });
    }
  },
};
