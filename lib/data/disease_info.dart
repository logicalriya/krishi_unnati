class DiseaseInfo {
  final String preventiveMeasures;
  final String chemicalTreatments;
  final List<String> detailedPreventiveMeasures;
  final List<String> detailedChemicalTreatments;

  const DiseaseInfo({
    required this.preventiveMeasures,
    required this.chemicalTreatments,
    required this.detailedPreventiveMeasures,
    required this.detailedChemicalTreatments,
  });
}

const Map<String, DiseaseInfo> diseaseInfoMap = {
  'Corn___Common_Rust': DiseaseInfo(
    preventiveMeasures: 'Use resistant hybrids, rotate crops, avoid dense planting.',
    chemicalTreatments: 'Apply fungicide (e.g. propiconazole) at early symptom onset.',
    detailedPreventiveMeasures: [
      'Choose rust-resistant hybrid varieties for future plantings.',
      'Rotate corn with a non-host crop (e.g. soybean) for at least one season.',
      'Space plants to improve airflow and reduce leaf wetness duration.',
      'Scout fields weekly starting mid-season, since rust spreads fast in humid weather.',
      'Remove and destroy volunteer corn plants that can carry spores between seasons.',
    ],
    detailedChemicalTreatments: [
      'At first pustule sighting, apply a triazole fungicide such as propiconazole.',
      'Repeat application every 10–14 days if humid conditions persist.',
      'Time sprays for early morning or evening to avoid leaf scorch and maximize absorption.',
      'Rotate fungicide classes across the season to reduce resistance risk.',
    ],
  ),
  'Corn___Gray_Leaf_Spot': DiseaseInfo(
    preventiveMeasures: 'Rotate crops, till residue, use resistant hybrids.',
    chemicalTreatments: 'Foliar fungicide application if disease pressure is high.',
    detailedPreventiveMeasures: [
      'Rotate away from corn for at least one year to break the disease cycle.',
      'Till or bury infected crop residue after harvest — spores overwinter in leftover debris.',
      'Plant hybrids rated for gray leaf spot resistance in high-risk fields.',
      'Avoid excessive plant density, which raises humidity within the canopy.',
    ],
    detailedChemicalTreatments: [
      'Apply a strobilurin or triazole fungicide at the first sign of lesions.',
      'Prioritize spraying if the field has a history of gray leaf spot and weather is warm and humid.',
      'A second application 2–3 weeks later may be needed under sustained disease pressure.',
    ],
  ),
  'Corn___Healthy': DiseaseInfo(
    preventiveMeasures: 'Maintain soil fertility and irrigation, monitor crops, use certified seeds, proper spacing.',
    chemicalTreatments: 'No chemical treatment needed for healthy crop.',
    detailedPreventiveMeasures: [
      'Keep up routine soil testing to maintain balanced fertility.',
      'Maintain consistent irrigation, avoiding both drought stress and waterlogging.',
      'Continue scouting weekly to catch any early disease or pest signs.',
      'Use certified disease-free seed for future plantings.',
    ],
    detailedChemicalTreatments: [
      'No treatment is necessary — the crop shows no signs of disease.',
      'Continue routine preventive practices rather than reactive spraying.',
    ],
  ),
  'Corn___Northern_Leaf_Blight': DiseaseInfo(
    preventiveMeasures: 'Plant resistant hybrids, rotate crops, manage residue.',
    chemicalTreatments: 'Fungicide application recommended under high humidity.',
    detailedPreventiveMeasures: [
      'Select hybrids with Northern Leaf Blight resistance genes where available.',
      'Rotate with non-host crops for at least one season.',
      'Manage crop residue through tillage to reduce overwintering spore load.',
      'Avoid late planting, which increases exposure during high-risk humid periods.',
    ],
    detailedChemicalTreatments: [
      'Apply fungicide at first lesion appearance, particularly during extended humid or rainy spells.',
      'A strobilurin-triazole mix is commonly effective; follow local agricultural extension guidance for product choice.',
      'Reassess 10–14 days after application and reapply if lesions continue spreading.',
    ],
  ),
  'Cotton__Bacterial_Blight': DiseaseInfo(
    preventiveMeasures: 'Use disease-free seeds, avoid overhead irrigation, crop rotation.',
    chemicalTreatments: 'Copper-based bactericide spray at first symptoms.',
    detailedPreventiveMeasures: [
      'Source certified, disease-free cottonseed for planting.',
      'Switch to drip or furrow irrigation instead of overhead watering, which spreads bacteria via splashing.',
      'Rotate with a non-host crop for at least one season to reduce soil-borne bacteria.',
      'Remove and destroy infected plant debris after harvest.',
    ],
    detailedChemicalTreatments: [
      'Apply a copper-based bactericide (e.g. copper oxychloride) at the first sign of angular leaf spots.',
      'Repeat every 7–10 days during wet weather, when bacterial spread is fastest.',
      'Avoid working in fields while foliage is wet to prevent mechanical spread.',
    ],
  ),
  'Cotton__Curl_Virus': DiseaseInfo(
    preventiveMeasures: 'Control whitefly vector, remove infected plants, use resistant varieties.',
    chemicalTreatments: 'Insecticide targeting whitefly population; no direct cure for virus.',
    detailedPreventiveMeasures: [
      'Plant CLCuV-resistant or tolerant cotton varieties where available.',
      'Rogue out and destroy infected plants early to reduce the source of infection.',
      'Avoid planting near older infected cotton fields or alternate whitefly host crops.',
      'Use yellow sticky traps to monitor whitefly populations regularly.',
    ],
    detailedChemicalTreatments: [
      'There is no chemical cure for the virus itself — treatment targets the whitefly vector.',
      'Apply a recommended insecticide (e.g. imidacloprid or thiamethoxam) when whitefly counts exceed threshold levels.',
      'Rotate insecticide classes to prevent whitefly resistance buildup.',
      'Combine chemical control with reflective mulches or intercropping to further deter whiteflies.',
    ],
  ),
  'Cotton__Fussarium_Wilt': DiseaseInfo(
    preventiveMeasures: 'Crop rotation, resistant varieties, soil solarization.',
    chemicalTreatments: 'Soil fungicide drench; remove and destroy infected plants.',
    detailedPreventiveMeasures: [
      'Rotate with non-host crops (e.g. cereals) for 2–3 years, since Fusarium persists in soil.',
      'Plant wilt-resistant cotton varieties in fields with a history of the disease.',
      'Solarize soil during the off-season using clear plastic sheeting to reduce fungal load.',
      'Avoid over-irrigation and improve field drainage, since waterlogged soil favors the fungus.',
    ],
    detailedChemicalTreatments: [
      'Apply a soil fungicide drench (e.g. carbendazim) around the root zone of affected plants.',
      'Remove and destroy wilted plants promptly to prevent further soil contamination.',
      'Treat seed with a fungicidal seed dressing before the next planting in affected fields.',
    ],
  ),
  'Cotton__Healthy': DiseaseInfo(
    preventiveMeasures: 'Maintain balanced fertilization and irrigation, monitor for pests.',
    chemicalTreatments: 'No chemical treatment needed for healthy crop.',
    detailedPreventiveMeasures: [
      'Continue balanced NPK fertilization based on periodic soil tests.',
      'Maintain consistent irrigation scheduling appropriate for the growth stage.',
      'Keep scouting for early pest or disease signs, especially whiteflies and bollworms.',
    ],
    detailedChemicalTreatments: [
      'No treatment is necessary — the crop shows no signs of disease.',
      'Continue routine preventive monitoring rather than reactive spraying.',
    ],
  ),
  'Rice__Bacterial_Leaf_Blight': DiseaseInfo(
    preventiveMeasures: 'Use resistant varieties, avoid excess nitrogen, proper field drainage.',
    chemicalTreatments: 'Copper-based bactericide; avoid working in wet fields.',
    detailedPreventiveMeasures: [
      'Plant BLB-resistant rice varieties where locally available.',
      'Avoid excess nitrogen fertilization, which makes plants more susceptible.',
      'Ensure proper field drainage — avoid standing water for extended periods.',
      'Use clean, disease-free seed and avoid clipping seedling tips before transplanting.',
    ],
    detailedChemicalTreatments: [
      'Apply a copper-based bactericide at early symptom onset (water-soaked lesions on leaf margins).',
      'Avoid entering or working in fields while foliage is wet, which spreads bacteria mechanically.',
      'Streptomycin-based sprays may be used in some regions — follow local extension advice for availability and dosage.',
    ],
  ),
  'Rice__Brown_Spot': DiseaseInfo(
    preventiveMeasures: 'Balanced fertilization, seed treatment, avoid water stress.',
    chemicalTreatments: 'Fungicide seed treatment and foliar spray if severe.',
    detailedPreventiveMeasures: [
      'Maintain balanced fertilization — brown spot is often linked to potassium or nutrient deficiency.',
      'Treat seeds with a fungicide before sowing to reduce seed-borne infection.',
      'Avoid prolonged water stress or drought conditions during the growing season.',
      'Use disease-free, certified seed where possible.',
    ],
    detailedChemicalTreatments: [
      'Apply fungicidal seed treatment (e.g. carbendazim) prior to sowing.',
      'If lesions appear on foliage, apply a foliar fungicide such as mancozeb or propiconazole.',
      'Repeat foliar spray after 10–15 days if disease pressure remains high.',
    ],
  ),
  'Rice__Healthy': DiseaseInfo(
    preventiveMeasures: 'Ensure proper water management and nitrogen application levels.',
    chemicalTreatments: 'Preventive bio-pesticide spray recommended during high humidity.',
    detailedPreventiveMeasures: [
      'Maintain consistent water levels appropriate to the crop growth stage.',
      'Apply nitrogen in split doses rather than all at once to avoid excess vegetative growth.',
      'Continue regular field scouting for early pest or disease signs.',
    ],
    detailedChemicalTreatments: [
      'No curative treatment is needed — the crop shows no signs of disease.',
      'A preventive bio-pesticide spray can be considered during extended high-humidity periods as a precaution.',
    ],
  ),
  'Rice__Leaf_Blast': DiseaseInfo(
    preventiveMeasures: 'Avoid excess nitrogen, use resistant varieties, proper spacing.',
    chemicalTreatments: 'Fungicide (e.g. tricyclazole) at early boot stage.',
    detailedPreventiveMeasures: [
      'Avoid excessive nitrogen application, which increases blast susceptibility.',
      'Plant blast-resistant rice varieties in fields with a history of the disease.',
      'Maintain proper plant spacing to reduce humidity within the canopy.',
      'Avoid water stress, since drought-stressed plants are more vulnerable.',
    ],
    detailedChemicalTreatments: [
      'Apply tricyclazole or a similar systemic fungicide at early boot stage as a preventive measure.',
      'If lesions are already visible, apply fungicide immediately and repeat after 10 days if needed.',
      'Avoid excess nitrogen top-dressing around the time of fungicide application.',
    ],
  ),
  'Rice__Leaf_Scald': DiseaseInfo(
    preventiveMeasures: 'Balanced fertilization, avoid dense canopy, field sanitation.',
    chemicalTreatments: 'Fungicide application if lesions spread rapidly.',
    detailedPreventiveMeasures: [
      'Maintain balanced fertilization, avoiding excess nitrogen.',
      'Avoid overly dense planting that raises humidity within the canopy.',
      'Practice field sanitation — remove and destroy infected residue after harvest.',
    ],
    detailedChemicalTreatments: [
      'Apply a broad-spectrum fungicide if lesions are actively spreading across leaves.',
      'Monitor closely after treatment and reapply if new lesions continue to appear within 1–2 weeks.',
    ],
  ),
  'Rice__Sheath_Blight': DiseaseInfo(
    preventiveMeasures: 'Avoid excess nitrogen, proper spacing, field drainage.',
    chemicalTreatments: 'Fungicide application at tillering to booting stage.',
    detailedPreventiveMeasures: [
      'Avoid excess nitrogen fertilization, which promotes dense canopy favorable to the fungus.',
      'Maintain proper plant spacing to improve airflow.',
      'Ensure good field drainage — standing water favors sheath blight development.',
      'Remove weeds and volunteer plants that can host the pathogen.',
    ],
    detailedChemicalTreatments: [
      'Apply a fungicide such as hexaconazole or validamycin at the tillering to booting stage.',
      'Target application to the lower canopy and sheath area, where infection starts.',
      'A repeat application may be needed if the disease persists into later growth stages.',
    ],
  ),
  'Wheat___Brown_Rust': DiseaseInfo(
    preventiveMeasures: 'Use resistant varieties, timely sowing, monitor regularly.',
    chemicalTreatments: 'Fungicide (e.g. propiconazole) at first pustule appearance.',
    detailedPreventiveMeasures: [
      'Plant brown rust-resistant wheat varieties where available.',
      'Sow at the recommended time for your region — late sowing increases rust risk.',
      'Scout fields regularly starting from tillering stage through grain filling.',
      'Avoid excess nitrogen, which can increase susceptibility to rust.',
    ],
    detailedChemicalTreatments: [
      'Apply propiconazole or a similar triazole fungicide at first pustule sighting.',
      'Repeat after 15–20 days if favorable (cool, humid) rust conditions persist.',
      'Early treatment is critical — rust can spread rapidly once established.',
    ],
  ),
  'Wheat___Healthy': DiseaseInfo(
    preventiveMeasures: 'Maintain soil fertility, proper irrigation, monitor crop regularly.',
    chemicalTreatments: 'No chemical treatment needed for healthy crop.',
    detailedPreventiveMeasures: [
      'Continue balanced fertilization based on soil test recommendations.',
      'Maintain consistent irrigation appropriate to the current growth stage.',
      'Keep scouting regularly for early signs of rust or other diseases.',
    ],
    detailedChemicalTreatments: [
      'No treatment is necessary — the crop shows no signs of disease.',
      'Continue routine preventive monitoring rather than reactive spraying.',
    ],
  ),
  'Wheat___Yellow_Rust': DiseaseInfo(
    preventiveMeasures: 'Use resistant varieties, avoid late sowing, monitor closely in cool weather.',
    chemicalTreatments: 'Fungicide spray at early yellow pustule stage.',
    detailedPreventiveMeasures: [
      'Plant yellow rust-resistant wheat varieties, especially in cooler, humid regions.',
      'Avoid late sowing, which increases exposure to favorable rust conditions.',
      'Monitor fields closely during cool, moist weather when yellow rust spreads fastest.',
      'Avoid excess nitrogen application, which can increase susceptibility.',
    ],
    detailedChemicalTreatments: [
      'Apply a triazole fungicide at the first sign of yellow-striped pustules.',
      'Treat early — yellow rust can spread across a field within days under favorable conditions.',
      'Reassess after 10–14 days and reapply if new pustules continue to appear.',
    ],
  ),
};

DiseaseInfo getDiseaseInfo(String rawLabel) {
  return diseaseInfoMap[rawLabel] ??
      const DiseaseInfo(
        preventiveMeasures: 'Consult a local agricultural expert for guidance.',
        chemicalTreatments: 'Consult a local agricultural expert for guidance.',
        detailedPreventiveMeasures: [
          'This disease is not yet in our local guidance database.',
          'Consult a local agricultural expert or extension office for tailored advice.',
        ],
        detailedChemicalTreatments: [
          'This disease is not yet in our local guidance database.',
          'Consult a local agricultural expert or extension office before applying any treatment.',
        ],
      );
}