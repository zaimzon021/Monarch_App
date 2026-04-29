import dotenv from "dotenv";
dotenv.config();
import { db } from "../config/firebase";

const universitiesRequirements = [
  {
    uniId: "uni_001",
    name: "Politecnico di Milano (PoliMi)",
    location: "Milan, Lombardy",
    applicationRequirements: [
      {
        reqId: "req_polimi_transcripts",
        type: "document",
        title: "HEC Attested Transcripts & Degree",
        generalGuide: "Official Bachelor's degree and all semester transcripts.",
        localInstructions:
          "Must be physically attested by the Higher Education Commission (HEC) in Pakistan. Book an appointment via the HEC portal.",
        isRequired: true,
        guideAvailable: true,
        sampleImageUrl:
          "https://res.cloudinary.com/dhxr1x9sx/image/upload/v1777465204/HEC_Attested_Degree_fvlfk5.jpg",
        physicalLocation: {
          name: "HEC Head Office, Islamabad",
          lat: 33.6601,
          lng: 73.044,
        },
      },
      {
        reqId: "req_polimi_mofa",
        type: "document",
        title: "MOFA Attestation",
        generalGuide: "Legalization of your HEC-attested educational documents.",
        localInstructions:
          "After HEC, you must take the documents to the Ministry of Foreign Affairs. Go early in the morning or use a courier service like TCS if you cannot visit in person.",
        isRequired: true,
        guideAvailable: true,
        sampleImageUrl:
          "https://res.cloudinary.com/dhxr1x9sx/image/upload/v1777465203/MOFA_Attestation_eqa3ht.jpg",
        physicalLocation: {
          name: "Ministry of Foreign Affairs (MOFA)",
          lat: 33.7297,
          lng: 73.0975,
        },
      },
      {
        reqId: "req_polimi_translation",
        type: "document",
        title: "Italian Translation",
        generalGuide: "Translation of your degree and transcripts into Italian.",
        localInstructions:
          "Use ONLY a translator officially recognized by the Italian Embassy in Islamabad (e.g., A.M. Translations). Do not use random local notaries.",
        isRequired: true,
        guideAvailable: true,
        sampleImageUrl:
          "https://res.cloudinary.com/dhxr1x9sx/image/upload/v1777465205/Italian_Translation_b5vqjg.jpg",
        physicalLocation: null,
      },
      {
        reqId: "req_polimi_cimea",
        type: "document",
        title: "CIMEA Statement of Comparability",
        generalGuide: "Proof that your 16 years of education matches the Italian system.",
        localInstructions:
          "Do not wait for the Embassy DOV. Create an account on the CIMEA Diplome platform online. Costs ~€150 and takes 30-60 days digitally.",
        isRequired: true,
        guideAvailable: true,
        sampleImageUrl:
          "https://res.cloudinary.com/dhxr1x9sx/image/upload/v1777465203/CIMEA_Certificate_umxkau.webp",
        physicalLocation: null,
      },
      {
        reqId: "req_polimi_lang",
        type: "exam",
        title: "IELTS Academic",
        generalGuide: "Minimum IELTS Academic 6.0.",
        localInstructions:
          "Book via British Council or AEO Pakistan. Ensure you select the 'Academic' module.",
        isRequired: true,
        guideAvailable: true,
        sampleImageUrl:
          "https://res.cloudinary.com/dhxr1x9sx/image/upload/v1777465204/IELTS_Certificate_zgjhkx.webp",
        physicalLocation: {
          name: "AEO Pakistan, Lahore",
          lat: 31.516,
          lng: 74.3486,
        },
      },
      {
        reqId: "req_polimi_dsu",
        type: "document",
        title: "DSU Scholarship Docs (EDISU)",
        generalGuide: "Financial documents proving family income for tuition waivers.",
        localInstructions:
          "Obtain Family Registration Certificate (FRC) from NADRA, father's FBR Tax Returns, and property valuation. Must be translated and legalized.",
        isRequired: true,
        guideAvailable: true,
        sampleImageUrl:
          "https://res.cloudinary.com/dhxr1x9sx/image/upload/v1777465203/DSU_Scholarship_kceloo.webp",
        physicalLocation: null,
      },
    ],
  },
  {
    uniId: "uni_002",
    name: "Sapienza University of Rome",
    location: "Rome, Lazio",
    applicationRequirements: [
      {
        reqId: "req_sap_transcripts",
        type: "document",
        title: "HEC Attested Transcripts & Degree",
        generalGuide: "Official Bachelor's degree and all semester transcripts.",
        localInstructions:
          "Must be physically attested by the Higher Education Commission (HEC) in Pakistan.",
        isRequired: true,
        guideAvailable: true,
        sampleImageUrl:
          "https://res.cloudinary.com/dhxr1x9sx/image/upload/v1777465204/HEC_Attested_Degree_fvlfk5.jpg",
        physicalLocation: {
          name: "HEC Head Office, Islamabad",
          lat: 33.6601,
          lng: 73.044,
        },
      },
      {
        reqId: "req_sap_mofa",
        type: "document",
        title: "MOFA Attestation",
        generalGuide: "Legalization of your HEC-attested educational documents.",
        localInstructions:
          "Required before you can apply for the Declaration of Value or visa.",
        isRequired: true,
        guideAvailable: true,
        sampleImageUrl:
          "https://res.cloudinary.com/dhxr1x9sx/image/upload/v1777465203/MOFA_Attestation_eqa3ht.jpg",
        physicalLocation: {
          name: "Ministry of Foreign Affairs (MOFA)",
          lat: 33.7297,
          lng: 73.0975,
        },
      },
      {
        reqId: "req_sap_cimea",
        type: "document",
        title: "CIMEA or DOV",
        generalGuide: "Verification of your degree equivalency.",
        localInstructions:
          "Sapienza accepts both DOV (from Embassy) and CIMEA. CIMEA is much faster for Pakistani applicants.",
        isRequired: true,
        guideAvailable: true,
        sampleImageUrl:
          "https://res.cloudinary.com/dhxr1x9sx/image/upload/v1777465203/CIMEA_Certificate_umxkau.webp",
        physicalLocation: null,
      },
      {
        reqId: "req_sap_infostud",
        type: "process",
        title: "InfoStud Registration",
        generalGuide: "Mandatory registration on the Sapienza InfoStud portal.",
        localInstructions:
          "Register online. If your passport does not have a separate surname, enter your full name in the Surname field and a dot (.) in the Name field.",
        isRequired: true,
        guideAvailable: true,
        sampleImageUrl:
          "https://res.cloudinary.com/dhxr1x9sx/image/upload/v1777465205/InfoStud_Registration_ns9nxn.png",
        physicalLocation: null,
      },
      {
        reqId: "req_sap_tolc",
        type: "exam",
        title: "TOLC Exam",
        generalGuide: "Specific programs require passing the TOLC-I or TOLC-E via CISIA.",
        localInstructions:
          "Register for TOLC@HOME to take it remotely from Pakistan. Proctoring is very strict.",
        isRequired: false,
        guideAvailable: true,
        sampleImageUrl:
          null,
        physicalLocation: null,
      },
      {
        reqId: "req_sap_laziodisco",
        type: "document",
        title: "LazioDisco Scholarship",
        generalGuide: "Regional scholarship for the Lazio region.",
        localInstructions:
          "Requires translated NADRA FRC and FBR Wealth statements. Ensure values perfectly match your bank statements.",
        isRequired: true,
        guideAvailable: true,
        sampleImageUrl:
          "https://res.cloudinary.com/dhxr1x9sx/image/upload/v1777465209/LazioDisco_Scholarship_d3mdqc.png",
        physicalLocation: null,
      },
    ],
  },
  {
    uniId: "uni_003",
    name: "University of Bologna (Unibo)",
    location: "Bologna, Emilia-Romagna",
    applicationRequirements: [
      {
        reqId: "req_unibo_transcripts",
        type: "document",
        title: "HEC Attested Transcripts & Degree",
        generalGuide: "Official Bachelor's degree and all semester transcripts.",
        localInstructions:
          "Must be physically attested by the Higher Education Commission (HEC) in Pakistan.",
        isRequired: true,
        guideAvailable: true,
        sampleImageUrl:
          "https://res.cloudinary.com/dhxr1x9sx/image/upload/v1777465204/HEC_Attested_Degree_fvlfk5.jpg",
        physicalLocation: {
          name: "HEC Head Office, Islamabad",
          lat: 33.6601,
          lng: 73.044,
        },
      },
      {
        reqId: "req_unibo_mofa",
        type: "document",
        title: "MOFA Attestation",
        generalGuide: "Legalization of your HEC-attested educational documents.",
        localInstructions:
          "Required before applying for the Declaration of Value or visa.",
        isRequired: true,
        guideAvailable: true,
        sampleImageUrl:
          "https://res.cloudinary.com/dhxr1x9sx/image/upload/v1777465203/MOFA_Attestation_eqa3ht.jpg",
        physicalLocation: {
          name: "Ministry of Foreign Affairs (MOFA)",
          lat: 33.7297,
          lng: 73.0975,
        },
      },
      {
        reqId: "req_unibo_cimea",
        type: "document",
        title: "CIMEA or DOV",
        generalGuide: "Verification of your degree equivalency.",
        localInstructions:
          "Unibo accepts both. Apply for CIMEA as it is digital and avoids Embassy delays.",
        isRequired: true,
        guideAvailable: true,
        sampleImageUrl:
          "https://res.cloudinary.com/dhxr1x9sx/image/upload/v1777465203/CIMEA_Certificate_umxkau.webp",
        physicalLocation: null,
      },
      {
        reqId: "req_unibo_sat",
        type: "exam",
        title: "SAT or GRE Score",
        generalGuide: "Highly prioritizes SAT/GRE to bypass local entrance exams.",
        localInstructions:
          "Book via College Board. A high SAT score (1300+) virtually guarantees admission to Unibo's economics/business bachelors.",
        isRequired: false,
        guideAvailable: true,
        sampleImageUrl:
          null,
        physicalLocation: {
          name: "USEFP Testing Center (Lahore)",
          lat: 31.5303,
          lng: 74.3469,
        },
      },
      {
        reqId: "req_unibo_ergo",
        type: "document",
        title: "ISEE Parificato (ER.GO)",
        generalGuide:
          "Economic indicator certificate required for the ER.GO regional scholarship.",
        localInstructions:
          "You MUST email your legalized, translated NADRA and FBR docs to an Italian CAF via email. They will generate the ISEE and send it to Unibo.",
        isRequired: true,
        guideAvailable: true,
        sampleImageUrl:
          "https://res.cloudinary.com/dhxr1x9sx/image/upload/v1777465205/ISEE_Parificato_ER.GO_dcqkfy.webp",
        physicalLocation: null,
      },
    ],
  },
  {
    uniId: "uni_004",
    name: "Politecnico di Torino (PoliTo)",
    location: "Turin, Piedmont",
    applicationRequirements: [
      {
        reqId: "req_polito_transcripts",
        type: "document",
        title: "HEC Attested Transcripts & Degree",
        generalGuide: "Official Bachelor's degree and all semester transcripts.",
        localInstructions:
          "Must be physically attested by the Higher Education Commission (HEC) in Pakistan.",
        isRequired: true,
        guideAvailable: true,
        sampleImageUrl:
          "https://res.cloudinary.com/dhxr1x9sx/image/upload/v1777465204/HEC_Attested_Degree_fvlfk5.jpg",
        physicalLocation: {
          name: "HEC Head Office, Islamabad",
          lat: 33.6601,
          lng: 73.044,
        },
      },
      {
        reqId: "req_polito_mofa",
        type: "document",
        title: "MOFA Attestation",
        generalGuide: "Legalization of your HEC-attested educational documents.",
        localInstructions:
          "Required before applying for the Declaration of Value or visa.",
        isRequired: true,
        guideAvailable: true,
        sampleImageUrl:
          "https://res.cloudinary.com/dhxr1x9sx/image/upload/v1777465203/MOFA_Attestation_eqa3ht.jpg",
        physicalLocation: {
          name: "Ministry of Foreign Affairs (MOFA)",
          lat: 33.7297,
          lng: 73.0975,
        },
      },
      {
        reqId: "req_polito_cimea",
        type: "document",
        title: "CIMEA or DOV",
        generalGuide: "Verification of your degree equivalency.",
        localInstructions:
          "Upload HEC-attested documents to the CIMEA portal.",
        isRequired: true,
        guideAvailable: true,
        sampleImageUrl:
          "https://res.cloudinary.com/dhxr1x9sx/image/upload/v1777465203/CIMEA_Certificate_umxkau.webp",
        physicalLocation: null,
      },
      {
        reqId: "req_polito_lang",
        type: "exam",
        title: "IELTS Academic",
        generalGuide: "English Proficiency Certificate.",
        localInstructions:
          "PoliTo is strict on language. Provide an official IELTS TRF.",
        isRequired: true,
        guideAvailable: true,
        sampleImageUrl:
          "https://res.cloudinary.com/dhxr1x9sx/image/upload/v1777465204/IELTS_Certificate_zgjhkx.webp",
        physicalLocation: {
          name: "British Council, Islamabad",
          lat: 33.7182,
          lng: 73.0694,
        },
      },
      {
        reqId: "req_polito_til",
        type: "exam",
        title: "TIL-I Exam",
        generalGuide:
          "Online entrance test specifically for engineering bachelor's degrees at PoliTo.",
        localInstructions:
          "The Math section is notoriously difficult and heavily focuses on calculus. Taken remotely from Pakistan.",
        isRequired: false,
        guideAvailable: true,
        sampleImageUrl:
          "https://res.cloudinary.com/dhxr1x9sx/image/upload/v1777465203/TIL-I_Exam_e8tnts.png",
        physicalLocation: null,
      },
      {
        reqId: "req_polito_edisu",
        type: "document",
        title: "EDISU Piemonte Scholarship",
        generalGuide: "Regional scholarship for the Piedmont region.",
        localInstructions:
          "Requires translated and legalized NADRA FRC and FBR Wealth statements.",
        isRequired: true,
        guideAvailable: true,
        sampleImageUrl:
          "https://res.cloudinary.com/dhxr1x9sx/image/upload/v1777465204/EDISU_Piemonte_Scholarship_vr4cv9.webp",
        physicalLocation: null,
      },
    ],
  },
  {
    uniId: "uni_005",
    name: "University of Padua (UniPd)",
    location: "Padua, Veneto",
    applicationRequirements: [
      {
        reqId: "req_unipd_transcripts",
        type: "document",
        title: "HEC Attested Transcripts & Degree",
        generalGuide: "Official Bachelor's degree and all semester transcripts.",
        localInstructions:
          "Must be physically attested by the Higher Education Commission (HEC) in Pakistan.",
        isRequired: true,
        guideAvailable: true,
        sampleImageUrl:
          "https://res.cloudinary.com/dhxr1x9sx/image/upload/v1777465204/HEC_Attested_Degree_fvlfk5.jpg",
        physicalLocation: {
          name: "HEC Head Office, Islamabad",
          lat: 33.6601,
          lng: 73.044,
        },
      },
      {
        reqId: "req_unipd_mofa",
        type: "document",
        title: "MOFA Attestation",
        generalGuide: "Legalization of your HEC-attested educational documents.",
        localInstructions:
          "Required before applying for the Declaration of Value or visa.",
        isRequired: true,
        guideAvailable: true,
        sampleImageUrl:
          "https://res.cloudinary.com/dhxr1x9sx/image/upload/v1777465203/MOFA_Attestation_eqa3ht.jpg",
        physicalLocation: {
          name: "Ministry of Foreign Affairs (MOFA)",
          lat: 33.7297,
          lng: 73.0975,
        },
      },
      {
        reqId: "req_unipd_cimea",
        type: "document",
        title: "CIMEA or DOV",
        generalGuide: "Verification of your degree equivalency.",
        localInstructions:
          "Upload HEC-attested documents to the CIMEA portal to avoid Embassy wait times.",
        isRequired: true,
        guideAvailable: true,
        sampleImageUrl:
          "https://res.cloudinary.com/dhxr1x9sx/image/upload/v1777465203/CIMEA_Certificate_umxkau.webp",
        physicalLocation: null,
      },
      {
        reqId: "req_unipd_fee",
        type: "process",
        title: "Application Fee Payment",
        generalGuide: "A mandatory €30 application fee paid via the PagoPA system.",
        localInstructions:
          "PagoPA almost always rejects Pakistani debit cards. You MUST use a Sadapay/Nayapay virtual card, or a friend's international credit card.",
        isRequired: true,
        guideAvailable: true,
        sampleImageUrl: null,
        physicalLocation: null,
      },
      {
        reqId: "req_unipd_esu",
        type: "document",
        title: "ESU Padova Scholarship",
        generalGuide: "Regional scholarship for the Veneto region.",
        localInstructions:
          "Requires an ISEE Parificato. Start translating your father's FBR wealth statement and NADRA FRC early.",
        isRequired: true,
        guideAvailable: true,
        sampleImageUrl: null,
        physicalLocation: null,
      },
    ],
  },
  {
    uniId: "uni_006",
    name: "University of Milan (La Statale)",
    location: "Milan, Lombardy",
    applicationRequirements: [
      {
        reqId: "req_unimi_transcripts",
        type: "document",
        title: "HEC Attested Transcripts & Degree",
        generalGuide: "Official Bachelor's degree and all semester transcripts.",
        localInstructions:
          "Must be physically attested by the Higher Education Commission (HEC) in Pakistan.",
        isRequired: true,
        guideAvailable: true,
        sampleImageUrl:
          "https://res.cloudinary.com/dhxr1x9sx/image/upload/v1777465204/HEC_Attested_Degree_fvlfk5.jpg",
        physicalLocation: {
          name: "HEC Head Office, Islamabad",
          lat: 33.6601,
          lng: 73.044,
        },
      },
      {
        reqId: "req_unimi_mofa",
        type: "document",
        title: "MOFA Attestation",
        generalGuide: "Legalization of your HEC-attested educational documents.",
        localInstructions:
          "Required before you can apply for the Declaration of Value or visa. Use a courier service if you cannot visit Islamabad.",
        isRequired: true,
        guideAvailable: true,
        sampleImageUrl:
          "https://res.cloudinary.com/dhxr1x9sx/image/upload/v1777465203/MOFA_Attestation_eqa3ht.jpg",
        physicalLocation: {
          name: "Ministry of Foreign Affairs (MOFA)",
          lat: 33.7297,
          lng: 73.0975,
        },
      },
      {
        reqId: "req_unimi_lang",
        type: "exam",
        title: "English Proficiency",
        generalGuide: "B2 Level English certificate.",
        localInstructions:
          "Unimi heavily scrutinizes 'English Proficiency Certificates' issued by Pakistani universities. To be 100% safe from rejection, provide an official IELTS or TOEFL score.",
        isRequired: true,
        guideAvailable: true,
        sampleImageUrl:
          "https://res.cloudinary.com/dhxr1x9sx/image/upload/v1777465204/IELTS_Certificate_zgjhkx.webp",
        physicalLocation: {
          name: "British Council, Islamabad",
          lat: 33.7182,
          lng: 73.0694,
        },
      },
      {
        reqId: "req_unimi_legalization",
        type: "document",
        title: "Embassy Legalization (DOV)",
        generalGuide: "Declaration of Value issued by the Italian diplomatic mission.",
        localInstructions:
          "Unimi relies heavily on the DOV and sometimes rejects CIMEA. Booking an appointment via Prenot@mi is notoriously difficult. Log in exactly at 12:00 AM Rome time to snipe available slots.",
        isRequired: true,
        guideAvailable: true,
        sampleImageUrl:
          "https://res.cloudinary.com/dhxr1x9sx/image/upload/v1777465204/Embassy_Legalization_DOV_pmkn4t.webp",
        physicalLocation: {
          name: "Embassy of Italy, Islamabad",
          lat: 33.7294,
          lng: 73.1116,
        },
      },
      {
        reqId: "req_unimi_dsu",
        type: "document",
        title: "DSU Unimi Scholarship",
        generalGuide: "Regional scholarship for tuition and stipend.",
        localInstructions:
          "Requires translated NADRA FRC and FBR Wealth statement. DO NOT use random local notaries for translation; use embassy-approved translators.",
        isRequired: true,
        guideAvailable: true,
        sampleImageUrl: null,
        physicalLocation: null,
      },
    ],
  },
  {
    uniId: "uni_007",
    name: "University of Pisa (UniPi)",
    location: "Pisa, Tuscany",
    applicationRequirements: [
      {
        reqId: "req_unipi_transcripts",
        type: "document",
        title: "HEC Attested Transcripts & Degree",
        generalGuide: "Official Bachelor's degree and all semester transcripts.",
        localInstructions:
          "Must be physically attested by the Higher Education Commission (HEC) in Pakistan.",
        isRequired: true,
        guideAvailable: true,
        sampleImageUrl:
          "https://res.cloudinary.com/dhxr1x9sx/image/upload/v1777465204/HEC_Attested_Degree_fvlfk5.jpg",
        physicalLocation: {
          name: "HEC Head Office, Islamabad",
          lat: 33.6601,
          lng: 73.044,
        },
      },
      {
        reqId: "req_unipi_mofa",
        type: "document",
        title: "MOFA Attestation",
        generalGuide: "Legalization of your HEC-attested educational documents.",
        localInstructions: "Required before you can apply for the visa.",
        isRequired: true,
        guideAvailable: true,
        sampleImageUrl:
          "https://res.cloudinary.com/dhxr1x9sx/image/upload/v1777465203/MOFA_Attestation_eqa3ht.jpg",
        physicalLocation: {
          name: "Ministry of Foreign Affairs (MOFA)",
          lat: 33.7297,
          lng: 73.0975,
        },
      },
      {
        reqId: "req_unipi_cimea",
        type: "document",
        title: "CIMEA Verification",
        generalGuide: "Statement of Comparability.",
        localInstructions:
          "Upload HEC and MOFA attested documents to the CIMEA Diplome portal.",
        isRequired: true,
        guideAvailable: true,
        sampleImageUrl:
          "https://res.cloudinary.com/dhxr1x9sx/image/upload/v1777465203/CIMEA_Certificate_umxkau.webp",
        physicalLocation: null,
      },
      {
        reqId: "req_unipi_preenrol",
        type: "process",
        title: "Universitaly Pre-Enrollment",
        generalGuide: "Mandatory national pre-enrollment via the government portal.",
        localInstructions:
          "Once UniPi issues your admission letter, immediately apply on Universitaly.it. Do not make a mistake selecting your Consulate (Islamabad handles Punjab/KPK; Karachi handles Sindh/Balochistan).",
        isRequired: true,
        guideAvailable: true,
        sampleImageUrl:
          null,
        physicalLocation: null,
      },
      {
        reqId: "req_unipi_dsu",
        type: "document",
        title: "DSU Toscana Application",
        generalGuide: "Regional scholarship application for Tuscany.",
        localInstructions:
          "DSU Toscana deadlines are strict (early September). Start translating your NADRA/FBR documents in July. Submit via the DSU Toscana portal before your visa is even approved.",
        isRequired: true,
        guideAvailable: true,
        sampleImageUrl:
          "https://res.cloudinary.com/dhxr1x9sx/image/upload/v1777465203/DSU_Scholarship_kceloo.webp",
        physicalLocation: null,
      },
    ],
  },
  {
    uniId: "uni_008",
    name: "University of Florence (UniFi)",
    location: "Florence, Tuscany",
    applicationRequirements: [
      {
        reqId: "req_unifi_transcripts",
        type: "document",
        title: "HEC Attested Transcripts & Degree",
        generalGuide: "Official Bachelor's degree and all semester transcripts.",
        localInstructions:
          "Must be physically attested by the Higher Education Commission (HEC) in Pakistan.",
        isRequired: true,
        guideAvailable: true,
        sampleImageUrl:
          "https://res.cloudinary.com/dhxr1x9sx/image/upload/v1777465204/HEC_Attested_Degree_fvlfk5.jpg",
        physicalLocation: {
          name: "HEC Head Office, Islamabad",
          lat: 33.6601,
          lng: 73.044,
        },
      },
      {
        reqId: "req_unifi_mofa",
        type: "document",
        title: "MOFA Attestation",
        generalGuide: "Legalization of your HEC-attested educational documents.",
        localInstructions: "Required before you can apply for the visa.",
        isRequired: true,
        guideAvailable: true,
        sampleImageUrl:
          "https://res.cloudinary.com/dhxr1x9sx/image/upload/v1777465203/MOFA_Attestation_eqa3ht.jpg",
        physicalLocation: {
          name: "Ministry of Foreign Affairs (MOFA)",
          lat: 33.7297,
          lng: 73.0975,
        },
      },
      {
        reqId: "req_unifi_cimea",
        type: "document",
        title: "CIMEA Verification",
        generalGuide: "Statement of Comparability.",
        localInstructions:
          "Upload HEC-attested documents to the CIMEA portal online.",
        isRequired: true,
        guideAvailable: true,
        sampleImageUrl:
          "https://res.cloudinary.com/dhxr1x9sx/image/upload/v1777465203/CIMEA_Certificate_umxkau.webp",
        physicalLocation: null,
      },
      {
        reqId: "req_unifi_mot",
        type: "document",
        title: "Motivation Letter",
        generalGuide: "Personal statement outlining academic goals.",
        localInstructions:
          "Florence professors love cultural appreciation, but strictly in an academic context. Mention specific research papers published by UniFi faculty. Never use ChatGPT for the opening paragraph.",
        isRequired: true,
        guideAvailable: true,
        sampleImageUrl:
          null,
        physicalLocation: null,
      },
      {
        reqId: "req_unifi_cgpa",
        type: "document",
        title: "CGPA Equivalency",
        generalGuide: "Conversion of your GPA to the Italian 110-point scale.",
        localInstructions:
          "Do not attempt to mathematically convert your GPA yourself. Upload the official grading scale printed on the back of your HEC-recognized transcript and let the admission board calculate it.",
        isRequired: true,
        guideAvailable: true,
        sampleImageUrl:
          "https://res.cloudinary.com/dhxr1x9sx/image/upload/v1777465204/Official_Course_Syllabus_ipk3rj.png",
        physicalLocation: null,
      },
      {
        reqId: "req_unifi_dsu",
        type: "document",
        title: "DSU Toscana Application",
        generalGuide: "Regional scholarship application for Tuscany.",
        localInstructions:
          "Submit via the DSU Toscana portal with translated NADRA FRC and FBR Wealth statement.",
        isRequired: true,
        guideAvailable: true,
        sampleImageUrl:
          "https://res.cloudinary.com/dhxr1x9sx/image/upload/v1777465203/DSU_Scholarship_kceloo.webp",
        physicalLocation: null,
      },
    ],
  },
  {
    uniId: "uni_009",
    name: "University of Turin (UniTo)",
    location: "Turin, Piedmont",
    applicationRequirements: [
      {
        reqId: "req_unito_transcripts",
        type: "document",
        title: "HEC Attested Transcripts & Degree",
        generalGuide: "Official Bachelor's degree and all semester transcripts.",
        localInstructions:
          "Must be physically attested by the Higher Education Commission (HEC) in Pakistan.",
        isRequired: true,
        guideAvailable: true,
        sampleImageUrl:
          "https://res.cloudinary.com/dhxr1x9sx/image/upload/v1777465204/HEC_Attested_Degree_fvlfk5.jpg",
        physicalLocation: {
          name: "HEC Head Office, Islamabad",
          lat: 33.6601,
          lng: 73.044,
        },
      },
      {
        reqId: "req_unito_mofa",
        type: "document",
        title: "MOFA Attestation",
        generalGuide: "Legalization of your HEC-attested educational documents.",
        localInstructions: "Required before you can apply for the visa.",
        isRequired: true,
        guideAvailable: true,
        sampleImageUrl:
          "https://res.cloudinary.com/dhxr1x9sx/image/upload/v1777465203/MOFA_Attestation_eqa3ht.jpg",
        physicalLocation: {
          name: "Ministry of Foreign Affairs (MOFA)",
          lat: 33.7297,
          lng: 73.0975,
        },
      },
      {
        reqId: "req_unito_cimea",
        type: "document",
        title: "CIMEA or DOV",
        generalGuide: "Verification of your degree equivalency.",
        localInstructions:
          "UniTo accepts both. CIMEA is highly recommended to save time.",
        isRequired: true,
        guideAvailable: true,
        sampleImageUrl:
          "https://res.cloudinary.com/dhxr1x9sx/image/upload/v1777465203/CIMEA_Certificate_umxkau.webp",
        physicalLocation: null,
      },
      {
        reqId: "req_unito_interview",
        type: "process",
        title: "Skype/Zoom Interview",
        generalGuide:
          "Some master's programs require an academic interview with the faculty.",
        localInstructions:
          "Treat this like a thesis defense. Be prepared to share your screen and show diagrams from your Final Year Project (FYP). Wear formal attire.",
        isRequired: false,
        guideAvailable: true,
        sampleImageUrl:
          null,
        physicalLocation: null,
      },
      {
        reqId: "req_unito_edisu",
        type: "document",
        title: "EDISU Piemonte Scholarship",
        generalGuide: "Regional scholarship for Piedmont.",
        localInstructions:
          "Prepare your NADRA FRC and FBR Wealth statement. Apply on the EDISU portal.",
        isRequired: true,
        guideAvailable: true,
        sampleImageUrl:
          "https://res.cloudinary.com/dhxr1x9sx/image/upload/v1777465204/EDISU_Piemonte_Scholarship_vr4cv9.webp",
        physicalLocation: null,
      },
    ],
  },
  {
    uniId: "uni_010",
    name: "University of Naples Federico II",
    location: "Naples, Campania",
    applicationRequirements: [
      {
        reqId: "req_unina_transcripts",
        type: "document",
        title: "HEC Attested Transcripts & Degree",
        generalGuide: "Official Bachelor's degree and all semester transcripts.",
        localInstructions:
          "Must be physically attested by the Higher Education Commission (HEC) in Pakistan.",
        isRequired: true,
        guideAvailable: true,
        sampleImageUrl:
          "https://res.cloudinary.com/dhxr1x9sx/image/upload/v1777465204/HEC_Attested_Degree_fvlfk5.jpg",
        physicalLocation: {
          name: "HEC Head Office, Islamabad",
          lat: 33.6601,
          lng: 73.044,
        },
      },
      {
        reqId: "req_unina_translation",
        type: "document",
        title: "Translated Transcripts",
        generalGuide: "Transcripts must be available in English or Italian.",
        localInstructions:
          "If your degree is purely in Urdu (e.g., from an older local board), you MUST have it translated by a sworn translator BEFORE taking it to MOFA. MOFA will not attest un-translated Urdu documents for international use.",
        isRequired: true,
        guideAvailable: true,
        sampleImageUrl:
          "https://res.cloudinary.com/dhxr1x9sx/image/upload/v1777465205/Italian_Translation_b5vqjg.jpg",
        physicalLocation: null,
      },
      {
        reqId: "req_unina_mofa",
        type: "document",
        title: "MOFA Attestation",
        generalGuide: "Legalization of your HEC-attested educational documents.",
        localInstructions: "Required before you can apply for the visa.",
        isRequired: true,
        guideAvailable: true,
        sampleImageUrl:
          "https://res.cloudinary.com/dhxr1x9sx/image/upload/v1777465203/MOFA_Attestation_eqa3ht.jpg",
        physicalLocation: {
          name: "Ministry of Foreign Affairs (MOFA)",
          lat: 33.7297,
          lng: 73.0975,
        },
      },
      {
        reqId: "req_unina_cimea",
        type: "document",
        title: "CIMEA or DOV",
        generalGuide: "Verification of your degree equivalency.",
        localInstructions: "Apply via CIMEA to avoid Embassy delays.",
        isRequired: true,
        guideAvailable: true,
        sampleImageUrl:
          "https://res.cloudinary.com/dhxr1x9sx/image/upload/v1777465203/CIMEA_Certificate_umxkau.webp",
        physicalLocation: null,
      },
      {
        reqId: "req_unina_adim",
        type: "process",
        title: "ADISURC Scholarship",
        generalGuide: "Campania regional scholarship application.",
        localInstructions:
          "ADISURC is known for being slightly slower with disbursements, so ensure you have enough funds in your Pakistani bank account to survive the first 2-3 months in Italy.",
        isRequired: true,
        guideAvailable: true,
        sampleImageUrl:
          null,
        physicalLocation: null,
      },
    ],
  },
  {
    uniId: "uni_011",
    name: "Ca' Foscari University of Venice",
    location: "Venice, Veneto",
    applicationRequirements: [
      {
        reqId: "req_cafoscari_transcripts",
        type: "document",
        title: "HEC Attested Transcripts & Degree",
        generalGuide: "Official Bachelor's degree and all semester transcripts.",
        localInstructions:
          "Must be physically attested by the Higher Education Commission (HEC) in Pakistan.",
        isRequired: true,
        guideAvailable: true,
        sampleImageUrl:
          "https://res.cloudinary.com/dhxr1x9sx/image/upload/v1777465204/HEC_Attested_Degree_fvlfk5.jpg",
        physicalLocation: {
          name: "HEC Head Office, Islamabad",
          lat: 33.6601,
          lng: 73.044,
        },
      },
      {
        reqId: "req_cafoscari_mofa",
        type: "document",
        title: "MOFA Attestation",
        generalGuide: "Legalization of your HEC-attested educational documents.",
        localInstructions:
          "Required before you can apply for the Declaration of Value or visa.",
        isRequired: true,
        guideAvailable: true,
        sampleImageUrl:
          "https://res.cloudinary.com/dhxr1x9sx/image/upload/v1777465203/MOFA_Attestation_eqa3ht.jpg",
        physicalLocation: {
          name: "Ministry of Foreign Affairs (MOFA)",
          lat: 33.7297,
          lng: 73.0975,
        },
      },
      {
        reqId: "req_cafoscari_cimea",
        type: "document",
        title: "CIMEA or DOV",
        generalGuide: "Verification of your degree equivalency.",
        localInstructions:
          "Ca' Foscari accepts CIMEA. Upload your documents to the online portal to bypass the Embassy wait times.",
        isRequired: true,
        guideAvailable: true,
        sampleImageUrl:
          "https://res.cloudinary.com/dhxr1x9sx/image/upload/v1777465203/CIMEA_Certificate_umxkau.webp",
        physicalLocation: null,
      },
      {
        reqId: "req_cafoscari_fee",
        type: "process",
        title: "Application Fee",
        generalGuide: "A €30 evaluation fee per application submitted.",
        localInstructions:
          "The payment portal is strict; use a virtual Visa/Mastercard (like SadaPay or NayaPay). Do not use a standard local debit card as it will likely timeout.",
        isRequired: true,
        guideAvailable: true,
        sampleImageUrl:
          null,
        physicalLocation: null,
      },
      {
        reqId: "req_cafoscari_esu",
        type: "document",
        title: "ESU Venezia Scholarship",
        generalGuide: "The regional scholarship body for the Veneto region.",
        localInstructions:
          "Requires the ISEE Parificato. Start translating your father's FBR wealth statement and NADRA FRC early. Email an Italian CAF to generate the ISEE.",
        isRequired: true,
        guideAvailable: true,
        sampleImageUrl:
          null,
        physicalLocation: null,
      },
    ],
  },
  {
    uniId: "uni_012",
    name: "University of Trento (UniTrento)",
    location: "Trento, Trentino-Alto Adige",
    applicationRequirements: [
      {
        reqId: "req_unitrento_transcripts",
        type: "document",
        title: "HEC Attested Transcripts & Degree",
        generalGuide: "Official Bachelor's degree and all semester transcripts.",
        localInstructions:
          "Must be physically attested by the Higher Education Commission (HEC) in Pakistan.",
        isRequired: true,
        guideAvailable: true,
        sampleImageUrl:
          "https://res.cloudinary.com/dhxr1x9sx/image/upload/v1777465204/HEC_Attested_Degree_fvlfk5.jpg",
        physicalLocation: {
          name: "HEC Head Office, Islamabad",
          lat: 33.6601,
          lng: 73.044,
        },
      },
      {
        reqId: "req_unitrento_mofa",
        type: "document",
        title: "MOFA Attestation",
        generalGuide: "Legalization of your HEC-attested educational documents.",
        localInstructions:
          "Required before you can apply for the Declaration of Value or visa.",
        isRequired: true,
        guideAvailable: true,
        sampleImageUrl:
          "https://res.cloudinary.com/dhxr1x9sx/image/upload/v1777465203/MOFA_Attestation_eqa3ht.jpg",
        physicalLocation: {
          name: "Ministry of Foreign Affairs (MOFA)",
          lat: 33.7297,
          lng: 73.0975,
        },
      },
      {
        reqId: "req_unitrento_cimea",
        type: "document",
        title: "CIMEA Verification",
        generalGuide: "Statement of Comparability.",
        localInstructions:
          "Upload HEC and MOFA attested documents to the CIMEA Diplome portal.",
        isRequired: true,
        guideAvailable: true,
        sampleImageUrl:
          "https://res.cloudinary.com/dhxr1x9sx/image/upload/v1777465203/CIMEA_Certificate_umxkau.webp",
        physicalLocation: null,
      },
      {
        reqId: "req_unitrento_video",
        type: "process",
        title: "Video Interview / Pitch",
        generalGuide:
          "Some highly competitive technical programs require a pre-recorded video pitch.",
        localInstructions:
          "Keep it under 2 minutes. Dress professionally, ensure good lighting, and do not read directly from a script. They are testing English fluency.",
        isRequired: false,
        guideAvailable: true,
        sampleImageUrl:
          null,
        physicalLocation: null,
      },
      {
        reqId: "req_unitrento_opera",
        type: "document",
        title: "Opera Universitaria Scholarship",
        generalGuide: "Trento's specific provincial scholarship and housing provider.",
        localInstructions:
          "Trento has a massive housing shortage. Winning this scholarship guarantees a dorm bed. Submit your translated NADRA/FBR docs exactly on the opening day.",
        isRequired: true,
        guideAvailable: true,
        sampleImageUrl:
          null,
        physicalLocation: null,
      },
    ],
  },
  {
    uniId: "uni_013",
    name: "University of Pavia (UniPv)",
    location: "Pavia, Lombardy",
    applicationRequirements: [
      {
        reqId: "req_unipv_transcripts",
        type: "document",
        title: "HEC Attested Transcripts & Degree",
        generalGuide: "Official Bachelor's degree and all semester transcripts.",
        localInstructions:
          "Must be physically attested by the Higher Education Commission (HEC) in Pakistan.",
        isRequired: true,
        guideAvailable: true,
        sampleImageUrl:
          "https://res.cloudinary.com/dhxr1x9sx/image/upload/v1777465204/HEC_Attested_Degree_fvlfk5.jpg",
        physicalLocation: {
          name: "HEC Head Office, Islamabad",
          lat: 33.6601,
          lng: 73.044,
        },
      },
      {
        reqId: "req_unipv_mofa",
        type: "document",
        title: "MOFA Attestation",
        generalGuide: "Legalization of your HEC-attested educational documents.",
        localInstructions:
          "Required before you can apply for the Declaration of Value or visa.",
        isRequired: true,
        guideAvailable: true,
        sampleImageUrl:
          "https://res.cloudinary.com/dhxr1x9sx/image/upload/v1777465203/MOFA_Attestation_eqa3ht.jpg",
        physicalLocation: {
          name: "Ministry of Foreign Affairs (MOFA)",
          lat: 33.7297,
          lng: 73.0975,
        },
      },
      {
        reqId: "req_unipv_cimea",
        type: "document",
        title: "CIMEA Verification",
        generalGuide: "Proof of 16 years of education equivalency.",
        localInstructions:
          "UniPv is very accommodating and highly prefers CIMEA because it's digital. Order your CIMEA Diplome as soon as you get your admission letter.",
        isRequired: true,
        guideAvailable: true,
        sampleImageUrl:
          "https://res.cloudinary.com/dhxr1x9sx/image/upload/v1777465203/CIMEA_Certificate_umxkau.webp",
        physicalLocation: null,
      },
      {
        reqId: "req_unipv_edisu",
        type: "document",
        title: "EDiSU Pavia Application",
        generalGuide: "Lombardy regional scholarship for Pavia.",
        localInstructions:
          "Must have your NADRA FRC and FBR documents legalized by MOFA. EDiSU Pavia requires you to physically present the original translated documents once you arrive in Italy.",
        isRequired: true,
        guideAvailable: true,
        sampleImageUrl:
          null,
        physicalLocation: null,
      },
    ],
  },
  {
    uniId: "uni_014",
    name: "University of Siena (UniSi)",
    location: "Siena, Tuscany",
    applicationRequirements: [
      {
        reqId: "req_unisi_transcripts",
        type: "document",
        title: "HEC Attested Transcripts & Degree",
        generalGuide: "Official Bachelor's degree and all semester transcripts.",
        localInstructions:
          "Must be physically attested by the Higher Education Commission (HEC) in Pakistan.",
        isRequired: true,
        guideAvailable: true,
        sampleImageUrl:
          "https://res.cloudinary.com/dhxr1x9sx/image/upload/v1777465204/HEC_Attested_Degree_fvlfk5.jpg",
        physicalLocation: {
          name: "HEC Head Office, Islamabad",
          lat: 33.6601,
          lng: 73.044,
        },
      },
      {
        reqId: "req_unisi_mofa",
        type: "document",
        title: "MOFA Attestation",
        generalGuide: "Legalization of your HEC-attested educational documents.",
        localInstructions:
          "Required before you can apply for the Declaration of Value or visa.",
        isRequired: true,
        guideAvailable: true,
        sampleImageUrl:
          "https://res.cloudinary.com/dhxr1x9sx/image/upload/v1777465203/MOFA_Attestation_eqa3ht.jpg",
        physicalLocation: {
          name: "Ministry of Foreign Affairs (MOFA)",
          lat: 33.7297,
          lng: 73.0975,
        },
      },
      {
        reqId: "req_unisi_cimea",
        type: "document",
        title: "CIMEA or DOV",
        generalGuide: "Verification of your degree equivalency.",
        localInstructions:
          "Apply via CIMEA to avoid Italian Embassy appointment delays.",
        isRequired: true,
        guideAvailable: true,
        sampleImageUrl:
          "https://res.cloudinary.com/dhxr1x9sx/image/upload/v1777465203/CIMEA_Certificate_umxkau.webp",
        physicalLocation: null,
      },
      {
        reqId: "req_unisi_lang",
        type: "exam",
        title: "English Proficiency",
        generalGuide: "Minimum B2 level required for English-taught degrees.",
        localInstructions:
          "Having an official IELTS (6.0+) makes your visa process at Gerry's much smoother.",
        isRequired: true,
        guideAvailable: true,
        sampleImageUrl:
          "https://res.cloudinary.com/dhxr1x9sx/image/upload/v1777465204/IELTS_Certificate_zgjhkx.webp",
        physicalLocation: {
          name: "AEO Pakistan, Lahore",
          lat: 31.516,
          lng: 74.3486,
        },
      },
      {
        reqId: "req_unisi_dsu",
        type: "document",
        title: "DSU Toscana Application",
        generalGuide: "Regional scholarship for Tuscany.",
        localInstructions:
          "Make sure your father's property valuation is officially done by an approved evaluator in Pakistan. Fake property values trigger audits by DSU.",
        isRequired: true,
        guideAvailable: true,
        sampleImageUrl:
          null,
        physicalLocation: null,
      },
    ],
  },
  {
    uniId: "uni_015",
    name: "University of Calabria (UniCal)",
    location: "Rende, Calabria",
    applicationRequirements: [
      {
        reqId: "req_unical_transcripts",
        type: "document",
        title: "HEC Attested Transcripts & Degree",
        generalGuide: "Official Bachelor's degree and all semester transcripts.",
        localInstructions:
          "Since the UniCal scholarship is heavily merit-based, your transcripts must be spotless. Ensure the grading scale (out of 4.0) is clearly visible.",
        isRequired: true,
        guideAvailable: true,
        sampleImageUrl:
          "https://res.cloudinary.com/dhxr1x9sx/image/upload/v1777465204/HEC_Attested_Degree_fvlfk5.jpg",
        physicalLocation: {
          name: "HEC Head Office, Islamabad",
          lat: 33.6601,
          lng: 73.044,
        },
      },
      {
        reqId: "req_unical_mofa",
        type: "document",
        title: "MOFA Attestation",
        generalGuide: "Legalization of your HEC-attested educational documents.",
        localInstructions:
          "Required before you can apply for the Declaration of Value or visa.",
        isRequired: true,
        guideAvailable: true,
        sampleImageUrl:
          "https://res.cloudinary.com/dhxr1x9sx/image/upload/v1777465203/MOFA_Attestation_eqa3ht.jpg",
        physicalLocation: {
          name: "Ministry of Foreign Affairs (MOFA)",
          lat: 33.7297,
          lng: 73.0975,
        },
      },
      {
        reqId: "req_unical_cimea",
        type: "document",
        title: "CIMEA or DOV",
        generalGuide: "Verification of your degree equivalency.",
        localInstructions:
          "Apply via CIMEA to avoid Italian Embassy appointment delays.",
        isRequired: true,
        guideAvailable: true,
        sampleImageUrl:
          "https://res.cloudinary.com/dhxr1x9sx/image/upload/v1777465203/CIMEA_Certificate_umxkau.webp",
        physicalLocation: null,
      },
      {
        reqId: "req_unical_unicaladmission",
        type: "process",
        title: "UniCal Direct Scholarship",
        generalGuide:
          "Special internal scholarship (tuition + dorm + meals) during admission.",
        localInstructions:
          "This is the holy grail for Pakistani students. You do NOT need separate regional DSU docs. It is awarded purely on CGPA and IELTS. Apply on day one.",
        isRequired: true,
        guideAvailable: true,
        sampleImageUrl:
          null,
        physicalLocation: null,
      },
    ],
  },
  {
    uniId: "uni_016",
    name: "Politecnico di Bari (PoliBa)",
    location: "Bari, Apulia",
    applicationRequirements: [
      {
        reqId: "req_poliba_transcripts",
        type: "document",
        title: "HEC Attested Transcripts & Degree",
        generalGuide: "Official Bachelor's degree and all semester transcripts.",
        localInstructions:
          "Must be physically attested by the Higher Education Commission (HEC) in Pakistan.",
        isRequired: true,
        guideAvailable: true,
        sampleImageUrl:
          "https://res.cloudinary.com/dhxr1x9sx/image/upload/v1777465204/HEC_Attested_Degree_fvlfk5.jpg",
        physicalLocation: {
          name: "HEC Head Office, Islamabad",
          lat: 33.6601,
          lng: 73.044,
        },
      },
      {
        reqId: "req_poliba_mofa",
        type: "document",
        title: "MOFA Attestation",
        generalGuide: "Legalization of your HEC-attested educational documents.",
        localInstructions:
          "Required before you can apply for the Declaration of Value or visa.",
        isRequired: true,
        guideAvailable: true,
        sampleImageUrl:
          "https://res.cloudinary.com/dhxr1x9sx/image/upload/v1777465203/MOFA_Attestation_eqa3ht.jpg",
        physicalLocation: {
          name: "Ministry of Foreign Affairs (MOFA)",
          lat: 33.7297,
          lng: 73.0975,
        },
      },
      {
        reqId: "req_poliba_cimea",
        type: "document",
        title: "CIMEA or DOV",
        generalGuide: "Verification of your degree equivalency.",
        localInstructions:
          "Upload HEC and MOFA attested documents to the CIMEA Diplome portal.",
        isRequired: true,
        guideAvailable: true,
        sampleImageUrl:
          "https://res.cloudinary.com/dhxr1x9sx/image/upload/v1777465203/CIMEA_Certificate_umxkau.webp",
        physicalLocation: null,
      },
      {
        reqId: "req_poliba_entrance",
        type: "exam",
        title: "Engineering Entrance Exam",
        generalGuide: "Mandatory entrance exam for bachelor's degrees.",
        localInstructions:
          "The entrance exam is math and physics heavy. Use online TOLC-I mock tests to prepare, as the syllabus is identical.",
        isRequired: false,
        guideAvailable: true,
        sampleImageUrl:
          null,
        physicalLocation: null,
      },
      {
        reqId: "req_poliba_adisu",
        type: "document",
        title: "ADISU Puglia Scholarship",
        generalGuide: "Regional scholarship for the Apulia region.",
        localInstructions:
          "ADISU Puglia is known to be very generous. However, you must generate an ISEE Parificato through an Italian CAF. You cannot just upload raw Pakistani tax returns.",
        isRequired: true,
        guideAvailable: true,
        sampleImageUrl:
          null,
        physicalLocation: null,
      },
    ],
  },
  {
    uniId: "uni_017",
    name: "University of Messina (UniMe)",
    location: "Messina, Sicily",
    applicationRequirements: [
      {
        reqId: "req_unime_transcripts",
        type: "document",
        title: "HEC Attested Transcripts & Degree",
        generalGuide: "Official Bachelor's degree and all semester transcripts.",
        localInstructions:
          "Must be physically attested by the Higher Education Commission (HEC) in Pakistan.",
        isRequired: true,
        guideAvailable: true,
        sampleImageUrl:
          "https://res.cloudinary.com/dhxr1x9sx/image/upload/v1777465204/HEC_Attested_Degree_fvlfk5.jpg",
        physicalLocation: {
          name: "HEC Head Office, Islamabad",
          lat: 33.6601,
          lng: 73.044,
        },
      },
      {
        reqId: "req_unime_mofa",
        type: "document",
        title: "MOFA Attestation",
        generalGuide: "Legalization of your HEC-attested educational documents.",
        localInstructions:
          "Required before you can apply for the Declaration of Value or visa.",
        isRequired: true,
        guideAvailable: true,
        sampleImageUrl:
          "https://res.cloudinary.com/dhxr1x9sx/image/upload/v1777465203/MOFA_Attestation_eqa3ht.jpg",
        physicalLocation: {
          name: "Ministry of Foreign Affairs (MOFA)",
          lat: 33.7297,
          lng: 73.0975,
        },
      },
      {
        reqId: "req_unime_cimea",
        type: "document",
        title: "CIMEA or DOV",
        generalGuide: "Verification of your degree equivalency.",
        localInstructions: "CIMEA is recommended for faster processing.",
        isRequired: true,
        guideAvailable: true,
        sampleImageUrl:
          "https://res.cloudinary.com/dhxr1x9sx/image/upload/v1777465203/CIMEA_Certificate_umxkau.webp",
        physicalLocation: null,
      },
      {
        reqId: "req_unime_ersu",
        type: "document",
        title: "ERSU Messina Scholarship",
        generalGuide: "Regional scholarship body for Sicily.",
        localInstructions:
          "ERSU requires translated NADRA and FBR docs. Getting an appointment at the Italian Embassy for legalization can be tough. Use a designated drop-box service or an approved travel agent for legalization if you cannot secure a slot.",
        isRequired: true,
        guideAvailable: true,
        sampleImageUrl:
          null,
        physicalLocation: {
          name: "Embassy of Italy, Islamabad",
          lat: 33.7294,
          lng: 73.1116,
        },
      },
      {
        reqId: "req_unime_passport",
        type: "document",
        title: "Valid Passport",
        generalGuide: "Scan of the bio-data page.",
        localInstructions:
          "Ensure it is signed. The Italian consulate in Karachi is very strict about passports not having the owner's signature on page 2.",
        isRequired: true,
        guideAvailable: false,
        sampleImageUrl:
          "https://res.cloudinary.com/dhxr1x9sx/image/upload/v1777465204/Valid_Passport_etl96w.webp",
        physicalLocation: null,
      },
    ],
  },
  {
    uniId: "uni_018",
    name: "University of Cassino and Southern Lazio (UniCas)",
    location: "Cassino, Lazio",
    applicationRequirements: [
      {
        reqId: "req_unicas_transcripts",
        type: "document",
        title: "HEC Attested Transcripts & Degree",
        generalGuide: "Official Bachelor's degree and all semester transcripts.",
        localInstructions:
          "Must be physically attested by the Higher Education Commission (HEC) in Pakistan.",
        isRequired: true,
        guideAvailable: true,
        sampleImageUrl:
          "https://res.cloudinary.com/dhxr1x9sx/image/upload/v1777465204/HEC_Attested_Degree_fvlfk5.jpg",
        physicalLocation: {
          name: "HEC Head Office, Islamabad",
          lat: 33.6601,
          lng: 73.044,
        },
      },
      {
        reqId: "req_unicas_mofa",
        type: "document",
        title: "MOFA Attestation",
        generalGuide: "Legalization of your HEC-attested educational documents.",
        localInstructions:
          "Required before you can apply for the Declaration of Value or visa.",
        isRequired: true,
        guideAvailable: true,
        sampleImageUrl:
          "https://res.cloudinary.com/dhxr1x9sx/image/upload/v1777465203/MOFA_Attestation_eqa3ht.jpg",
        physicalLocation: {
          name: "Ministry of Foreign Affairs (MOFA)",
          lat: 33.7297,
          lng: 73.0975,
        },
      },
      {
        reqId: "req_unicas_cimea",
        type: "document",
        title: "CIMEA Verification",
        generalGuide: "Academic verification required for enrollment.",
        localInstructions:
          "UniCas prefers CIMEA over DOV. Create your CIMEA account and upload your HEC-attested degrees immediately after accepting your offer.",
        isRequired: true,
        guideAvailable: true,
        sampleImageUrl:
          "https://res.cloudinary.com/dhxr1x9sx/image/upload/v1777465203/CIMEA_Certificate_umxkau.webp",
        physicalLocation: null,
      },
      {
        reqId: "req_unicas_laziodisco",
        type: "document",
        title: "LazioDisco Scholarship",
        generalGuide: "The most popular scholarship region for South Asian students.",
        localInstructions:
          "LazioDisco gives out thousands of scholarships, but they verify Pakistani financial documents intensely. Ensure the FBR wealth statement perfectly matches the bank statements you provide for your visa.",
        isRequired: true,
        guideAvailable: true,
        sampleImageUrl:
          "https://res.cloudinary.com/dhxr1x9sx/image/upload/v1777465209/LazioDisco_Scholarship_d3mdqc.png",
        physicalLocation: null,
      },
    ],
  },
  {
    uniId: "uni_019",
    name: "University of Camerino (UniCam)",
    location: "Camerino, Marche",
    applicationRequirements: [
      {
        reqId: "req_unicam_transcripts",
        type: "document",
        title: "HEC Attested Transcripts & Degree",
        generalGuide: "Official Bachelor's degree and all semester transcripts.",
        localInstructions:
          "Must be physically attested by the Higher Education Commission (HEC) in Pakistan.",
        isRequired: true,
        guideAvailable: true,
        sampleImageUrl:
          "https://res.cloudinary.com/dhxr1x9sx/image/upload/v1777465204/HEC_Attested_Degree_fvlfk5.jpg",
        physicalLocation: {
          name: "HEC Head Office, Islamabad",
          lat: 33.6601,
          lng: 73.044,
        },
      },
      {
        reqId: "req_unicam_mofa",
        type: "document",
        title: "MOFA Attestation",
        generalGuide: "Legalization of your HEC-attested educational documents.",
        localInstructions:
          "Required before you can apply for the Declaration of Value or visa.",
        isRequired: true,
        guideAvailable: true,
        sampleImageUrl:
          "https://res.cloudinary.com/dhxr1x9sx/image/upload/v1777465203/MOFA_Attestation_eqa3ht.jpg",
        physicalLocation: {
          name: "Ministry of Foreign Affairs (MOFA)",
          lat: 33.7297,
          lng: 73.0975,
        },
      },
      {
        reqId: "req_unicam_cimea",
        type: "document",
        title: "CIMEA or DOV",
        generalGuide: "Verification of your degree equivalency.",
        localInstructions: "CIMEA is recommended.",
        isRequired: true,
        guideAvailable: true,
        sampleImageUrl:
          "https://res.cloudinary.com/dhxr1x9sx/image/upload/v1777465203/CIMEA_Certificate_umxkau.webp",
        physicalLocation: null,
      },
      {
        reqId: "req_unicam_preeval",
        type: "process",
        title: "Pre-Evaluation Portal",
        generalGuide:
          "Initial screening of academic documents before official Universitaly application.",
        localInstructions:
          "UniCam is a smaller, very welcoming university. They process pre-evaluations quickly. Make sure your CV clearly lists the programming languages or lab skills you acquired during your bachelor's in Pakistan.",
        isRequired: true,
        guideAvailable: true,
        sampleImageUrl:
          null,
        physicalLocation: null,
      },
      {
        reqId: "req_unicam_erdis",
        type: "document",
        title: "ERDIS Marche Scholarship",
        generalGuide: "Regional scholarship for the Marche region.",
        localInstructions:
          "Requires standard DSU documents (FRC, FBR, Property). You must have them translated into Italian and legalized by the MOFA in Islamabad before sending them to Italy.",
        isRequired: true,
        guideAvailable: true,
        sampleImageUrl:
          null,
        physicalLocation: null,
      },
    ],
  },
  {
    uniId: "uni_020",
    name: "University of Genoa (UniGe)",
    location: "Genoa, Liguria",
    applicationRequirements: [
      {
        reqId: "req_unige_transcripts",
        type: "document",
        title: "HEC Attested Transcripts & Degree",
        generalGuide: "Official Bachelor's degree and all semester transcripts.",
        localInstructions:
          "Must be physically attested by the Higher Education Commission (HEC) in Pakistan.",
        isRequired: true,
        guideAvailable: true,
        sampleImageUrl:
          "https://res.cloudinary.com/dhxr1x9sx/image/upload/v1777465204/HEC_Attested_Degree_fvlfk5.jpg",
        physicalLocation: {
          name: "HEC Head Office, Islamabad",
          lat: 33.6601,
          lng: 73.044,
        },
      },
      {
        reqId: "req_unige_mofa",
        type: "document",
        title: "MOFA Attestation",
        generalGuide: "Legalization of your HEC-attested educational documents.",
        localInstructions:
          "Required before you can apply for the Declaration of Value or visa.",
        isRequired: true,
        guideAvailable: true,
        sampleImageUrl:
          "https://res.cloudinary.com/dhxr1x9sx/image/upload/v1777465203/MOFA_Attestation_eqa3ht.jpg",
        physicalLocation: {
          name: "Ministry of Foreign Affairs (MOFA)",
          lat: 33.7297,
          lng: 73.0975,
        },
      },
      {
        reqId: "req_unige_cimea",
        type: "document",
        title: "CIMEA or DOV",
        generalGuide: "Verification of your degree equivalency.",
        localInstructions: "CIMEA is recommended.",
        isRequired: true,
        guideAvailable: true,
        sampleImageUrl:
          "https://res.cloudinary.com/dhxr1x9sx/image/upload/v1777465203/CIMEA_Certificate_umxkau.webp",
        physicalLocation: null,
      },
      {
        reqId: "req_unige_aliseo",
        type: "document",
        title: "ALISEO Scholarship",
        generalGuide: "Regional scholarship for the Liguria region.",
        localInstructions:
          "ALISEO requires the ISEE Parificato. Use an Italian CAF via email. Send them your legalized NADRA FRC and FBR Wealth statement. DO NOT wait until August to start this process.",
        isRequired: true,
        guideAvailable: true,
        sampleImageUrl:
          null,
        physicalLocation: null,
      },
      {
        reqId: "req_unige_lang",
        type: "exam",
        title: "English B2 Certificate",
        generalGuide: "Proof of English proficiency.",
        localInstructions:
          "Genoa accepts IELTS 5.5 in some cases, but 6.0 is safer for the Gerry's Visa interview. Book your test at AEO or British Council.",
        isRequired: true,
        guideAvailable: true,
        sampleImageUrl:
          "https://res.cloudinary.com/dhxr1x9sx/image/upload/v1777465204/IELTS_Certificate_zgjhkx.webp",
        physicalLocation: {
          name: "AEO Pakistan, Lahore",
          lat: 31.516,
          lng: 74.3486,
        },
      },
    ],
  },
  {
    uniId: "uni_021",
    name: "University of Milano-Bicocca (UniMiB)",
    location: "Milan, Lombardy",
    applicationRequirements: [
      {
        reqId: "req_unimib_transcripts",
        type: "document",
        title: "HEC Attested Transcripts & Degree",
        generalGuide: "Official Bachelor's degree and all semester transcripts.",
        localInstructions:
          "Must be physically attested by the Higher Education Commission (HEC) in Pakistan.",
        isRequired: true,
        guideAvailable: true,
        sampleImageUrl:
          "https://res.cloudinary.com/dhxr1x9sx/image/upload/v1777465204/HEC_Attested_Degree_fvlfk5.jpg",
        physicalLocation: {
          name: "HEC Head Office, Islamabad",
          lat: 33.6601,
          lng: 73.044,
        },
      },
      {
        reqId: "req_unimib_mofa",
        type: "document",
        title: "MOFA Attestation",
        generalGuide: "Legalization of your HEC-attested educational documents.",
        localInstructions:
          "Required before you can apply for the Declaration of Value or visa.",
        isRequired: true,
        guideAvailable: true,
        sampleImageUrl:
          "https://res.cloudinary.com/dhxr1x9sx/image/upload/v1777465203/MOFA_Attestation_eqa3ht.jpg",
        physicalLocation: {
          name: "Ministry of Foreign Affairs (MOFA)",
          lat: 33.7297,
          lng: 73.0975,
        },
      },
      {
        reqId: "req_unimib_cimea",
        type: "document",
        title: "CIMEA Verification",
        generalGuide: "Statement of Comparability.",
        localInstructions:
          "Upload HEC and MOFA attested documents to the CIMEA Diplome portal.",
        isRequired: true,
        guideAvailable: true,
        sampleImageUrl:
          "https://res.cloudinary.com/dhxr1x9sx/image/upload/v1777465203/CIMEA_Certificate_umxkau.webp",
        physicalLocation: null,
      },
      {
        reqId: "req_unimib_preeval",
        type: "process",
        title: "Extra-EU Pre-Evaluation",
        generalGuide:
          "Mandatory online document screening before the official application.",
        localInstructions:
          "Bicocca's pre-evaluation portal closes very early (often in February/March). Do not wait for your final 8th-semester transcript. Apply with a 7th-semester transcript and a 'Hope Certificate'.",
        isRequired: true,
        guideAvailable: true,
        sampleImageUrl:
          null,
        physicalLocation: null,
      },
      {
        reqId: "req_unimib_lang",
        type: "exam",
        title: "IELTS Academic",
        generalGuide: "B2 Level English Proficiency.",
        localInstructions:
          "Milan-based universities are highly competitive. An IELTS score of 6.5+ significantly boosts your ranking for their internal merit scholarships.",
        isRequired: true,
        guideAvailable: true,
        sampleImageUrl:
          "https://res.cloudinary.com/dhxr1x9sx/image/upload/v1777465204/IELTS_Certificate_zgjhkx.webp",
        physicalLocation: {
          name: "British Council, Lahore",
          lat: 31.5516,
          lng: 74.316,
        },
      },
      {
        reqId: "req_unimib_dsu",
        type: "document",
        title: "DSU Bicocca Scholarship",
        generalGuide:
          "Need-based scholarship providing tuition waivers, free meals, and cash stipends.",
        localInstructions:
          "Requires legalized FRC and FBR documents translated into Italian. Ensure your family's bank statements do not show sudden, massive cash deposits right before printing.",
        isRequired: true,
        guideAvailable: true,
        sampleImageUrl:
          "https://res.cloudinary.com/dhxr1x9sx/image/upload/v1777465203/DSU_Scholarship_kceloo.webp",
        physicalLocation: null,
      },
    ],
  },
  {
    uniId: "uni_022",
    name: "University of Parma (UniPr)",
    location: "Parma, Emilia-Romagna",
    applicationRequirements: [
      {
        reqId: "req_unipr_transcripts",
        type: "document",
        title: "HEC Attested Transcripts & Degree",
        generalGuide: "Official Bachelor's degree and all semester transcripts.",
        localInstructions:
          "Must be physically attested by the Higher Education Commission (HEC) in Pakistan.",
        isRequired: true,
        guideAvailable: true,
        sampleImageUrl:
          "https://res.cloudinary.com/dhxr1x9sx/image/upload/v1777465204/HEC_Attested_Degree_fvlfk5.jpg",
        physicalLocation: {
          name: "HEC Head Office, Islamabad",
          lat: 33.6601,
          lng: 73.044,
        },
      },
      {
        reqId: "req_unipr_mofa",
        type: "document",
        title: "MOFA Attestation",
        generalGuide: "Legalization of your HEC-attested educational documents.",
        localInstructions:
          "Required before you can apply for the Declaration of Value or visa.",
        isRequired: true,
        guideAvailable: true,
        sampleImageUrl:
          "https://res.cloudinary.com/dhxr1x9sx/image/upload/v1777465203/MOFA_Attestation_eqa3ht.jpg",
        physicalLocation: {
          name: "Ministry of Foreign Affairs (MOFA)",
          lat: 33.7297,
          lng: 73.0975,
        },
      },
      {
        reqId: "req_unipr_cimea",
        type: "document",
        title: "CIMEA or DOV",
        generalGuide: "Verification of your degree equivalency.",
        localInstructions:
          "Apply via CIMEA to avoid Italian Embassy appointment delays.",
        isRequired: true,
        guideAvailable: true,
        sampleImageUrl:
          "https://res.cloudinary.com/dhxr1x9sx/image/upload/v1777465203/CIMEA_Certificate_umxkau.webp",
        physicalLocation: null,
      },
      {
        reqId: "req_unipr_ergo",
        type: "document",
        title: "ER.GO Scholarship Application",
        generalGuide: "The regional scholarship body for the Emilia-Romagna region.",
        localInstructions:
          "ER.GO is incredibly generous but bureaucratic. You must use an Italian CAF to generate your ISEE Parificato. Start emailing CAFs in Italy with your translated NADRA documents by early July.",
        isRequired: true,
        guideAvailable: true,
        sampleImageUrl:
          null,
        physicalLocation: null,
      },
      {
        reqId: "req_unipr_syllabus",
        type: "document",
        title: "Stamped Course Syllabus",
        generalGuide: "A comprehensive breakdown of your bachelor's degree coursework.",
        localInstructions:
          "Parma's admission board maps your Pakistani credits to Italian credits manually. Ensure your syllabus clearly states the number of lecture hours and lab hours for every subject.",
        isRequired: true,
        guideAvailable: true,
        sampleImageUrl:
          "https://res.cloudinary.com/dhxr1x9sx/image/upload/v1777465204/Official_Course_Syllabus_ipk3rj.png",
        physicalLocation: null,
      },
    ],
  },
  {
    uniId: "uni_023",
    name: "University of Verona (UniVr)",
    location: "Verona, Veneto",
    applicationRequirements: [
      {
        reqId: "req_univr_transcripts",
        type: "document",
        title: "HEC Attested Transcripts & Degree",
        generalGuide: "Official Bachelor's degree and all semester transcripts.",
        localInstructions:
          "Must be physically attested by the Higher Education Commission (HEC) in Pakistan.",
        isRequired: true,
        guideAvailable: true,
        sampleImageUrl:
          "https://res.cloudinary.com/dhxr1x9sx/image/upload/v1777465204/HEC_Attested_Degree_fvlfk5.jpg",
        physicalLocation: {
          name: "HEC Head Office, Islamabad",
          lat: 33.6601,
          lng: 73.044,
        },
      },
      {
        reqId: "req_univr_mofa",
        type: "document",
        title: "MOFA Attestation",
        generalGuide: "Legalization of your HEC-attested educational documents.",
        localInstructions:
          "Required before you can apply for the Declaration of Value or visa.",
        isRequired: true,
        guideAvailable: true,
        sampleImageUrl:
          "https://res.cloudinary.com/dhxr1x9sx/image/upload/v1777465203/MOFA_Attestation_eqa3ht.jpg",
        physicalLocation: {
          name: "Ministry of Foreign Affairs (MOFA)",
          lat: 33.7297,
          lng: 73.0975,
        },
      },
      {
        reqId: "req_univr_cimea",
        type: "document",
        title: "CIMEA or DOV",
        generalGuide: "Verification of your degree equivalency.",
        localInstructions: "CIMEA is recommended for faster processing.",
        isRequired: true,
        guideAvailable: true,
        sampleImageUrl:
          "https://res.cloudinary.com/dhxr1x9sx/image/upload/v1777465203/CIMEA_Certificate_umxkau.webp",
        physicalLocation: null,
      },
      {
        reqId: "req_univr_interview",
        type: "process",
        title: "Admission Interview",
        generalGuide: "An academic and motivational interview via Zoom.",
        localInstructions:
          "Verona professors focus heavily on why you chose their specific city and university. Research their faculty members on LinkedIn and mention a specific professor's research paper.",
        isRequired: false,
        guideAvailable: true,
        sampleImageUrl:
          null,
        physicalLocation: null,
      },
      {
        reqId: "req_univr_esu",
        type: "document",
        title: "ESU Verona Scholarship",
        generalGuide: "Regional scholarship and housing for the Veneto region.",
        localInstructions:
          "Verona is a very expensive tourist city; winning ESU housing is critical. Apply the exact day the portal opens, as housing is allocated on a first-come, first-served basis.",
        isRequired: true,
        guideAvailable: true,
        sampleImageUrl:
          null,
        physicalLocation: null,
      },],},
      {
    uniId: "uni_024",
    name: "University of L'Aquila (UniAq)",
    location: "L'Aquila, Abruzzo",
    applicationRequirements: [
      {
        reqId: "req_uniaq_transcripts",
        type: "document",
        title: "HEC Attested Transcripts & Degree",
        generalGuide: "Official Bachelor's degree and all semester transcripts.",
        localInstructions:
          "Must be physically attested by the Higher Education Commission (HEC) in Pakistan.",
        isRequired: true,
        guideAvailable: true,
        sampleImageUrl:
          "https://res.cloudinary.com/dhxr1x9sx/image/upload/v1777465204/HEC_Attested_Degree_fvlfk5.jpg",
        physicalLocation: {
          name: "HEC Head Office, Islamabad",
          lat: 33.6601,
          lng: 73.044,
        },
      },
      {
        reqId: "req_uniaq_mofa",
        type: "document",
        title: "MOFA Attestation",
        generalGuide: "Legalization of your HEC-attested educational documents.",
        localInstructions:
          "Required before you can apply for the Declaration of Value or visa.",
        isRequired: true,
        guideAvailable: true,
        sampleImageUrl:
          "https://res.cloudinary.com/dhxr1x9sx/image/upload/v1777465203/MOFA_Attestation_eqa3ht.jpg",
        physicalLocation: {
          name: "Ministry of Foreign Affairs (MOFA)",
          lat: 33.7297,
          lng: 73.0975,
        },
      },
      {
        reqId: "req_uniaq_cimea",
        type: "document",
        title: "CIMEA Verification",
        generalGuide:
          "Statement of Comparability to verify your Pakistani 16-year education.",
        localInstructions:
          "L'Aquila strongly prefers CIMEA over DOV. Create your CIMEA Diplome account immediately upon admission.",
        isRequired: true,
        guideAvailable: true,
        sampleImageUrl:
          "https://res.cloudinary.com/dhxr1x9sx/image/upload/v1777465203/CIMEA_Certificate_umxkau.webp",
        physicalLocation: null,
      },
      {
        reqId: "req_uniaq_adsu",
        type: "document",
        title: "ADSU Scholarship",
        generalGuide: "Abruzzo regional scholarship for tuition waivers and stipends.",
        localInstructions:
          "L'Aquila is extremely student-friendly and affordable. ADSU requires your FRC and father's tax returns. Have them translated by an official embassy-approved translator.",
        isRequired: true,
        guideAvailable: true,
        sampleImageUrl:
          null,
        physicalLocation: null,
      },
    ],
  },
  {
    uniId: "uni_025",
    name: "University of Bergamo (UniBg)",
    location: "Bergamo, Lombardy",
    applicationRequirements: [
      {
        reqId: "req_unibg_transcripts",
        type: "document",
        title: "HEC Attested Transcripts & Degree",
        generalGuide: "Official Bachelor's degree and all semester transcripts.",
        localInstructions:
          "Must be physically attested by the Higher Education Commission (HEC) in Pakistan.",
        isRequired: true,
        guideAvailable: true,
        sampleImageUrl:
          "https://res.cloudinary.com/dhxr1x9sx/image/upload/v1777465204/HEC_Attested_Degree_fvlfk5.jpg",
        physicalLocation: {
          name: "HEC Head Office, Islamabad",
          lat: 33.6601,
          lng: 73.044,
        },
      },
      {
        reqId: "req_unibg_mofa",
        type: "document",
        title: "MOFA Attestation",
        generalGuide: "Legalization of your HEC-attested educational documents.",
        localInstructions:
          "Required before you can apply for the Declaration of Value or visa.",
        isRequired: true,
        guideAvailable: true,
        sampleImageUrl:
          "https://res.cloudinary.com/dhxr1x9sx/image/upload/v1777465203/MOFA_Attestation_eqa3ht.jpg",
        physicalLocation: {
          name: "Ministry of Foreign Affairs (MOFA)",
          lat: 33.7297,
          lng: 73.0975,
        },
      },
      {
        reqId: "req_unibg_cimea",
        type: "document",
        title: "CIMEA or DOV",
        generalGuide: "Verification of your degree equivalency.",
        localInstructions: "CIMEA is recommended for faster processing.",
        isRequired: true,
        guideAvailable: true,
        sampleImageUrl:
          "https://res.cloudinary.com/dhxr1x9sx/image/upload/v1777465203/CIMEA_Certificate_umxkau.webp",
        physicalLocation: null,
      },
      {
        reqId: "req_unibg_mot",
        type: "document",
        title: "Motivation Letter",
        generalGuide: "A tailored 1-page document detailing your background and goals.",
        localInstructions:
          "Bergamo has incredibly strong ties with local engineering and business industries. Mentioning a desire to do an internship with companies in the Lombardy region will make your application stand out heavily.",
        isRequired: true,
        guideAvailable: true,
        sampleImageUrl:
          null,
        physicalLocation: null,
      },
      {
        reqId: "req_unibg_passport",
        type: "document",
        title: "Valid Passport",
        generalGuide: "Scan of your valid Pakistani passport.",
        localInstructions:
          "Ensure your passport has at least two blank pages and is valid for the entire duration of your Master's degree (minimum 2.5 years) so you do not have to renew it at the Pakistani Embassy in Milan.",
        isRequired: true,
        guideAvailable: false,
        sampleImageUrl:
          "https://res.cloudinary.com/dhxr1x9sx/image/upload/v1777465204/Valid_Passport_etl96w.webp",
        physicalLocation: {
          name: "Regional Passport Office",
          lat: 31.5034,
          lng: 74.3315,
        },
      },
    ],
  },
];

async function seed() {
  const col = db.collection("universities_requirements");
  const batch = db.batch();
  for (const uni of universitiesRequirements) {
    const ref = col.doc(uni.uniId);
    batch.set(ref, uni);
  }
  await batch.commit();
  console.log(
    `✅ Seeded ${universitiesRequirements.length} university requirements to Firestore.`
  );
  process.exit(0);
}

seed().catch((err) => {
  console.error("❌ Seed failed:", err);
  process.exit(1);
});
