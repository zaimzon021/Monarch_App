import dotenv from "dotenv";
dotenv.config();

import { db } from "../config/firebase";

const universities = [
  {
    "id": "uni_001",
    "name": "Politecnico di Milano",
    "location": "Milan, Italy",
    "type": "Public",
    "worldRank": 123,
    "acceptanceRate": 25,
    "tuitionFee": "€3,900/yr",
    "requiredGpa": 3.0,
    "languageRequirements": { "ielts": 6.0, "toefl": 78, "pte": 50, "duolingo": 105 },
    "programs": ["BSc Engineering Science", "BSc Architectural Design", "MSc Computer Science and Engineering", "MSc Artificial Intelligence", "MSc Management Engineering"],
    "financialAid": { "acceptsDSU": true, "regionalBody": "EDiSU Lombardia" },
    "imageUrl": "https://res.cloudinary.com/dhxr1x9sx/image/upload/v1776753773/Politecnico_di_Milano_mmn1dn.jpg"
  },
  {
    "id": "uni_002",
    "name": "Università di Bologna",
    "location": "Bologna, Italy",
    "type": "Public",
    "worldRank": 154,
    "acceptanceRate": 30,
    "tuitionFee": "€3,000/yr",
    "requiredGpa": 2.8,
    "languageRequirements": { "ielts": 6.0, "toefl": 80, "pte": 50, "duolingo": 105 },
    "programs": ["BSc Economics and Finance", "BSc Information Engineering", "MSc Artificial Intelligence", "MSc Data Science", "MSc Software Engineering"],
    "financialAid": { "acceptsDSU": true, "regionalBody": "ER.GO" },
    "imageUrl": "https://res.cloudinary.com/dhxr1x9sx/image/upload/v1776753783/Universit%C3%A0_di_Bologna_vj5onq.jpg"
  },
  {
    "id": "uni_003",
    "name": "Sapienza Università di Roma",
    "location": "Rome, Italy",
    "type": "Public",
    "worldRank": 134,
    "acceptanceRate": 40,
    "tuitionFee": "€2,900/yr",
    "requiredGpa": 2.8,
    "languageRequirements": { "ielts": 5.5, "toefl": 72, "pte": 42, "duolingo": 95 },
    "programs": ["BSc Applied Computer Science and Artificial Intelligence", "BSc Computer Science", "MSc Cybersecurity", "MSc Data Science", "MSc Computer Engineering"],
    "financialAid": { "acceptsDSU": true, "regionalBody": "LazioDisco" },
    "imageUrl": "https://res.cloudinary.com/dhxr1x9sx/image/upload/v1776753774/Sapienza_Universit%C3%A0_di_Roma_py0vwn.jpg"
  },
  {
    "id": "uni_004",
    "name": "Università di Padova",
    "location": "Padua, Italy",
    "type": "Public",
    "worldRank": 219,
    "acceptanceRate": 35,
    "tuitionFee": "€2,600/yr",
    "requiredGpa": 3.0,
    "languageRequirements": { "ielts": 6.0, "toefl": 80, "pte": 50, "duolingo": 105 },
    "programs": ["BSc Information Engineering", "BSc Psychological Science", "MSc Computer Engineering", "MSc Data Science", "MSc ICT for Internet and Multimedia"],
    "financialAid": { "acceptsDSU": true, "regionalBody": "ESU Padova" },
    "imageUrl": "https://res.cloudinary.com/dhxr1x9sx/image/upload/v1776753797/Universit%C3%A0_di_Padova_owbmrb.jpg"
  },
  {
    "id": "uni_005",
    "name": "Politecnico di Torino",
    "location": "Turin, Italy",
    "type": "Public",
    "worldRank": 252,
    "acceptanceRate": 30,
    "tuitionFee": "€2,600/yr",
    "requiredGpa": 3.0,
    "languageRequirements": { "ielts": 5.5, "toefl": 72, "pte": 42, "duolingo": 95 },
    "programs": ["BSc Computer Engineering", "BSc Electronic and Communications Engineering", "BSc Automotive Engineering", "MSc Cybersecurity", "MSc Data Science and Engineering"],
    "financialAid": { "acceptsDSU": true, "regionalBody": "EDISU Piemonte" },
    "imageUrl": "https://res.cloudinary.com/dhxr1x9sx/image/upload/v1776753774/Politecnico_di_Torino_gl4h4s.jpg"
  },
  {
    "id": "uni_006",
    "name": "Università degli Studi di Milano",
    "location": "Milan, Italy",
    "type": "Public",
    "worldRank": 276,
    "acceptanceRate": 45,
    "tuitionFee": "€3,000/yr",
    "requiredGpa": 2.8,
    "languageRequirements": { "ielts": 6.0, "toefl": 78, "pte": 50, "duolingo": 105 },
    "programs": ["BSc International Politics, Law and Economics", "MSc Computer Science", "MSc Data Science and Economics", "MSc Bioinformatics for Computational Genomics"],
    "financialAid": { "acceptsDSU": true, "regionalBody": "CIDiS Lombardia" },
    "imageUrl": "https://res.cloudinary.com/dhxr1x9sx/image/upload/v1776753781/Universit%C3%A0_degli_Studi_di_Milano_yptbt6.jpg"
  },
  {
    "id": "uni_007",
    "name": "Università di Napoli Federico II",
    "location": "Naples, Italy",
    "type": "Public",
    "worldRank": 335,
    "acceptanceRate": 50,
    "tuitionFee": "€2,000/yr",
    "requiredGpa": 2.5,
    "languageRequirements": { "ielts": 5.5, "toefl": 72, "pte": 42, "duolingo": 95 },
    "programs": ["BSc Biology", "MSc Computer Engineering", "MSc Data Science", "MSc Mathematical Engineering"],
    "financialAid": { "acceptsDSU": true, "regionalBody": "ADISURC" },
    "imageUrl": "https://res.cloudinary.com/dhxr1x9sx/image/upload/v1776753797/Universit%C3%A0_di_Napoli_Federico_II_xvbel0.avif"
  },
  {
    "id": "uni_008",
    "name": "Università di Pisa",
    "location": "Pisa, Italy",
    "type": "Public",
    "worldRank": 349,
    "acceptanceRate": 40,
    "tuitionFee": "€2,400/yr",
    "requiredGpa": 2.5,
    "languageRequirements": { "ielts": 5.5, "toefl": 70, "pte": 42, "duolingo": 95 },
    "programs": ["BSc Management for Business and Economics", "MSc Computer Science", "MSc Computer Engineering", "MSc Artificial Intelligence and Data Engineering"],
    "financialAid": { "acceptsDSU": true, "regionalBody": "DSU Toscana" },
    "imageUrl": "https://res.cloudinary.com/dhxr1x9sx/image/upload/v1776753798/Universit%C3%A0_di_Pisa_oqyfhx.jpg"
  },
  {
    "id": "uni_009",
    "name": "Università degli Studi di Firenze",
    "location": "Florence, Italy",
    "type": "Public",
    "worldRank": 358,
    "acceptanceRate": 45,
    "tuitionFee": "€2,500/yr",
    "requiredGpa": 2.5,
    "languageRequirements": { "ielts": 5.5, "toefl": 72, "pte": 42, "duolingo": 95 },
    "programs": ["MSc Software: Science and Technology", "MSc Geoengineering", "MSc Economics and Development"],
    "financialAid": { "acceptsDSU": true, "regionalBody": "DSU Toscana" },
    "imageUrl": "https://res.cloudinary.com/dhxr1x9sx/image/upload/v1776753782/Universit%C3%A0_degli_Studi_di_Firenze_czv8mf.jpg"
  },
  {
    "id": "uni_010",
    "name": "Università degli Studi di Torino",
    "location": "Turin, Italy",
    "type": "Public",
    "worldRank": 365,
    "acceptanceRate": 50,
    "tuitionFee": "€2,800/yr",
    "requiredGpa": 2.5,
    "languageRequirements": { "ielts": 5.5, "toefl": 72, "pte": 42, "duolingo": 95 },
    "programs": ["BSc Business & Management", "BSc Global Law and Transnational Legal Studies", "MSc Stochastics and Data Science"],
    "financialAid": { "acceptsDSU": true, "regionalBody": "EDISU Piemonte" },
    "imageUrl": "https://res.cloudinary.com/dhxr1x9sx/image/upload/v1776753782/Universit%C3%A0_degli_Studi_di_Torino_zp4rfi.jpg"
  },
  {
    "id": "uni_011",
    "name": "Università degli Studi di Trento",
    "location": "Trento, Italy",
    "type": "Public",
    "worldRank": 429,
    "acceptanceRate": 30,
    "tuitionFee": "€3,000/yr",
    "requiredGpa": 3.0,
    "languageRequirements": { "ielts": 6.0, "toefl": 80, "pte": 50, "duolingo": 105 },
    "programs": ["BSc Computer, Communication and Electronic Engineering", "MSc Computer Science", "MSc Artificial Intelligence Systems"],
    "financialAid": { "acceptsDSU": true, "regionalBody": "Opera Universitaria" },
    "imageUrl": "https://res.cloudinary.com/dhxr1x9sx/image/upload/v1776753782/Universit%C3%A0_degli_Studi_di_Trento_nb7ykt.jpg"
  },
  {
    "id": "uni_012",
    "name": "Università degli Studi di Milano-Bicocca",
    "location": "Milan, Italy",
    "type": "Public",
    "worldRank": 481,
    "acceptanceRate": 40,
    "tuitionFee": "€3,000/yr",
    "requiredGpa": 2.8,
    "languageRequirements": { "ielts": 6.0, "toefl": 78, "pte": 50, "duolingo": 105 },
    "programs": ["BSc Psychological Science", "MSc Artificial Intelligence for Science and Technology", "MSc Applied Experimental Psychological Sciences"],
    "financialAid": { "acceptsDSU": true, "regionalBody": "CIDiS Lombardia" },
    "imageUrl": "https://res.cloudinary.com/dhxr1x9sx/image/upload/v1776753796/Universit%C3%A0_di_Milano-Bicocca_g5pq26.jpg"
  },
  {
    "id": "uni_013",
    "name": "Università Cattolica del Sacro Cuore",
    "location": "Milan, Italy",
    "type": "Private",
    "worldRank": 505,
    "acceptanceRate": 35,
    "tuitionFee": "€6,000/yr",
    "requiredGpa": 3.0,
    "languageRequirements": { "ielts": 6.0, "toefl": 80, "pte": 50, "duolingo": 105 },
    "programs": ["BSc Economics and Management", "BSc Food Production Management", "MSc Applied Data Science for Banking and Finance"],
    "financialAid": { "acceptsDSU": false, "regionalBody": "EDUCatt (Internal)" },
    "imageUrl": "https://res.cloudinary.com/dhxr1x9sx/image/upload/v1776753773/Universit%C3%A0_Cattolica_del_Sacro_Cuore_rvraru.jpg"
  },
  {
    "id": "uni_014",
    "name": "Università di Pavia",
    "location": "Pavia, Italy",
    "type": "Public",
    "worldRank": 469,
    "acceptanceRate": 40,
    "tuitionFee": "€2,500/yr",
    "requiredGpa": 2.8,
    "languageRequirements": { "ielts": 5.5, "toefl": 72, "pte": 42, "duolingo": 95 },
    "programs": ["BSc Artificial Intelligence", "MSc Computer Engineering", "MSc Electronic Engineering"],
    "financialAid": { "acceptsDSU": true, "regionalBody": "EDiSU Pavia" },
    "imageUrl": "https://res.cloudinary.com/dhxr1x9sx/image/upload/v1776753797/Universit%C3%A0_di_Pavia_shunr7.jpg"
  },
  {
    "id": "uni_015",
    "name": "Ca' Foscari University of Venice",
    "location": "Venice, Italy",
    "type": "Public",
    "worldRank": 518,
    "acceptanceRate": 35,
    "tuitionFee": "€2,100/yr",
    "requiredGpa": 2.8,
    "languageRequirements": { "ielts": 5.5, "toefl": 72, "pte": 42, "duolingo": 95 },
    "programs": ["BSc Digital Management", "BSc Economics and Business", "MSc Computer Science and Information Technology", "MSc Data Analytics for Business and Society"],
    "financialAid": { "acceptsDSU": true, "regionalBody": "ESU Venezia" },
    "imageUrl": "https://res.cloudinary.com/dhxr1x9sx/image/upload/v1776753803/Ca_Foscari_University_of_Venice_jynsla.jpg"
  },
  {
    "id": "uni_016",
    "name": "Università di Genova",
    "location": "Genoa, Italy",
    "type": "Public",
    "worldRank": 731,
    "acceptanceRate": 45,
    "tuitionFee": "€2,000/yr",
    "requiredGpa": 2.5,
    "languageRequirements": { "ielts": 5.5, "toefl": 72, "pte": 42, "duolingo": 95 },
    "programs": ["BSc Maritime Science and Technology", "MSc Computer Engineering", "MSc Robotics Engineering"],
    "financialAid": { "acceptsDSU": true, "regionalBody": "ALISEO" },
    "imageUrl": "https://res.cloudinary.com/dhxr1x9sx/image/upload/v1776753796/Universit%C3%A0_di_Genova_c5obas.jpg"
  },
  {
    "id": "uni_017",
    "name": "Università di Roma Tor Vergata",
    "location": "Rome, Italy",
    "type": "Public",
    "worldRank": 393,
    "acceptanceRate": 40,
    "tuitionFee": "€2,500/yr",
    "requiredGpa": 2.8,
    "languageRequirements": { "ielts": 6.0, "toefl": 80, "pte": 50, "duolingo": 105 },
    "programs": ["BSc Engineering Sciences", "BSc Global Governance", "MSc Computer Engineering"],
    "financialAid": { "acceptsDSU": true, "regionalBody": "LazioDisco" },
    "imageUrl": "https://res.cloudinary.com/dhxr1x9sx/image/upload/v1776753799/Universit%C3%A0_di_Roma_Tor_Vergata_nje7ff.jpg"
  },
  {
    "id": "uni_018",
    "name": "Politecnico di Bari",
    "location": "Bari, Italy",
    "type": "Public",
    "worldRank": 601,
    "acceptanceRate": 30,
    "tuitionFee": "€1,800/yr",
    "requiredGpa": 2.8,
    "languageRequirements": { "ielts": 5.5, "toefl": 72, "pte": 42, "duolingo": 95 },
    "programs": ["MSc Computer Engineering", "MSc Mechanical Engineering", "MSc Telecommunications Engineering"],
    "financialAid": { "acceptsDSU": true, "regionalBody": "ADISU Puglia" },
    "imageUrl": "https://res.cloudinary.com/dhxr1x9sx/image/upload/v1776753774/Politecnico_di_Bari_fhhb0d.png"
  },
  {
    "id": "uni_019",
    "name": "Università di Siena",
    "location": "Siena, Italy",
    "type": "Public",
    "worldRank": 701,
    "acceptanceRate": 50,
    "tuitionFee": "€2,200/yr",
    "requiredGpa": 2.5,
    "languageRequirements": { "ielts": 5.5, "toefl": 72, "pte": 42, "duolingo": 95 },
    "programs": ["BSc Economics and Banking", "MSc Applied Mathematics", "MSc Engineering Management", "MSc Artificial Intelligence and Automation Engineering"],
    "financialAid": { "acceptsDSU": true, "regionalBody": "DSU Toscana" },
    "imageUrl": "https://res.cloudinary.com/dhxr1x9sx/image/upload/v1776753799/Universit%C3%A0_di_Siena_zsxygw.jpg"
  },
  {
    "id": "uni_020",
    "name": "Università degli Studi di Verona",
    "location": "Verona, Italy",
    "type": "Public",
    "worldRank": 801,
    "acceptanceRate": 45,
    "tuitionFee": "€2,400/yr",
    "requiredGpa": 2.5,
    "languageRequirements": { "ielts": 5.5, "toefl": 72, "pte": 42, "duolingo": 95 },
    "programs": ["MSc Computer Engineering for Robotics and Smart Industry", "MSc Data Science", "MSc Mathematics"],
    "financialAid": { "acceptsDSU": true, "regionalBody": "ESU Verona" },
    "imageUrl": "https://res.cloudinary.com/dhxr1x9sx/image/upload/v1776753782/Universit%C3%A0_degli_Studi_di_Verona_tdvvgq.jpg"
  },
  {
    "id": "uni_021",
    "name": "Università Roma Tre",
    "location": "Rome, Italy",
    "type": "Public",
    "worldRank": 751,
    "acceptanceRate": 50,
    "tuitionFee": "€2,000/yr",
    "requiredGpa": 2.5,
    "languageRequirements": { "ielts": 5.5, "toefl": 72, "pte": 42, "duolingo": 95 },
    "programs": ["MSc Computer Science", "MSc Biomedical Engineering", "MSc Economics"],
    "financialAid": { "acceptsDSU": true, "regionalBody": "LazioDisco" },
    "imageUrl": "https://res.cloudinary.com/dhxr1x9sx/image/upload/v1776753799/Universit%C3%A0_Roma_Tre_ktpstr.jpg"
  },
  {
    "id": "uni_022",
    "name": "Università degli Studi di Palermo",
    "location": "Palermo, Italy",
    "type": "Public",
    "worldRank": 601,
    "acceptanceRate": 55,
    "tuitionFee": "€1,800/yr",
    "requiredGpa": 2.5,
    "languageRequirements": { "ielts": 5.5, "toefl": 72, "pte": 42, "duolingo": 95 },
    "programs": ["MSc Computer Engineering", "MSc Electronics Engineering", "MSc Tourism Systems and Hospitality Management"],
    "financialAid": { "acceptsDSU": true, "regionalBody": "ERSU Palermo" },
    "imageUrl": "https://res.cloudinary.com/dhxr1x9sx/image/upload/v1776753781/Universit%C3%A0_degli_Studi_di_Palermo_ql2ddc.png"
  },
  {
    "id": "uni_023",
    "name": "Università di Catania",
    "location": "Catania, Italy",
    "type": "Public",
    "worldRank": 801,
    "acceptanceRate": 55,
    "tuitionFee": "€1,800/yr",
    "requiredGpa": 2.5,
    "languageRequirements": { "ielts": 5.5, "toefl": 72, "pte": 42, "duolingo": 95 },
    "programs": ["MSc Data Science for Management", "MSc Electrical Engineering", "MSc Chemical Engineering"],
    "financialAid": { "acceptsDSU": true, "regionalBody": "ERSU Catania" },
    "imageUrl": "https://res.cloudinary.com/dhxr1x9sx/image/upload/v1776753796/Universit%C3%A0_di_Catania_rj7kpw.jpg"
  },
  {
    "id": "uni_024",
    "name": "Università degli Studi di Bari Aldo Moro",
    "location": "Bari, Italy",
    "type": "Public",
    "worldRank": 501,
    "acceptanceRate": 45,
    "tuitionFee": "€1,900/yr",
    "requiredGpa": 2.5,
    "languageRequirements": { "ielts": 5.5, "toefl": 72, "pte": 42, "duolingo": 95 },
    "programs": ["BSc Computer Science and Software Engineering", "MSc Computer Science", "MSc Physics"],
    "financialAid": { "acceptsDSU": true, "regionalBody": "ADISU Puglia" },
    "imageUrl": "https://res.cloudinary.com/dhxr1x9sx/image/upload/v1776753774/Universit%C3%A0_degli_Studi_di_Bari_Aldo_Moro_ocqcfb.jpg"
  },
  {
    "id": "uni_025",
    "name": "Bocconi University",
    "location": "Milan, Italy",
    "type": "Private",
    "worldRank": 162,
    "acceptanceRate": 15,
    "tuitionFee": "€14,000/yr",
    "requiredGpa": 3.5,
    "languageRequirements": { "ielts": 6.5, "toefl": 90, "pte": 58, "duolingo": 115 },
    "programs": ["BSc International Economics and Management", "BSc Mathematical and Computing Sciences for Artificial Intelligence", "MSc Cyber Risk Strategy and Governance"],
    "financialAid": { "acceptsDSU": false, "regionalBody": "ISU Bocconi (Internal)" },
    "imageUrl": "https://res.cloudinary.com/dhxr1x9sx/image/upload/v1776753774/Bocconi_University_qllow8.jpg"
  }
];

async function seed() {
  const col = db.collection("universities");
  const batch = db.batch();
  
  for (const uni of universities) {
    const { id, ...data } = uni;
    const ref = col.doc(id);
    batch.set(ref, data);
  }

  await batch.commit();
  console.log(`✅ Seeded ${universities.length} universities to Firestore.`);
  process.exit(0);
}

seed().catch((err) => {
  console.error("❌ Seed failed:", err);
  process.exit(1);
});
