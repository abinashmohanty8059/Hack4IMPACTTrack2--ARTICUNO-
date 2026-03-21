// symptom_checker_model.dart
// Hardcoded offline symptom → disease prediction model for ARTICUNO.
//
// MODEL DESIGN:
//   - 45 symptoms defined with display labels and category groups.
//   - 22 diseases, each with a required set of "key symptoms" and an
//     "also seen" supplementary set.
//   - Scoring: for a user's selected symptom set S and disease D:
//       keyScore = |S ∩ D.keySymptoms| / |D.keySymptoms|
//       bonusScore = |S ∩ D.alsoSymptoms| * 0.1
//       finalScore = keyScore + bonusScore
//   - Results are sorted descending by finalScore.
//   - Only diseases with at least 1 key symptom matched are returned.
//   - Top 3 results shown. If no match, "not enough data" message returned.
//
// COMBINATION REFERENCE (bottom of file) lists which typical combinations
// map to which disease — useful for demo/testing.

// ─── Symptom definition ───────────────────────────────────────────────────

class Symptom {
  final String id;
  final String label;
  final String category; // fever | respiratory | gut | skin | neuro | general | cardio

  const Symptom({
    required this.id,
    required this.label,
    required this.category,
  });
}

const List<Symptom> allSymptoms = [
  // ── Fever / Temperature ──────────────────────────────────────────────
  Symptom(id: 'fever',         label: '🌡 Fever',              category: 'fever'),
  Symptom(id: 'high_fever',    label: '🌡 High Fever (>102°F)',category: 'fever'),
  Symptom(id: 'chills',        label: '🥶 Chills & Shivering', category: 'fever'),
  Symptom(id: 'night_sweats',  label: '💦 Night Sweats',       category: 'fever'),

  // ── Respiratory / Throat ─────────────────────────────────────────────
  Symptom(id: 'cough',              label: '😮‍💨 Cough',                    category: 'respiratory'),
  Symptom(id: 'dry_cough',          label: '🫁 Dry Cough',                  category: 'respiratory'),
  Symptom(id: 'cough_blood',        label: '🩸 Coughing Blood',             category: 'respiratory'),
  Symptom(id: 'sore_throat',        label: '😖 Sore Throat',               category: 'respiratory'),
  Symptom(id: 'runny_nose',         label: '🤧 Runny / Stuffy Nose',        category: 'respiratory'),
  Symptom(id: 'shortness_breath',   label: '😮 Shortness of Breath',        category: 'respiratory'),
  Symptom(id: 'chest_pain',         label: '💔 Chest Pain',                 category: 'respiratory'),
  Symptom(id: 'wheezing',           label: '🌬 Wheezing',                   category: 'respiratory'),

  // ── Gut / Digestive ──────────────────────────────────────────────────
  Symptom(id: 'nausea',          label: '🤢 Nausea',               category: 'gut'),
  Symptom(id: 'vomiting',        label: '🤮 Vomiting',             category: 'gut'),
  Symptom(id: 'diarrhea',        label: '🚽 Diarrhea',             category: 'gut'),
  Symptom(id: 'watery_stool',    label: '💧 Watery Stools',        category: 'gut'),
  Symptom(id: 'blood_stool',     label: '🩸 Blood in Stool',       category: 'gut'),
  Symptom(id: 'abdominal_pain',  label: '😣 Abdominal Pain',       category: 'gut'),
  Symptom(id: 'loss_appetite',   label: '🍽 Loss of Appetite',     category: 'gut'),
  Symptom(id: 'constipation',    label: '🚫 Constipation',         category: 'gut'),

  // ── Skin ─────────────────────────────────────────────────────────────
  Symptom(id: 'rash',            label: '🔴 Skin Rash',            category: 'skin'),
  Symptom(id: 'itching',         label: '😩 Itching',              category: 'skin'),
  Symptom(id: 'blisters',        label: '🫧 Blisters on Skin',     category: 'skin'),
  Symptom(id: 'yellow_skin',     label: '🟡 Yellowing of Skin',    category: 'skin'),
  Symptom(id: 'yellow_eyes',     label: '👁 Yellow Eyes',          category: 'skin'),
  Symptom(id: 'pale_skin',       label: '⬜ Pale / White Skin',    category: 'skin'),

  // ── Eyes / ENT ───────────────────────────────────────────────────────
  Symptom(id: 'red_eyes',        label: '👁 Red / Pink Eyes',      category: 'ent'),
  Symptom(id: 'eye_discharge',   label: '💧 Eye Discharge',        category: 'ent'),
  Symptom(id: 'light_sensitive', label: '🔆 Sensitivity to Light', category: 'ent'),
  Symptom(id: 'loss_smell',      label: '👃 Loss of Smell',        category: 'ent'),
  Symptom(id: 'loss_taste',      label: '👅 Loss of Taste',        category: 'ent'),

  // ── Neuro / Head ─────────────────────────────────────────────────────
  Symptom(id: 'headache',        label: '🤕 Headache',             category: 'neuro'),
  Symptom(id: 'severe_headache', label: '⚡ Severe Headache',      category: 'neuro'),
  Symptom(id: 'dizziness',       label: '💫 Dizziness',            category: 'neuro'),
  Symptom(id: 'confusion',       label: '🌀 Confusion',            category: 'neuro'),
  Symptom(id: 'stiff_neck',      label: '🦴 Stiff Neck',          category: 'neuro'),
  Symptom(id: 'seizures',        label: '⚡ Seizures',             category: 'neuro'),

  // ── General / Body ───────────────────────────────────────────────────
  Symptom(id: 'fatigue',         label: '😴 Fatigue / Weakness',   category: 'general'),
  Symptom(id: 'body_aches',      label: '🦴 Body Aches',           category: 'general'),
  Symptom(id: 'joint_pain',      label: '🦵 Joint Pain',           category: 'general'),
  Symptom(id: 'weight_loss',     label: '⚖ Unexplained Weight Loss',category: 'general'),
  Symptom(id: 'dark_urine',      label: '🫙 Dark Urine',           category: 'general'),
  Symptom(id: 'swollen_lymph',   label: '🔵 Swollen Lymph Nodes',  category: 'general'),

  // ── Cardio / Metabolic ───────────────────────────────────────────────
  Symptom(id: 'palpitations',        label: '💓 Palpitations',           category: 'cardio'),
  Symptom(id: 'high_bp',             label: '📈 High Blood Pressure',    category: 'cardio'),
  Symptom(id: 'frequent_urination',  label: '🚿 Frequent Urination',     category: 'cardio'),
  Symptom(id: 'excessive_thirst',    label: '🥤 Excessive Thirst',       category: 'cardio'),
  Symptom(id: 'cold_extremities',    label: '🧊 Cold Hands & Feet',      category: 'cardio'),
  Symptom(id: 'blurred_vision',      label: '👓 Blurred Vision',         category: 'cardio'),
];

// ─── Disease model ────────────────────────────────────────────────────────

class DiseaseResult {
  final String name;
  final List<String> keySymptoms;   // must-have symptoms (high weight)
  final List<String> alsoSymptoms;  // bonus symptoms
  final String shortDescription;
  final String confidence;          // "High" | "Medium" | "Low"

  const DiseaseResult({
    required this.name,
    required this.keySymptoms,
    required this.alsoSymptoms,
    required this.shortDescription,
    required this.confidence,
  });
}

const List<DiseaseResult> _diseaseModels = [
  DiseaseResult(
    name: 'Malaria',
    keySymptoms: ['high_fever', 'chills', 'headache', 'fatigue'],
    alsoSymptoms: ['nausea', 'vomiting', 'body_aches', 'joint_pain', 'night_sweats'],
    shortDescription: 'Caused by Plasmodium parasite via mosquito bite. Cyclical fever with chills is the hallmark.',
    confidence: 'High',
  ),
  DiseaseResult(
    name: 'Dengue Fever',
    keySymptoms: ['high_fever', 'severe_headache', 'joint_pain', 'rash'],
    alsoSymptoms: ['body_aches', 'nausea', 'vomiting', 'fatigue', 'eye_discharge'],
    shortDescription: 'Viral infection spread by Aedes mosquito. Known as "breakbone fever" due to intense muscle/joint pain.',
    confidence: 'High',
  ),
  DiseaseResult(
    name: 'Typhoid',
    keySymptoms: ['high_fever', 'abdominal_pain', 'constipation', 'fatigue'],
    alsoSymptoms: ['headache', 'loss_appetite', 'nausea', 'rash', 'body_aches'],
    shortDescription: 'Bacterial infection (Salmonella typhi) via contaminated food or water. Sustained fever without chills.',
    confidence: 'High',
  ),
  DiseaseResult(
    name: 'COVID-19',
    keySymptoms: ['fever', 'dry_cough', 'loss_smell', 'loss_taste'],
    alsoSymptoms: ['fatigue', 'body_aches', 'sore_throat', 'shortness_breath', 'headache', 'runny_nose'],
    shortDescription: 'SARS-CoV-2 viral infection. Loss of smell/taste is a strong indicator.',
    confidence: 'High',
  ),
  DiseaseResult(
    name: 'Tuberculosis (TB)',
    keySymptoms: ['cough_blood', 'night_sweats', 'weight_loss', 'cough'],
    alsoSymptoms: ['fatigue', 'fever', 'chest_pain', 'shortness_breath', 'loss_appetite'],
    shortDescription: 'Bacterial lung disease (Mycobacterium tuberculosis). Persistent cough >3 weeks with night sweats and weight loss.',
    confidence: 'High',
  ),
  DiseaseResult(
    name: 'Pneumonia',
    keySymptoms: ['chest_pain', 'shortness_breath', 'cough', 'high_fever'],
    alsoSymptoms: ['fatigue', 'chills', 'nausea', 'vomiting', 'confusion'],
    shortDescription: 'Lung infection (bacterial/viral). Productive cough, chest pain, and breathing difficulty.',
    confidence: 'High',
  ),
  DiseaseResult(
    name: 'Influenza (Flu)',
    keySymptoms: ['fever', 'body_aches', 'fatigue', 'dry_cough'],
    alsoSymptoms: ['sore_throat', 'runny_nose', 'headache', 'chills', 'nausea'],
    shortDescription: 'Seasonal influenza virus. Sudden onset with intense body aches and fever distinguishes it from common cold.',
    confidence: 'High',
  ),
  DiseaseResult(
    name: 'Cholera',
    keySymptoms: ['watery_stool', 'vomiting', 'diarrhea'],
    alsoSymptoms: ['nausea', 'abdominal_pain', 'fatigue', 'pale_skin'],
    shortDescription: 'Bacterial infection via contaminated water. Profuse rice-water stools causing rapid dehydration.',
    confidence: 'High',
  ),
  DiseaseResult(
    name: 'Chickenpox',
    keySymptoms: ['blisters', 'itching', 'rash', 'fever'],
    alsoSymptoms: ['fatigue', 'loss_appetite', 'headache'],
    shortDescription: 'Varicella-zoster virus. Itchy blister-rash spreading across body, starting from trunk to face and limbs.',
    confidence: 'High',
  ),
  DiseaseResult(
    name: 'Jaundice / Hepatitis',
    keySymptoms: ['yellow_skin', 'yellow_eyes', 'dark_urine'],
    alsoSymptoms: ['fatigue', 'abdominal_pain', 'nausea', 'loss_appetite', 'itching'],
    shortDescription: 'Liver dysfunction causing bilirubin buildup. Yellowing of eyes/skin (jaundice) is the defining sign.',
    confidence: 'High',
  ),
  DiseaseResult(
    name: 'Diarrhea / Gastroenteritis',
    keySymptoms: ['diarrhea', 'abdominal_pain', 'nausea'],
    alsoSymptoms: ['vomiting', 'fever', 'fatigue', 'blood_stool'],
    shortDescription: 'Gut infection from contaminated food or water. ORS is the first line of treatment.',
    confidence: 'Medium',
  ),
  DiseaseResult(
    name: 'Food Poisoning',
    keySymptoms: ['vomiting', 'nausea', 'abdominal_pain', 'diarrhea'],
    alsoSymptoms: ['fever', 'headache', 'fatigue', 'blood_stool'],
    shortDescription: 'Toxin ingestion from contaminated food. Symptoms begin rapidly (1–6 hours after eating).',
    confidence: 'Medium',
  ),
  DiseaseResult(
    name: 'Asthma',
    keySymptoms: ['wheezing', 'shortness_breath', 'chest_pain'],
    alsoSymptoms: ['cough', 'dry_cough', 'fatigue'],
    shortDescription: 'Chronic airways inflammation. Wheezing and shortness of breath triggered by allergens or exercise.',
    confidence: 'High',
  ),
  DiseaseResult(
    name: 'Diabetes',
    keySymptoms: ['frequent_urination', 'excessive_thirst', 'blurred_vision'],
    alsoSymptoms: ['fatigue', 'weight_loss', 'pale_skin', 'cold_extremities'],
    shortDescription: 'Metabolic disorder with elevated blood glucose. Polyuria (frequent urination) and polydipsia (excessive thirst) are classic signs.',
    confidence: 'High',
  ),
  DiseaseResult(
    name: 'Hypertension (High BP)',
    keySymptoms: ['high_bp', 'severe_headache', 'dizziness'],
    alsoSymptoms: ['chest_pain', 'palpitations', 'blurred_vision', 'nausea'],
    shortDescription: 'Persistently elevated blood pressure. Often symptomless but can present with pounding headache and dizziness.',
    confidence: 'High',
  ),
  DiseaseResult(
    name: 'Anemia',
    keySymptoms: ['pale_skin', 'fatigue', 'cold_extremities'],
    alsoSymptoms: ['dizziness', 'shortness_breath', 'palpitations', 'blurred_vision'],
    shortDescription: 'Low hemoglobin / red blood cell count. Extreme tiredness with pale appearance is the hallmark.',
    confidence: 'Medium',
  ),
  DiseaseResult(
    name: 'Measles',
    keySymptoms: ['rash', 'fever', 'red_eyes', 'runny_nose'],
    alsoSymptoms: ['cough', 'light_sensitive', 'fatigue', 'loss_appetite'],
    shortDescription: 'Viral infection (Morbillivirus). Koplik spots inside mouth followed by spreading red-brown rash.',
    confidence: 'High',
  ),
  DiseaseResult(
    name: 'Conjunctivitis (Pink Eye)',
    keySymptoms: ['red_eyes', 'eye_discharge', 'itching'],
    alsoSymptoms: ['light_sensitive', 'fever', 'swollen_lymph'],
    shortDescription: 'Inflammation of the conjunctiva. Highly contagious bacterial/viral infection of the eye.',
    confidence: 'High',
  ),
  DiseaseResult(
    name: 'Scabies',
    keySymptoms: ['itching', 'rash', 'blisters'],
    alsoSymptoms: ['fatigue'],
    shortDescription: 'Skin mite (Sarcoptes scabiei) infestation. Intense itching worsening at night with burrowing tracks on skin.',
    confidence: 'Medium',
  ),
  DiseaseResult(
    name: 'Heat Stroke',
    keySymptoms: ['high_fever', 'confusion', 'dizziness'],
    alsoSymptoms: ['nausea', 'headache', 'fatigue', 'palpitations'],
    shortDescription: 'Medical emergency from extreme heat. Body temperature above 104°F with altered consciousness requires immediate cooling.',
    confidence: 'High',
  ),
  DiseaseResult(
    name: 'Migraine',
    keySymptoms: ['severe_headache', 'nausea', 'light_sensitive'],
    alsoSymptoms: ['vomiting', 'dizziness', 'blurred_vision', 'fatigue'],
    shortDescription: 'Neurological condition causing intense one-sided throbbing headache with light/sound sensitivity.',
    confidence: 'High',
  ),
  DiseaseResult(
    name: 'Malnutrition',
    keySymptoms: ['weight_loss', 'fatigue', 'pale_skin'],
    alsoSymptoms: ['dizziness', 'cold_extremities', 'swollen_lymph', 'loss_appetite'],
    shortDescription: 'Severe nutrient deficiency. Common in rural children — look for low weight-for-age and listlessness.',
    confidence: 'Medium',
  ),
];

// ─── Prediction engine ────────────────────────────────────────────────────

class SymptomPrediction {
  final String diseaseName;
  final String description;
  final double score;         // 0.0 – 1.0+
  final String matchLabel;    // "3 / 4 key symptoms matched"
  final List<String> matchedSymptoms;

  const SymptomPrediction({
    required this.diseaseName,
    required this.description,
    required this.score,
    required this.matchLabel,
    required this.matchedSymptoms,
  });
}

/// Runs the prediction model on a set of selected symptom IDs.
/// Returns top-3 matching diseases sorted by score (descending).
/// Returns empty list if zero key-symptoms matched for all diseases.
List<SymptomPrediction> predictDiseases(Set<String> selectedIds) {
  final results = <SymptomPrediction>[];

  for (final disease in _diseaseModels) {
    final matchedKey = disease.keySymptoms
        .where((s) => selectedIds.contains(s))
        .toList();
    final matchedBonus = disease.alsoSymptoms
        .where((s) => selectedIds.contains(s))
        .toList();

    if (matchedKey.isEmpty) continue; // Must match at least 1 key symptom

    final keyScore =
        matchedKey.length / disease.keySymptoms.length;
    final bonusScore = matchedBonus.length * 0.1;
    final finalScore = (keyScore + bonusScore).clamp(0.0, 1.5);

    results.add(SymptomPrediction(
      diseaseName: disease.name,
      description: disease.shortDescription,
      score: finalScore,
      matchLabel:
          '${matchedKey.length} / ${disease.keySymptoms.length} key symptoms matched',
      matchedSymptoms: [...matchedKey, ...matchedBonus],
    ));
  }

  results.sort((a, b) => b.score.compareTo(a.score));
  return results.take(3).toList();
}

/// Formats the prediction result into a chat message string.
String formatPredictionResponse(
    Set<String> selectedIds, List<SymptomPrediction> predictions) {
  // Get display labels for selected symptoms
  final selectedLabels = allSymptoms
      .where((s) => selectedIds.contains(s.id))
      .map((s) => s.label)
      .toList();

  final buf = StringBuffer();
  buf.writeln('Symptom Analysis Complete');
  buf.writeln('');
  buf.writeln('Selected symptoms: ${selectedLabels.join(', ')}');
  buf.writeln('');

  if (predictions.isEmpty) {
    buf.writeln('No clear disease match found for this symptom combination.');
    buf.writeln('Please select more symptoms or type your query in the chat.');
    buf.writeln('');
    buf.writeln('Note: This is an offline screening tool only.');
    buf.writeln('Always consult a qualified doctor for diagnosis.');
    return buf.toString().trim();
  }

  buf.writeln('Possible conditions (ranked by likelihood):');
  buf.writeln('');

  for (int i = 0; i < predictions.length; i++) {
    final p = predictions[i];
    final rank = ['1st', '2nd', '3rd'][i];
    final pct = ((p.score / 1.5) * 100).clamp(0, 99).round();
    buf.writeln('$rank Match: ${p.diseaseName} (~$pct% likelihood)');
    buf.writeln(p.matchLabel);
    buf.writeln(p.description);
    buf.writeln('');
  }

  buf.writeln('Important: This is an AI-based offline screening only.');
  buf.writeln(
      'Do not self-medicate. Visit your nearest PHC or doctor for a confirmed diagnosis.');
  return buf.toString().trim();
}

// ─── COMBINATION REFERENCE ────────────────────────────────────────────────
// The table below documents which symptom combinations map to which disease.
// This is useful for demo, testing, and the hackathon presentation.
//
// Disease              | Key Symptoms to Select
// ---------------------|-------------------------------------------------------
// Malaria              | High Fever + Chills + Headache + Fatigue
// Dengue               | High Fever + Severe Headache + Joint Pain + Skin Rash
// Typhoid              | High Fever + Abdominal Pain + Constipation + Fatigue
// COVID-19             | Fever + Dry Cough + Loss of Smell + Loss of Taste
// Tuberculosis         | Coughing Blood + Night Sweats + Weight Loss + Cough
// Pneumonia            | Chest Pain + Shortness of Breath + Cough + High Fever
// Influenza            | Fever + Body Aches + Fatigue + Dry Cough
// Cholera              | Watery Stools + Vomiting + Diarrhea
// Chickenpox           | Blisters + Itching + Skin Rash + Fever
// Jaundice/Hepatitis   | Yellow Skin + Yellow Eyes + Dark Urine
// Diarrhea/Gastro      | Diarrhea + Abdominal Pain + Nausea
// Food Poisoning       | Vomiting + Nausea + Abdominal Pain + Diarrhea
// Asthma               | Wheezing + Shortness of Breath + Chest Pain
// Diabetes             | Frequent Urination + Excessive Thirst + Blurred Vision
// Hypertension         | High BP + Severe Headache + Dizziness
// Anemia               | Pale Skin + Fatigue + Cold Hands & Feet
// Measles              | Skin Rash + Fever + Red Eyes + Runny Nose
// Conjunctivitis       | Red Eyes + Eye Discharge + Itching
// Scabies              | Itching + Skin Rash + Blisters
// Heat Stroke          | High Fever + Confusion + Dizziness
// Migraine             | Severe Headache + Nausea + Sensitivity to Light
// Malnutrition         | Weight Loss + Fatigue + Pale Skin
