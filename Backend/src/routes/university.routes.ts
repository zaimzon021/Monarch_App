import { Router } from "express";
import { UniversityController } from "../controllers/university.controller";

const router = Router();

router.post("/match", UniversityController.getMatches);

export default router;
