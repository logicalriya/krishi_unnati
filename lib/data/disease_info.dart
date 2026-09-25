class DiseaseInfo {
  final String preventiveMeasures;
  final String chemicalTreatments;

  const DiseaseInfo({
    required this.preventiveMeasures,
    required this.chemicalTreatments,
  });
}

const Map<String, DiseaseInfo> diseaseInfoMap = {
  'Corn___Common_Rust': DiseaseInfo(
    preventiveMeasures: 'Use resistant hybrids, rotate crops, avoid dense planting.',
    chemicalTreatments: 'Apply fungicide (e.g. propiconazole) at early symptom onset.',
  ),
  'Corn___Gray_Leaf_Spot': DiseaseInfo(
    preventiveMeasures: 'Rotate crops, till residue, use resistant hybrids.',
    chemicalTreatments: 'Foliar fungicide application if disease pressure is high.',
  ),
  'Corn___Healthy': DiseaseInfo(
    preventiveMeasures: 'Maintain soil fertility and irrigation, monitor crops, use certified seeds, proper spacing.',
    chemicalTreatments: 'No chemical treatment needed for healthy crop.',
  ),
  'Corn___Northern_Leaf_Blight': DiseaseInfo(
    preventiveMeasures: 'Plant resistant hybrids, rotate crops, manage residue.',
    chemicalTreatments: 'Fungicide application recommended under high humidity.',
  ),
  'Cotton__Bacterial_Blight': DiseaseInfo(
    preventiveMeasures: 'Use disease-free seeds, avoid overhead irrigation, crop rotation.',
    chemicalTreatments: 'Copper-based bactericide spray at first symptoms.',
  ),
  'Cotton__Curl_Virus': DiseaseInfo(
    preventiveMeasures: 'Control whitefly vector, remove infected plants, use resistant varieties.',
    chemicalTreatments: 'Insecticide targeting whitefly population; no direct cure for virus.',
  ),
  'Cotton__Fussarium_Wilt': DiseaseInfo(
    preventiveMeasures: 'Crop rotation, resistant varieties, soil solarization.',
    chemicalTreatments: 'Soil fungicide drench; remove and destroy infected plants.',
  ),
  'Cotton__Healthy': DiseaseInfo(
    preventiveMeasures: 'Maintain balanced fertilization and irrigation, monitor for pests.',
    chemicalTreatments: 'No chemical treatment needed for healthy crop.',
  ),
  'Rice__Bacterial_Leaf_Blight': DiseaseInfo(
    preventiveMeasures: 'Use resistant varieties, avoid excess nitrogen, proper field drainage.',
    chemicalTreatments: 'Copper-based bactericide; avoid working in wet fields.',
  ),
  'Rice__Brown_Spot': DiseaseInfo(
    preventiveMeasures: 'Balanced fertilization, seed treatment, avoid water stress.',
    chemicalTreatments: 'Fungicide seed treatment and foliar spray if severe.',
  ),
  'Rice__Healthy': DiseaseInfo(
    preventiveMeasures: 'Ensure proper water management and nitrogen application levels.',
    chemicalTreatments: 'Preventive bio-pesticide spray recommended during high humidity.',
  ),
  'Rice__Leaf_Blast': DiseaseInfo(
    preventiveMeasures: 'Avoid excess nitrogen, use resistant varieties, proper spacing.',
    chemicalTreatments: 'Fungicide (e.g. tricyclazole) at early boot stage.',
  ),
  'Rice__Leaf_Scald': DiseaseInfo(
    preventiveMeasures: 'Balanced fertilization, avoid dense canopy, field sanitation.',
    chemicalTreatments: 'Fungicide application if lesions spread rapidly.',
  ),
  'Rice__Sheath_Blight': DiseaseInfo(
    preventiveMeasures: 'Avoid excess nitrogen, proper spacing, field drainage.',
    chemicalTreatments: 'Fungicide application at tillering to booting stage.',
  ),
  'Wheat___Brown_Rust': DiseaseInfo(
    preventiveMeasures: 'Use resistant varieties, timely sowing, monitor regularly.',
    chemicalTreatments: 'Fungicide (e.g. propiconazole) at first pustule appearance.',
  ),
  'Wheat___Healthy': DiseaseInfo(
    preventiveMeasures: 'Maintain soil fertility, proper irrigation, monitor crop regularly.',
    chemicalTreatments: 'No chemical treatment needed for healthy crop.',
  ),
  'Wheat___Yellow_Rust': DiseaseInfo(
    preventiveMeasures: 'Use resistant varieties, avoid late sowing, monitor closely in cool weather.',
    chemicalTreatments: 'Fungicide spray at early yellow pustule stage.',
  ),
};

DiseaseInfo getDiseaseInfo(String rawLabel) {
  return diseaseInfoMap[rawLabel] ??
      const DiseaseInfo(
        preventiveMeasures: 'Consult a local agricultural expert for guidance.',
        chemicalTreatments: 'Consult a local agricultural expert for guidance.',
      );
}