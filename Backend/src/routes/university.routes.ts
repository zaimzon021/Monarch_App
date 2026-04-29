import { Router } from "express";
import { UniversityController } from "../controllers/university.controller";

const router = Router();

// Calculate matches + auto-save to match_results collection
router.post("/match", UniversityController.getMatches);

// Retrieve previously saved match results
router.post("/matched", UniversityController.getMatchedUniversities);

// Get application requirements for a specific university
router.get("/:uniId/requirements", UniversityController.getRequirements);

// Get apply link for a specific university
router.get("/:uniId/link", UniversityController.getLink);

export default router;
