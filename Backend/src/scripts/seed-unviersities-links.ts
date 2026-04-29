import dotenv from "dotenv";
dotenv.config();

import { db } from "../config/firebase";

const universitiesLinks = [
  { uniId: "uni_001", name: "Politecnico di Milano (PoliMi)", applyUrl: "https://www.polimi.it/en/international-prospective-students" },
  { uniId: "uni_002", name: "Sapienza University of Rome", applyUrl: "https://www.uniroma1.it/en/pagina/international-admissions" },
  { uniId: "uni_003", name: "University of Bologna (Unibo)", applyUrl: "https://studenti.unibo.it/" },
  { uniId: "uni_004", name: "Politecnico di Torino (PoliTo)", applyUrl: "https://international.polito.it/admission" },
  { uniId: "uni_005", name: "University of Padua (UniPd)", applyUrl: "https://apply.unipd.it/" },
  { uniId: "uni_006", name: "University of Milan (La Statale)", applyUrl: "https://www.unimi.it/en/international/coming-abroad/enrol-programme/international-enrolment-degree-programmes" },
  { uniId: "uni_007", name: "University of Pisa (UniPi)", applyUrl: "https://apply.unipi.it/" },
  { uniId: "uni_008", name: "University of Florence (UniFi)", applyUrl: "https://apply.unifi.it/" },
  { uniId: "uni_009", name: "University of Turin (UniTo)", applyUrl: "https://apply.unito.it/" },
  { uniId: "uni_010", name: "University of Naples Federico II", applyUrl: "http://www.international.unina.it/" },
  { uniId: "uni_011", name: "Ca' Foscari University of Venice", applyUrl: "https://apply.unive.it/" },
  { uniId: "uni_012", name: "University of Trento (UniTrento)", applyUrl: "https://international.unitn.it/incoming/degree-seeking-students" },
  { uniId: "uni_013", name: "University of Pavia (UniPv)", applyUrl: "https://apply.unipv.eu/" },
  { uniId: "uni_014", name: "University of Siena (UniSi)", applyUrl: "https://apply.unisi.it/" },
  { uniId: "uni_015", name: "University of Calabria (UniCal)", applyUrl: "https://unical.admissionboard.com/" },
  { uniId: "uni_016", name: "Politecnico di Bari (PoliBa)", applyUrl: "https://www.poliba.it/it/internazionale/international-students" },
  { uniId: "uni_017", name: "University of Messina (UniMe)", applyUrl: "https://unime.dreamapply.com/" },
  { uniId: "uni_018", name: "University of Cassino and Southern Lazio (UniCas)", applyUrl: "https://apply.unicas.it/" },
  { uniId: "uni_019", name: "University of Camerino (UniCam)", applyUrl: "https://international.unicam.it/admissions" },
  { uniId: "uni_020", name: "University of Genoa (UniGe)", applyUrl: "https://unige.it/en/usg/en/international-enrollment" },
  { uniId: "uni_021", name: "University of Milano-Bicocca (UniMiB)", applyUrl: "https://en.unimib.it/international/international-students" },
  { uniId: "uni_022", name: "University of Parma (UniPr)", applyUrl: "https://en.unipr.it/studying/international-students" },
  { uniId: "uni_023", name: "University of Verona (UniVr)", applyUrl: "https://apply.univr.it/" },
  { uniId: "uni_024", name: "University of L'Aquila (UniAq)", applyUrl: "https://www.univaq.it/en/section.php?id=2081" },
  { uniId: "uni_025", name: "University of Bergamo (UniBg)", applyUrl: "https://apply.unibg.it/" },
];

async function seed() {
  const col = db.collection("universities_links");
  const batch = db.batch();

  for (const uni of universitiesLinks) {
    const ref = col.doc(uni.uniId);
    batch.set(ref, uni);
  }

  await batch.commit();
  console.log(`✅ Seeded ${universitiesLinks.length} university links to Firestore.`);
  process.exit(0);
}

seed().catch((err) => {
  console.error("❌ Seed failed:", err);
  process.exit(1);
});
