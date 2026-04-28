// Controller: handles HTTP request/response, delegates logic to the service

import { Request, Response } from "express";
import { UserService } from "../services/user.service";

export const UserController = {
  async getAll(req: Request, res: Response): Promise<void> {
    try {
      const users = await UserService.getAll();
      res.status(200).json({ success: true, data: users });
    } catch (err) {
      res.status(500).json({ success: false, message: "Failed to fetch users" });
    }
  },

  async getById(req: Request<{ id: string }>, res: Response): Promise<void> {
    try {
      const user = await UserService.getById(req.params.id);
      if (!user) {
        res.status(404).json({ success: false, message: "User not found" });
        return;
      }
      res.status(200).json({ success: true, data: user });
    } catch (err) {
      res.status(500).json({ success: false, message: "Failed to fetch user" });
    }
  },

  async create(req: Request, res: Response): Promise<void> {
    try {
      const { email } = req.body;
      if (!email) {
        res.status(400).json({ success: false, message: "email is required" });
        return;
      }
      const user = await UserService.create({ email });
      res.status(201).json({ success: true, data: user });
    } catch (err) {
      res.status(500).json({ success: false, message: "Failed to create user" });
    }
  },

  async delete(req: Request<{ id: string }>, res: Response): Promise<void> {
    try {
      const deleted = await UserService.delete(req.params.id);
      if (!deleted) {
        res.status(404).json({ success: false, message: "User not found" });
        return;
      }
      res.status(200).json({ success: true, message: "User deleted" });
    } catch (err) {
      res.status(500).json({ success: false, message: "Failed to delete user" });
    }
  },
};
