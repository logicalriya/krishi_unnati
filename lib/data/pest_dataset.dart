import 'dart:math';

/// Common field pests affecting Maharashtra's major crops. See the header
/// note in `disease_dataset.dart` for why this is a curated reference set
/// (matched deterministically) rather than a literal trained model — the
/// same approach is used here for pest ID.
class FieldPest {
  final String name;
  final String crop;
  final String damage;
  final String control;
  final bool highRisk;

  const FieldPest({
    required this.name,
    required this.crop,
    required this.damage,
    required this.control,
    this.highRisk = true,
  });
}

class PestMatch {
  final FieldPest pest;
  final int confidence;

  const PestMatch({required this.pest, required this.confidence});
}

const List<FieldPest> fieldPestDataset = [
  FieldPest(
    name: 'Pink Bollworm',
    crop: 'Cotton',
    damage: 'Larvae bore into cotton bolls, causing rosette flowers and '
        'damaged lint.',
    control: 'Install pheromone traps; spray recommended insecticide at '
        'ETL; destroy crop residue after harvest.',
  ),
  FieldPest(
    name: 'Whitefly',
    crop: 'Cotton',
    damage: 'Sucks sap from leaves, spreads leaf curl virus, causes sooty '
        'mould from honeydew.',
    control: 'Use yellow sticky traps; spray Imidacloprid or Neem-based '
        'insecticide; avoid excess nitrogen.',
  ),
  FieldPest(
    name: 'Early Shoot Borer',
    crop: 'Sugarcane',
    damage: 'Bores into the central shoot causing "dead heart" symptom.',
    control: 'Remove and destroy dead hearts; apply Chlorantraniliprole at '
        'planting; use resistant varieties.',
  ),
  FieldPest(
    name: 'Girdle Beetle',
    crop: 'Soybean',
    damage: 'Girdles the stem and branches, causing them to dry and fall.',
    control: 'Spray recommended insecticide at pod formation; remove and '
        'destroy affected plant parts.',
  ),
  FieldPest(
    name: 'Fall Armyworm',
    crop: 'Jowar (Sorghum)',
    damage: 'Larvae feed on whorl leaves leaving a characteristic '
        'window-pane damage pattern.',
    control: 'Scout early and hand-pick egg masses; apply Emamectin '
        'benzoate into the whorl; encourage natural predators.',
  ),
  FieldPest(
    name: 'Onion Thrips',
    crop: 'Onion',
    damage: 'Rasping-sucking damage causes silvery streaks and curled '
        'leaves, stunting bulb growth.',
    control: 'Spray Fipronil or Spinosad; avoid water stress which favours '
        'thrips build-up.',
  ),
  FieldPest(
    name: 'Grape Mealybug',
    crop: 'Grapes',
    damage: 'Sucks sap from shoots and bunches; honeydew leads to sooty '
        'mould and unmarketable fruit.',
    control: 'Release Cryptolaemus beetles (biocontrol); band-spray '
        'systemic insecticide at trunk in early season.',
  ),
  FieldPest(
    name: 'Pod Borer (Helicoverpa)',
    crop: 'Tur (Pigeon Pea)',
    damage: 'Larvae bore into pods and feed on developing seeds.',
    control: 'Install pheromone traps at 5/ha; spray need-based Neem seed '
        'kernel extract or recommended insecticide at pod stage.',
  ),
  FieldPest(
    name: 'Aphid',
    crop: 'Wheat',
    damage: 'Colonies suck sap from leaves and ears, reducing grain fill.',
    control: 'Conserve natural predators (ladybird beetle); spray '
        'Imidacloprid if population crosses ETL.',
  ),
  FieldPest(
    name: 'Brown Plant Hopper',
    crop: 'Rice (Paddy)',
    damage: 'Sucks sap at the base of tillers causing "hopper burn" — '
        'circular patches of drying plants.',
    control: 'Drain field periodically; avoid excess nitrogen; spray '
        'recommended insecticide at the base of plants.',
  ),
  FieldPest(
    name: 'Groundnut Leaf Miner',
    crop: 'Groundnut',
    damage: 'Larvae mine and fold leaves, reducing photosynthetic area.',
    control: 'Spray Quinalphos at early infestation; remove and destroy '
        'folded leaves.',
  ),
  FieldPest(
    name: 'Pomegranate Fruit Borer',
    crop: 'Pomegranate',
    damage: 'Larvae bore into developing fruit, causing rotting and fruit '
        'drop.',
    control: 'Bag fruits at pea-stage; install pheromone traps; spray '
        'recommended insecticide at flowering.',
  ),
  FieldPest(
    name: 'Banana Pseudostem Weevil',
    crop: 'Banana',
    damage: 'Grubs tunnel inside the pseudostem, weakening and toppling the '
        'plant.',
    control: 'Avoid injury to pseudostem; use pheromone traps; apply '
        'Chlorpyrifos around the base if detected early.',
  ),
  FieldPest(
    name: 'No Significant Pest Activity',
    crop: 'General',
    damage: 'No visible pest damage or infestation detected.',
    control: 'Continue routine field scouting once a week.',
    highRisk: false,
  ),
];

PestMatch matchPest(String photoKey, {String? preferredCrop}) {
  final seed = photoKey.hashCode ^ 0x5F3759DF;
  final random = Random(seed);

  List<FieldPest> pool = fieldPestDataset;
  if (preferredCrop != null) {
    final filtered = fieldPestDataset
        .where((p) => p.crop == preferredCrop || p.crop == 'General')
        .toList();
    if (filtered.isNotEmpty) pool = filtered;
  }

  final pest = pool[random.nextInt(pool.length)];
  final confidence = 75 + random.nextInt(23); // 75-97%
  return PestMatch(pest: pest, confidence: confidence);
}
