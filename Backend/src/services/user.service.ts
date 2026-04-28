// Service: all Firestore business logic lives here

import { db } from "../config/firebase";
import { User, CreateUserDTO } from "../models/user.model";
import { FieldValue } from "firebase-admin/firestore";

const COLLECTION = "users";

export const UserService = {
  async getAll(): Promise<User[]> {
    const snapshot = await db.collection(COLLECTION).orderBy("createdAt", "desc").get();
    return snapshot.docs.map((doc) => ({ id: doc.id, ...doc.data() } as User));
  },

  async getById(id: string): Promise<User | null> {
    const doc = await db.collection(COLLECTION).doc(id).get();
    if (!doc.exists) return null;
    return { id: doc.id, ...doc.data() } as User;
  },

  async create(data: CreateUserDTO): Promise<User> {
    const ref = await db.collection(COLLECTION).add({
      ...data,
      is_verified: false,
      createdAt: FieldValue.serverTimestamp(),
    });
    const created = await ref.get();
    return { id: created.id, ...created.data() } as User;
  },

  async delete(id: string): Promise<boolean> {
    const ref = db.collection(COLLECTION).doc(id);
    const doc = await ref.get();
    if (!doc.exists) return false;
    await ref.delete();
    return true;
  },
};
