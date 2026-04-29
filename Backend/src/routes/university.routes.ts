import { Router } from "express";
import { UniversityController } from "../controllers/university.controller";

const router = Router();

// Calculate matches + auto-save to match_results collection
router.post("/match", UniversityController.getMatches);

// Retrieve previously saved match results
router.post("/matched", UniversityController.getMatchedUniversities);

export default router;
