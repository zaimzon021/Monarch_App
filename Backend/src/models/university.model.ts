export interface LanguageRequirements {
  ielts?: number;
  toefl?: number;
  pte?: number;      // Pearson Test of English
  duolingo?: number; // Duolingo English Test
}

export interface FinancialAid {
  acceptsDSU: boolean;
  regionalBody: string;
}

export interface University {
  id: string;
  name: string;
  location: string;
  type: "Public" | "Private";
  worldRank: number;
  acceptanceRate: number;
  tuitionFee: string;
  requiredGpa: number;
  languageRequirements: LanguageRequirements;
  programs: string[];
  financialAid: FinancialAid;
  imageUrl: string;
}

export interface MatchBreakdown {
  // Hard Requirements (80 points)
  academicMatch: number;      // 0-40
  languageMatch: number;      // 0-30
  financialMatch: number;     // 0-10
  
  // Soft Requirements (20 points)
  personalStatementBonus: number;      // 0-5
  recommendationLettersBonus: number;  // 0-5
  extracurricularsBonus: number;       // 0-5
  workExperienceBonus: number;         // 0-5
}

export interface MatchInsights {
  gpaStatus: "exceeds" | "meets" | "below";
  gpaGap: number;
  languageStatus: "exceeds" | "meets" | "below";
  languageGap: number;
  meetsMinimumRequirements: boolean;
  softRequirementsCount: number;  // 0-4 (how many soft requirements user has)
}

export interface UniversityMatch extends University {
  matchPercentage: number;
  breakdown: MatchBreakdown;
  insights: MatchInsights;
  admissionChance: "Safety" | "Target" | "Reach" | "Long Shot";
  recommendation: string;
}
