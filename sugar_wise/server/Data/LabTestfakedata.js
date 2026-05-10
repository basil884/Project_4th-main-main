const labTestFakeData = [
  {
    title: "Hemoglobin A1c Test",
    date: "2026-04-10",
    type: "pdf",
    fileUrl: "/uploads/lab-tests/hba1c_results_001.pdf",
    notes: "Everything seems normal.",
    Patient_Id: "PID_00001",
    Name: "Layla Ali",
    productId: "69dbf5777dc42ddb2a464bdf"
  },
  {
    title: "Fasting Blood Sugar",
    date: "2026-04-11",
    type: "image",
    fileUrl: "/uploads/lab-tests/sugar_level_chart.jpg",
    notes: "Measured after 8 hours of fasting.",
    Patient_Id: "PID_00001",
    Name: "Layla Ali",
    productId: "69dbf5777dc42ddb2a464be3"
  },
  {
    title: "Lipid Panel",
    date: "2026-04-05",
    type: "pdf",
    fileUrl: "/uploads/lab-tests/lipid_results.pdf",
    notes: "Cholesterol levels are slightly high.",
    Patient_Id: "PID_00002",
    Name: "Mahmoud Mohamed",
    productId: null
  },
  {
    title: "Kidney Function Test",
    date: "2026-04-12",
    type: "text",
    fileUrl: null,
    notes: "Creatinine levels: 0.9 mg/dL",
    Patient_Id: "PID_00002",
    Name: "Mahmoud Mohamed",
    productId: null
  },
  {
    title: "Glucose Tolerance Test",
    date: "2026-04-08",
    type: "pdf",
    fileUrl: "/uploads/lab-tests/gtt_report.pdf",
    notes: "2-hour post-glucose reading was high.",
    Patient_Id: "PID_00003",
    Name: "Mona Ibrahim",
    productId: "69dbf5777dc42ddb2a464bdf"
  },
  {
    title: "Complete Blood Count (CBC)",
    date: "2026-04-09",
    type: "image",
    fileUrl: "/uploads/lab-tests/cbc_scan.png",
    notes: "Normal range for all components.",
    Patient_Id: "PID_00004",
    Name: "Ali Youssef",
    productId: null
  },
  {
    title: "Urinalysis",
    date: "2026-04-11",
    type: "pdf",
    fileUrl: "/uploads/lab-tests/urinalysis_results.pdf",
    notes: "Checking for protein presence.",
    Patient_Id: "PID_00005",
    Name: "Sara Hassan",
    productId: null
  },
  {
    title: "Thyroid Profile (T3, T4, TSH)",
    date: "2026-04-07",
    type: "pdf",
    fileUrl: "/uploads/lab-tests/thyroid_report.pdf",
    notes: "TSH slightly elevated.",
    Patient_Id: "PID_00006",
    Name: "Mohamed Ali",
    productId: null
  },
  {
    title: "Blood Pressure Monitoring",
    date: "2026-04-12",
    type: "text",
    fileUrl: null,
    notes: "Reading: 130/85 mmHg",
    Patient_Id: "PID_00007",
    Name: "Nour Mohamed",
    productId: null
  },
  {
    title: "Electrolyte Panel",
    date: "2026-04-06",
    type: "pdf",
    fileUrl: "/uploads/lab-tests/electrolytes.pdf",
    notes: "Sodium and Potassium are stable.",
    Patient_Id: "PID_00008",
    Name: "Omar Ibrahim",
    productId: null
  },
  {
    title: "HBA1c Monthly Check",
    date: "2026-03-25",
    type: "pdf",
    fileUrl: "/uploads/lab-tests/hba1c_march.pdf",
    notes: "Progressing well since last month.",
    Patient_Id: "PID_00009",
    Name: "Aya Youssef",
    productId: "69dbf5777dc42ddb2a464be3"
  },
  {
    title: "Liver Function Test",
    date: "2026-04-01",
    type: "image",
    fileUrl: "/uploads/lab-tests/lft_scan.jpg",
    notes: "Normal liver enzymes.",
    Patient_Id: "PID_00010",
    Name: "Ahmed Hassan",
    productId: null
  },
  {
    title: "Microalbuminuria Test",
    date: "2026-04-11",
    type: "pdf",
    fileUrl: "/uploads/lab-tests/microalbumin_results.pdf",
    notes: "No signs of kidney damage.",
    Patient_Id: "PID_00011",
    Name: "Layla Ali",
    productId: null
  },
  {
    title: "C-Peptide Test",
    date: "2026-03-28",
    type: "pdf",
    fileUrl: "/uploads/lab-tests/cpeptide_report.pdf",
    notes: "Insulin production level check.",
    Patient_Id: "PID_00012",
    Name: "Mahmoud Mohamed",
    productId: "69dbf5777dc42ddb2a464be1"
  },
  {
    title: "Vitamin D Deficiency Test",
    date: "2026-04-05",
    type: "text",
    fileUrl: null,
    notes: "Level: 25 ng/mL (Low)",
    Patient_Id: "PID_00013",
    Name: "Mona Ibrahim",
    productId: null
  },
  {
    title: "Eye Exam Report",
    date: "2026-04-10",
    type: "pdf",
    fileUrl: "/uploads/lab-tests/retinopathy_screen.pdf",
    notes: "No diabetic retinopathy detected.",
    Patient_Id: "PID_00014",
    Name: "Ali Youssef",
    productId: null
  },
  {
    title: "Foot Sensitivity Test",
    date: "2026-04-12",
    type: "text",
    fileUrl: null,
    notes: "Monofilament test passed for both feet.",
    Patient_Id: "PID_00015",
    Name: "Sara Hassan",
    productId: null
  },
  {
    title: "Standard Glucose Report",
    date: "2026-04-11",
    type: "image",
    fileUrl: "/uploads/lab-tests/glucose_report_1.png",
    notes: "Periodic check-up.",
    Patient_Id: "PID_00016",
    Name: "Mohamed Ali",
    productId: "69dbf5777dc42ddb2a464bdf"
  },
  {
    title: "Iron Profile Test",
    date: "2026-04-03",
    type: "pdf",
    fileUrl: "/uploads/lab-tests/iron_study.pdf",
    notes: "Slight anemia noted.",
    Patient_Id: "PID_00017",
    Name: "Nour Mohamed",
    productId: null
  },
  {
    title: "Post-Prandial Glucose",
    date: "2026-04-11",
    type: "text",
    fileUrl: null,
    notes: "2 hours after lunch: 160 mg/dL",
    Patient_Id: "PID_00018",
    Name: "Omar Ibrahim",
    productId: null
  },
  {
    title: "Urine Culture",
    date: "2026-04-09",
    type: "pdf",
    fileUrl: "/uploads/lab-tests/culture_results.pdf",
    notes: "No bacterial growth detected.",
    Patient_Id: "PID_00019",
    Name: "Aya Youssef",
    productId: null
  },
  {
    title: "Vitamin B12 Level",
    date: "2026-04-08",
    type: "text",
    fileUrl: null,
    notes: "Level: 450 pg/mL",
    Patient_Id: "PID_00020",
    Name: "Ahmed Hassan",
    productId: null
  },
  {
    title: "Annual Heart Check",
    date: "2026-04-12",
    type: "pdf",
    fileUrl: "/uploads/lab-tests/ecg_report.pdf",
    notes: "ECG shows normal rhythm.",
    Patient_Id: "PID_00021",
    Name: "Layla Ali",
    productId: null
  },
  {
    title: "Glucose Tolerance Report",
    date: "2026-04-10",
    type: "pdf",
    fileUrl: "/uploads/lab-tests/gtt_021.pdf",
    notes: "Results for GTT checkup.",
    Patient_Id: "PID_00021",
    Name: "Layla Ali",
    productId: "69dbf5777dc42ddb2a464be3"
  },
  {
    title: "Metabolic Panel",
    date: "2026-04-11",
    type: "pdf",
    fileUrl: "/uploads/lab-tests/metabolic_results.pdf",
    notes: "General metabolic health check.",
    Patient_Id: "PID_00022",
    Name: "Mahmoud Mohamed",
    productId: null
  },
  {
    title: "Random Blood Sugar",
    date: "2026-04-12",
    type: "text",
    fileUrl: null,
    notes: "Reading: 145 mg/dL",
    Patient_Id: "PID_00023",
    Name: "Mona Ibrahim",
    productId: null
  },
  {
    title: "Insulin Resistance Test",
    date: "2026-04-07",
    type: "pdf",
    fileUrl: "/uploads/lab-tests/homa_ir.pdf",
    notes: "Calculated HOMA-IR: 2.5",
    Patient_Id: "PID_00024",
    Name: "Ali Youssef",
    productId: "69dbf5777dc42ddb2a464be1"
  },
  {
    title: "Skin Integrity Scan",
    date: "2026-04-05",
    type: "image",
    fileUrl: "/uploads/lab-tests/skin_scan.jpg",
    notes: "No diabetic ulcers found.",
    Patient_Id: "PID_00025",
    Name: "Sara Hassan",
    productId: null
  },
  {
    title: "HBA1c Lab Results",
    date: "2026-04-12",
    type: "pdf",
    fileUrl: "/uploads/lab-tests/hba1c_latest.pdf",
    notes: "7.2% - needs improvement.",
    Patient_Id: "PID_00026",
    Name: "Mohamed Ali",
    productId: null
  },
  {
    title: "Bone Density Scan",
    date: "2026-04-08",
    type: "pdf",
    fileUrl: "/uploads/lab-tests/dexa_scan.pdf",
    notes: "Normal bone density.",
    Patient_Id: "PID_00027",
    Name: "Nour Mohamed",
    productId: null
  },
  {
    title: "Pulmonary Function Test",
    date: "2026-04-06",
    type: "pdf",
    fileUrl: "/uploads/lab-tests/pft_report.pdf",
    notes: "Lung capacity is normal.",
    Patient_Id: "PID_00028",
    Name: "Omar Ibrahim",
    productId: null
  },
  {
    title: "Blood Gas Analysis",
    date: "2026-04-11",
    type: "text",
    fileUrl: null,
    notes: "pH: 7.41, pCO2: 40 mmHg",
    Patient_Id: "PID_00029",
    Name: "Aya Youssef",
    productId: null
  },
  {
    title: "Inflammation Markers",
    date: "2026-04-09",
    type: "pdf",
    fileUrl: "/uploads/lab-tests/crp_results.pdf",
    notes: "CRP within normal limits.",
    Patient_Id: "PID_00030",
    Name: "Ahmed Hassan",
    productId: null
  },
  {
    title: "Glucose Strip Calibration",
    date: "2026-04-12",
    type: "image",
    fileUrl: "/uploads/lab-tests/calibration.jpg",
    notes: "Using new test strip batch.",
    Patient_Id: "PID_00031",
    Name: "Layla Ali",
    productId: "69dbf5777dc42ddb2a464be2"
  },
  {
    title: "Liver Enzyme Check",
    date: "2026-04-10",
    type: "pdf",
    fileUrl: "/uploads/lab-tests/liver_enzymes.pdf",
    notes: "ALT and AST are normal.",
    Patient_Id: "PID_00032",
    Name: "Mahmoud Mohamed",
    productId: null
  },
  {
    title: "Glucose Meter Sync",
    date: "2026-04-12",
    type: "text",
    fileUrl: null,
    notes: "Synchronized with cloud successfully.",
    Patient_Id: "PID_00033",
    Name: "Mona Ibrahim",
    productId: "69dbf5777dc42ddb2a464bdf"
  },
  {
    title: "Pancreas Ultrasound",
    date: "2026-03-30",
    type: "pdf",
    fileUrl: "/uploads/lab-tests/ultrasound_report.pdf",
    notes: "No structural abnormalities.",
    Patient_Id: "PID_00034",
    Name: "Ali Youssef",
    productId: null
  },
  {
    title: "Serum Creatinine",
    date: "2026-04-11",
    type: "text",
    fileUrl: null,
    notes: "0.85 mg/dL",
    Patient_Id: "PID_00035",
    Name: "Sara Hassan",
    productId: null
  },
  {
    title: "Daily Glucose Log",
    date: "2026-04-12",
    type: "pdf",
    fileUrl: "/uploads/lab-tests/daily_log.pdf",
    notes: "All readings within target range.",
    Patient_Id: "PID_00001",
    Name: "Layla Ali",
    productId: "69dbf5777dc42ddb2a464be3"
  },
  {
    title: "Monthly Progress Report",
    date: "2026-04-01",
    type: "pdf",
    fileUrl: "/uploads/lab-tests/monthly_summary.pdf",
    notes: "Great improvement in diet control.",
    Patient_Id: "PID_00002",
    Name: "Mahmoud Mohamed",
    productId: null
  },
  {
    title: "Ketone Level Test",
    date: "2026-04-12",
    type: "text",
    fileUrl: null,
    notes: "Negative for ketones.",
    Patient_Id: "PID_00003",
    Name: "Mona Ibrahim",
    productId: null
  },
  {
    title: "Insulin Dosage Review",
    date: "2026-04-11",
    type: "pdf",
    fileUrl: "/uploads/lab-tests/insulin_review.pdf",
    notes: "Adjusting lantus units.",
    Patient_Id: "PID_00004",
    Name: "Ali Youssef",
    productId: "69dbf5777dc42ddb2a464be1"
  },
  {
    title: "Blood Flow Study",
    date: "2026-04-08",
    type: "pdf",
    fileUrl: "/uploads/lab-tests/doppler_study.pdf",
    notes: "Normal peripheral circulation.",
    Patient_Id: "PID_00005",
    Name: "Sara Hassan",
    productId: null
  },
  {
    title: "General Toxicity Screen",
    date: "2026-04-07",
    type: "pdf",
    fileUrl: "/uploads/lab-tests/tox_screen.pdf",
    notes: "No prohibited substances found.",
    Patient_Id: "PID_00006",
    Name: "Mohamed Ali",
    productId: null
  },
  {
    title: "Oral Glucose Challenge",
    date: "2026-04-09",
    type: "pdf",
    fileUrl: "/uploads/lab-tests/ogtt_results.pdf",
    notes: "Passed the 1-hour screen.",
    Patient_Id: "PID_00007",
    Name: "Nour Mohamed",
    productId: null
  },
  {
    title: "Cardiac Enzyme Test",
    date: "2026-04-12",
    type: "text",
    fileUrl: null,
    notes: "Troponin level: <0.01 ng/mL",
    Patient_Id: "PID_00008",
    Name: "Omar Ibrahim",
    productId: null
  },
  {
    title: "Body Composition Analysis",
    date: "2026-04-10",
    type: "image",
    fileUrl: "/uploads/lab-tests/body_comp.png",
    notes: "Body fat percentage: 22%",
    Patient_Id: "PID_00009",
    Name: "Aya Youssef",
    productId: null
  },
  {
    title: "Metabolic Rate Test",
    date: "2026-04-11",
    type: "pdf",
    fileUrl: "/uploads/lab-tests/bmr_report.pdf",
    notes: "BMR: 1850 kcal/day",
    Patient_Id: "PID_00010",
    Name: "Ahmed Hassan",
    productId: null
  },
  {
    title: "Stress Test Report",
    date: "2026-04-12",
    type: "pdf",
    fileUrl: "/uploads/lab-tests/stress_test.pdf",
    notes: "Normal cardiovascular response.",
    Patient_Id: "PID_00010",
    Name: "Ahmed Hassan",
    productId: null
  },
  {
    title: "Emergency Lab Check",
    date: "2026-04-12",
    type: "text",
    fileUrl: null,
    notes: "All vitals stable after mild low.",
    Patient_Id: "PID_00011",
    Name: "Layla Ali",
    productId: null
  }
];

module.exports = labTestFakeData;
