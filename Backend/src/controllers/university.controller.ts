import { Request, Response } from "express";
import { getUniversityMatches } from "../services/university.service";

export const UniversityController = {
  /**
   * GET /api/universities/match
   * Body: { email: string }
   * 
   * Returns a sorted list of universities with match percentages
   * based on the user's profile (GPA, language scores, funding type).
   */
  async getMatches(req: Request, res: Response): Promise<void> {
    try {
      const { email } = req.body;

      // Validation
      if (!email || typeof email !== "string") {
        res.status(400).json({
          success: false,
          message: "email is required",
        });
        return;
      }

      console.log("Getting matches for email:", email);

      // Call service
      const result = await getUniversityMatches(email.toLowerCase().trim());

      if (!result.success) {
        const messages: Record<string, string> = {
          user_not_found: "No account found for this email",
          profile_incomplete: "Please complete your profile first to get university recommendations",
        };
        
        const statusCode = result.reason === "user_not_found" ? 404 : 400;
        
        console.log("Match calculation failed:", result.reason);
        
        res.status(statusCode).json({
          success: false,
          message: messages[result.reason],
        });
        return;
      }

      console.log(`Successfully calculated matches for ${result.matches.length} universities`);

      // Success response
      res.status(200).json({
        success: true,
        data: result.matches,
        meta: {
          totalUniversities: result.matches.length,
          calculatedAt: new Date().toISOString(),
          filteringLogic: "Only showing universities where you meet BOTH minimum GPA and Language requirements",
          algorithm: "80% Hard Requirements + 20% Soft Requirements",
        },
      });
    } catch (err) {
      console.error("getMatches error:", err);
      res.status(500).json({
        success: false,
        message: "Failed to calculate university matches",
      });
    }
  },
};
