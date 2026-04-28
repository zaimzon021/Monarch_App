import { Router } from "express";
import { ProfileController } from "../controllers/profile.controller";

const router = Router();

router.post("/create-profile", ProfileController.createProfile);

export default router;
