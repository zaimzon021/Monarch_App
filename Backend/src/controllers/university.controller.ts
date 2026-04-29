import { Request, Response } from "express";
import { getUniversityMatches, getSavedMatches } from "../services/university.service";

export const UniversityController = {

  async getMatches(req: Request, res: Response): Promise<void> {
    try {
      const { email } = req.body;

      if (!email || typeof email !== "string") {
        res.status(400).json({ success: false, message: "email is required" });
        return;
      }

      console.log("Getting matches for email:", email);

      const result = await getUniversityMatches(email.toLowerCase().trim());

      if (!result.success) {
        const messages: Record<string, string> = {
          user_not_found: "No account found for this email",
          profile_incomplete: "Please complete your profile first to get university recommendations",
        };
        res.status(result.reason === "user_not_found" ? 404 : 400).json({
          success: false,
          message: messages[result.reason],
        });
        return;
      }

      console.log(`Successfully calculated and saved matches for ${result.matches.length} universities`);

      res.status(200).json({
        success: true,
        data: result.matches,
        meta: {
          totalUniversities: result.matches.length,
          calculatedAt: new Date().toISOString(),
        },
      });
    } catch (err) {
      console.error("getMatches error:", err);
      res.status(500).json({ success: false, message: "Failed to calculate university matches" });
    }
  },

  async getMatchedUniversities(req: Request, res: Response): Promise<void> {
    try {
      const { email } = req.body;

      if (!email || typeof email !== "string") {
        res.status(400).json({ success: false, message: "email is required" });
        return;
      }

      const result = await getSavedMatches(email.toLowerCase().trim());

      if (!result.success) {
        res.status(404).json({
          success: false,
          message: "No saved matches found for this email. Please call /api/universities/match first.",
        });
        return;
      }

      res.status(200).json({
        success: true,
        data: result.data,
      });
    } catch (err) {
      console.error("getMatchedUniversities error:", err);
      res.status(500).json({ success: false, message: "Failed to retrieve matched universities" });
    }
  },
};
