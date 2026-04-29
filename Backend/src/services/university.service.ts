import { db } from "../config/firebase";
import { User, LanguageProficiency, FundingType } from "../models/user.model";
import { University, UniversityMatch, MatchBreakdown, MatchInsights } from "../models/university.model";

const UNIVERSITIES_COL = "universities";
const USERS_COL = "users";
const MATCH_RESULTS_COL = "match_results";

// ── Helper: Get user by email ────────────────────────────────────────────────

async function getUserByEmail(email: string): Promise<User | null> {
  const snapshot = await db
    .collection(USERS_COL)
    .where("email", "==", email)
    .limit(1)
    .get();

  if (snapshot.empty) return null;
  const doc = snapshot.docs[0];
  return { id: doc.id, ...doc.data() } as User;
}

// ── Helper: Get all universities ─────────────────────────────────────────────

async function getAllUniversities(): Promise<University[]> {
  const snapshot = await db.collection(UNIVERSITIES_COL).get();
  return snapshot.docs.map((doc) => ({
    id: doc.id,
    ...doc.data(),
  })) as University[];
}

// ── Helper: Calculate best language score ────────────────────────────────────

function getBestLanguageScore(
  userProficiency: LanguageProficiency[],
  universityRequirements: { ielts?: number; toefl?: number; pte?: number; duolingo?: number }
): { score: number; required: number; testType: string } | null {
  const scores: Array<{ score: number; required: number; testType: string; ratio: number }> = [];

  // Check IELTS
  if (universityRequirements.ielts) {
    const userIelts = userProficiency.find((p) => p.test.toUpperCase() === "IELTS");
    if (userIelts) {
      scores.push({
        score: userIelts.score,
        required: universityRequirements.ielts,
        testType: "IELTS",
        ratio: userIelts.score / universityRequirements.ielts,
      });
    }
  }

  // Check TOEFL
  if (universityRequirements.toefl) {
    const userToefl = userProficiency.find((p) => p.test.toUpperCase() === "TOEFL");
    if (userToefl) {
      scores.push({
        score: userToefl.score,
        required: universityRequirements.toefl,
        testType: "TOEFL",
        ratio: userToefl.score / universityRequirements.toefl,
      });
    }
  }

  // Check PTE
  if (universityRequirements.pte) {
    const userPte = userProficiency.find((p) => p.test.toUpperCase() === "PTE");
    if (userPte) {
      scores.push({
        score: userPte.score,
        required: universityRequirements.pte,
        testType: "PTE",
        ratio: userPte.score / universityRequirements.pte,
      });
    }
  }

  // Check Duolingo
  if (universityRequirements.duolingo) {
    const userDuolingo = userProficiency.find((p) => p.test.toUpperCase() === "DUOLINGO");
    if (userDuolingo) {
      scores.push({
        score: userDuolingo.score,
        required: universityRequirements.duolingo,
        testType: "Duolingo",
        ratio: userDuolingo.score / universityRequirements.duolingo,
      });
    }
  }

  // Return the test with the highest ratio (best match)
  if (scores.length === 0) return null;
  
  scores.sort((a, b) => b.ratio - a.ratio);
  return scores[0];
}

// ── Core Algorithm: Calculate Match Percentage ───────────────────────────────
// New Algorithm: 80% Hard Requirements + 20% Soft Requirements

function calculateMatch(user: User, university: University): UniversityMatch {
  // ═══════════════════════════════════════════════════════════════════════════
  // HARD REQUIREMENTS (80 points total)
  // ═══════════════════════════════════════════════════════════════════════════

  // ── 1. Academic Match (40 points max) ────────────────────────────────────

  const gpaRatio = user.gpa! / university.requiredGpa;
  const baseAcademicScore = Math.min(gpaRatio, 1.0) * 35;
  
  // Over-qualification bonus: up to +5 points
  const gpaExcess = Math.max(0, user.gpa! - university.requiredGpa);
  const overqualificationBonus = Math.min(gpaExcess * 5, 5);
  
  const academicMatch = Math.min(baseAcademicScore + overqualificationBonus, 40);

  // ── 2. Language Match (30 points max) ────────────────────────────────────

  let languageMatch = 0;
  let languageStatus: "exceeds" | "meets" | "below" = "below";
  let languageGap = 0;

  const languageResult = getBestLanguageScore(
    user.languageProficiency || [],
    university.languageRequirements
  );

  if (languageResult) {
    const langRatio = languageResult.score / languageResult.required;
    const baseLangScore = Math.min(langRatio, 1.0) * 25;
    
    // Over-qualification bonus: up to +5 points
    const langExcess = Math.max(0, languageResult.score - languageResult.required);
    const langBonus = Math.min(langExcess * 0.5, 5);
    
    languageMatch = Math.min(baseLangScore + langBonus, 30);
    
    languageGap = languageResult.score - languageResult.required;
    if (languageGap > 0) languageStatus = "exceeds";
    else if (languageGap === 0) languageStatus = "meets";
    else languageStatus = "below";
  }

  // ── 3. Financial Match (10 points max) ───────────────────────────────────

  let financialMatch = 0;
  const fundingType = user.fundingType || "selfFunded";

  if (fundingType === "selfFunded") {
    financialMatch = 10;
  } else if (fundingType === "scholarship") {
    if (university.financialAid.acceptsDSU) {
      financialMatch = 10; // Perfect match - public university with DSU
    } else if (university.type === "Private") {
      financialMatch = 5; // Private universities rarely offer full scholarships
    } else {
      financialMatch = 7; // Public but no DSU
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // SOFT REQUIREMENTS (20 points total)
  // These BOOST your chances if you have them
  // ═══════════════════════════════════════════════════════════════════════════

  let personalStatementBonus = 0;
  let recommendationLettersBonus = 0;
  let extracurricularsBonus = 0;
  let workExperienceBonus = 0;

  if (user.hasPersonalStatement) {
    personalStatementBonus = 5;
  }

  if (user.hasRecommendationLetters) {
    recommendationLettersBonus = 5;
  }

  if (user.hasExtracurriculars) {
    extracurricularsBonus = 5;
  }

  if (user.hasWorkExperience) {
    workExperienceBonus = 5;
  }

  const softRequirementsTotal = 
    personalStatementBonus + 
    recommendationLettersBonus + 
    extracurricularsBonus + 
    workExperienceBonus;

  // ═══════════════════════════════════════════════════════════════════════════
  // TOTAL MATCH PERCENTAGE
  // ═══════════════════════════════════════════════════════════════════════════

  const hardRequirementsTotal = academicMatch + languageMatch + financialMatch;
  const matchPercentage = Math.round(hardRequirementsTotal + softRequirementsTotal);

  // ── GPA Insights ─────────────────────────────────────────────────────────

  const gpaGap = user.gpa! - university.requiredGpa;
  let gpaStatus: "exceeds" | "meets" | "below" = "below";
  if (gpaGap > 0) gpaStatus = "exceeds";
  else if (gpaGap === 0) gpaStatus = "meets";

  // Check if user meets minimum requirements
  const meetsMinimumRequirements = 
    user.gpa! >= university.requiredGpa && 
    languageGap >= 0;

  // Count soft requirements
  const softRequirementsCount = 
    (user.hasPersonalStatement ? 1 : 0) +
    (user.hasRecommendationLetters ? 1 : 0) +
    (user.hasExtracurriculars ? 1 : 0) +
    (user.hasWorkExperience ? 1 : 0);

  // ── Determine Admission Chance ───────────────────────────────────────────

  let admissionChance: "Safety" | "Target" | "Reach" | "Long Shot";
  let recommendation: string;

  if (!meetsMinimumRequirements) {
    admissionChance = "Long Shot";
    recommendation = "You don't meet minimum requirements. Admission is unlikely unless you have exceptional soft requirements or improve your profile.";
  } else if (matchPercentage >= 85) {
    admissionChance = "Safety";
    recommendation = "Very high chance of admission. You exceed requirements and have strong supporting materials.";
  } else if (matchPercentage >= 70) {
    admissionChance = "Target";
    recommendation = "Good chance of admission. You meet requirements well.";
  } else if (matchPercentage >= 55) {
    admissionChance = "Reach";
    recommendation = "Moderate chance. Meeting minimum requirements but competitive.";
  } else {
    admissionChance = "Long Shot";
    recommendation = "Low chance. Consider improving your profile or adding soft requirements.";
  }

  // ── Build Response ───────────────────────────────────────────────────────

  return {
    ...university,
    matchPercentage,
    breakdown: {
      academicMatch: Math.round(academicMatch),
      languageMatch: Math.round(languageMatch),
      financialMatch: Math.round(financialMatch),
      personalStatementBonus: Math.round(personalStatementBonus),
      recommendationLettersBonus: Math.round(recommendationLettersBonus),
      extracurricularsBonus: Math.round(extracurricularsBonus),
      workExperienceBonus: Math.round(workExperienceBonus),
    },
    insights: {
      gpaStatus,
      gpaGap: parseFloat(gpaGap.toFixed(2)),
      languageStatus,
      languageGap: parseFloat(languageGap.toFixed(1)),
      meetsMinimumRequirements,
      softRequirementsCount,
    },
    admissionChance,
    recommendation,
  };
}

// ── Main Service Function ────────────────────────────────────────────────────

export type GetMatchesResult =
  | { success: true; matches: UniversityMatch[] }
  | { success: false; reason: "user_not_found" | "profile_incomplete" };

export async function getUniversityMatches(email: string): Promise<GetMatchesResult> {
  // 1. Get user by email
  const user = await getUserByEmail(email);
  if (!user) {
    return { success: false, reason: "user_not_found" };
  }

  // 2. Validate profile is complete
  if (!user.profileCompleted || !user.gpa) {
    console.log("Profile incomplete for user:", email, {
      profileCompleted: user.profileCompleted,
      hasGpa: !!user.gpa,
      hasFundingType: !!user.fundingType,
      hasLanguageProficiency: !!(user.languageProficiency && user.languageProficiency.length > 0)
    });
    return { success: false, reason: "profile_incomplete" };
  }

  // If fundingType is missing, default to selfFunded for backward compatibility
  if (!user.fundingType) {
    console.log("FundingType missing for user:", email, "- defaulting to selfFunded");
    user.fundingType = "selfFunded";
  }

  // 3. Get all universities
  const universities = await getAllUniversities();

  // 4. Calculate matches for each university
  const allMatches = universities.map((uni) => calculateMatch(user, uni));

  // 5. Filter: Only show universities where user meets MINIMUM requirements
  const filteredMatches = allMatches.filter((match) => match.insights.meetsMinimumRequirements);

  // 6. Sort by match percentage (descending)
  filteredMatches.sort((a, b) => b.matchPercentage - a.matchPercentage);

  console.log(`Total universities: ${universities.length}, Meets requirements: ${filteredMatches.length}, Filtered out: ${universities.length - filteredMatches.length}`);

  // 7. Save results to match_results collection (upsert by email)
  await db.collection(MATCH_RESULTS_COL).doc(email).set({
    email,
    calculatedAt: new Date().toISOString(),
    totalMatched: filteredMatches.length,
    universities: filteredMatches.map((match) => ({
      universityId: match.id,
      name: match.name,
      location: match.location,
      imageUrl: match.imageUrl,
      matchPercentage: match.matchPercentage,
      admissionChance: match.admissionChance,
      breakdown: match.breakdown,
    })),
  });

  console.log(`Saved match results for ${email} to match_results collection`);

  return { success: true, matches: filteredMatches };
}

// ── Get Saved Match Results ──────────────────────────────────────────────────

export type GetSavedMatchesResult =
  | { success: true; data: FirebaseFirestore.DocumentData }
  | { success: false; reason: "not_found" };

export async function getSavedMatches(email: string): Promise<GetSavedMatchesResult> {
  const doc = await db.collection(MATCH_RESULTS_COL).doc(email).get();

  if (!doc.exists) {
    return { success: false, reason: "not_found" };
  }

  return { success: true, data: doc.data()! };
}
