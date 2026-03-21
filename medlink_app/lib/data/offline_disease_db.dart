// offline_disease_db.dart
// Hardcoded offline disease database for ARTICUNO health assistant.
// Contains 20+ popular diseases with symptoms, precautions, and 24hr advice.
// Supports fuzzy/misspelling-tolerant keyword matching.

class DiseaseInfo {
  final String name;
  final List<String> symptoms;
  final List<String> precautions;
  final List<String> next24Hours;
  final List<String> keywords; // keywords & common misspellings to match

  const DiseaseInfo({
    required this.name,
    required this.symptoms,
    required this.precautions,
    required this.next24Hours,
    required this.keywords,
  });
}

// ─── Helper: fuzzy keyword match ───────────────────────────────────────────
// Returns true if the user query contains at least one keyword (case-insensitive).
// Also checks if the query shares enough letters with any keyword (≥70% overlap
// for longer words) to handle mild misspellings.
bool _queryMatchesKeywords(String query, List<String> keywords) {
  final q = query.toLowerCase();

  for (final kw in keywords) {
    final k = kw.toLowerCase();

    // Direct substring match
    if (q.contains(k)) return true;

    // Word-level fuzzy: check each word in query
    for (final word in q.split(RegExp(r'\s+'))) {
      if (word.length < 3) continue;
      if (_levenshtein(word, k) <= _tolerance(k)) return true;
    }
  }
  return false;
}

// Tolerance: 1 for short words (≤5 chars), 2 for longer ones
int _tolerance(String s) => s.length <= 5 ? 1 : 2;

// Simple Levenshtein distance
int _levenshtein(String a, String b) {
  if (a == b) return 0;
  if (a.isEmpty) return b.length;
  if (b.isEmpty) return a.length;

  List<int> prev = List.generate(b.length + 1, (i) => i);
  for (int i = 0; i < a.length; i++) {
    List<int> curr = [i + 1];
    for (int j = 0; j < b.length; j++) {
      int cost = a[i] == b[j] ? 0 : 1;
      curr.add([curr[j] + 1, prev[j + 1] + 1, prev[j] + cost]
          .reduce((x, y) => x < y ? x : y));
    }
    prev = curr;
  }
  return prev[b.length];
}

// ─── Disease Database ───────────────────────────────────────────────────────
const List<DiseaseInfo> offlineDiseaseDatabase = [
  // 1. Malaria
  DiseaseInfo(
    name: "Malaria",
    keywords: [
      "malaria", "malarya", "maleria", "malerial", "malara",
      "plasmodium", "dengue-like", "chills fever", "shivering fever"
    ],
    symptoms: [
      "High fever with chills and shivering",
      "Severe headache",
      "Nausea and vomiting",
      "Muscle and joint pain",
      "Fatigue and weakness",
      "Sweating after fever breaks",
      "Cyclical fever every 48–72 hours",
    ],
    precautions: [
      "Use mosquito nets while sleeping",
      "Apply insect repellent on exposed skin",
      "Wear long-sleeved clothing in the evening",
      "Eliminate stagnant water near your home",
      "Take prescribed antimalarial medicines if in high-risk area",
    ],
    next24Hours: [
      "Drink plenty of fluids to stay hydrated",
      "Take paracetamol (Crocin/Dolo) for fever relief",
      "Do NOT self-medicate with chloroquine without a doctor",
      "Visit a healthcare center for a rapid malaria test",
      "Rest completely and avoid physical exertion",
      "Monitor temperature every 4 hours",
    ],
  ),

  // 2. Dengue
  DiseaseInfo(
    name: "Dengue Fever",
    keywords: [
      "dengue", "dangu", "dengu", "dengue fever", "breakbone", "bone break fever",
      "dengoo", "platelet", "low platelet", "rash fever"
    ],
    symptoms: [
      "Sudden high fever (104°F / 40°C)",
      "Severe headache behind the eyes",
      "Muscle and joint pain (breakbone fever)",
      "Skin rash appearing 2–5 days after fever",
      "Nausea and vomiting",
      "Mild bleeding (nose, gums)",
      "Fatigue and weakness",
    ],
    precautions: [
      "Prevent mosquito bites (Aedes mosquito bites during daytime)",
      "Use mosquito repellent and nets",
      "Wear full-sleeved clothing",
      "Do not store water in open containers",
      "Report dengue cases to local health authorities",
    ],
    next24Hours: [
      "Visit a doctor immediately for blood test (platelet count)",
      "Drink ORS, coconut water, and fruit juices",
      "Take only paracetamol for fever — AVOID aspirin and ibuprofen",
      "Do NOT ignore bleeding symptoms — rush to hospital",
      "Rest completely",
      "Monitor platelet count every 12 hours if advised",
    ],
  ),

  // 3. Typhoid
  DiseaseInfo(
    name: "Typhoid",
    keywords: [
      "typhoid", "tyfoid", "typhiod", "typhoid fever", "typoid",
      "salmonella", "enteric fever", "entryc fever", "continuous fever"
    ],
    symptoms: [
      "Prolonged continuous high fever (up to 104°F)",
      "Weakness and fatigue",
      "Stomach pain and abdominal discomfort",
      "Headache",
      "Loss of appetite",
      "Constipation or diarrhea",
      "Rose-colored spots on chest (in some cases)",
    ],
    precautions: [
      "Drink only boiled or purified water",
      "Eat freshly cooked food — avoid street food",
      "Wash hands thoroughly before eating",
      "Get the typhoid vaccine if available",
      "Use proper sanitation facilities",
    ],
    next24Hours: [
      "Get a Widal test or blood culture done ASAP",
      "Start antibiotics only as prescribed by a doctor",
      "Eat light, easy-to-digest food (khichdi, curd, soup)",
      "Drink at least 8–10 glasses of water or ORS",
      "Strict bed rest is essential",
      "Do not share utensils — maintain hygiene",
    ],
  ),

  // 4. Tuberculosis (TB)
  DiseaseInfo(
    name: "Tuberculosis (TB)",
    keywords: [
      "tuberculosis", "tb", "t.b", "tuberclosis", "tubercolosis",
      "tubercosis", "tubrculosis", "cough blood", "blood cough",
      "chronic cough", "night sweat"
    ],
    symptoms: [
      "Persistent cough lasting more than 3 weeks",
      "Coughing up blood or mucus",
      "Chest pain while breathing or coughing",
      "Night sweats",
      "Unexplained weight loss",
      "Fatigue and weakness",
      "Fever (usually low-grade in evening)",
    ],
    precautions: [
      "Cover mouth while coughing or sneezing",
      "Complete the full course of TB medication (6–9 months)",
      "Ensure proper ventilation at home",
      "Avoid close contact with TB patients",
      "Get BCG vaccination for children",
    ],
    next24Hours: [
      "See a doctor for sputum test and chest X-ray",
      "Do not stop TB medicine mid-course — very dangerous",
      "Isolate from family members temporarily if diagnosed",
      "Eat a protein-rich diet to strengthen immunity",
      "Avoid smoking and alcohol",
      "Register at DOTS center (free TB treatment in India)",
    ],
  ),

  // 5. COVID-19
  DiseaseInfo(
    name: "COVID-19",
    keywords: [
      "covid", "corona", "coronavirus", "covid19", "covid-19",
      "covd", "corana", "corono", "loss of smell", "loss of taste",
      "sars-cov", "covidcough"
    ],
    symptoms: [
      "Fever or chills",
      "Dry cough",
      "Shortness of breath or difficulty breathing",
      "Loss of taste or smell",
      "Fatigue",
      "Body aches and muscle pain",
      "Sore throat",
      "Headache",
      "Runny or congested nose",
    ],
    precautions: [
      "Wear a mask in crowded places",
      "Maintain 6 feet distance from others",
      "Wash hands frequently with soap for 20 seconds",
      "Get vaccinated (all doses + booster)",
      "Avoid touching face, eyes, nose, and mouth",
    ],
    next24Hours: [
      "Isolate yourself immediately",
      "Take a COVID antigen rapid test",
      "Monitor oxygen levels (SpO2 should be above 94%)",
      "Stay well hydrated and rest",
      "Take paracetamol for fever and body aches",
      "Call emergency if breathing difficulty occurs",
    ],
  ),

  // 6. Cholera
  DiseaseInfo(
    name: "Cholera",
    keywords: [
      "cholera", "colera", "cholra", "choleraa", "rice water stool",
      "severe diarrhea", "watery stool", "dehydration stool"
    ],
    symptoms: [
      "Sudden onset of profuse, watery diarrhea (rice-water stools)",
      "Nausea and vomiting",
      "Severe dehydration (dry mouth, sunken eyes)",
      "Muscle cramps (especially leg cramps)",
      "Rapid heart rate",
      "Low blood pressure",
    ],
    precautions: [
      "Drink only safe (boiled/treated) water",
      "Wash hands with soap after using the toilet",
      "Eat only freshly cooked hot food",
      "Avoid eating raw vegetables or fruits washed in local water",
      "Get cholera vaccine if available",
    ],
    next24Hours: [
      "URGENT: Rush to hospital — cholera is life-threatening",
      "Start ORS immediately — every 15 minutes",
      "IV fluids may be needed at a health center",
      "Do not eat solid food until vomiting stops",
      "Disinfect surroundings — cholera spreads in water",
      "Boil all drinking and cooking water",
    ],
  ),

  // 7. Pneumonia
  DiseaseInfo(
    name: "Pneumonia",
    keywords: [
      "pneumonia", "pnemonia", "neumonia", "pneumoni", "pneomonia",
      "lung infection", "chest infection", "lungs pain breathing"
    ],
    symptoms: [
      "Chest pain when breathing or coughing",
      "Cough with phlegm (green, yellow, or blood-tinged)",
      "Fever, sweating, and chills",
      "Shortness of breath",
      "Fatigue",
      "Confusion (in elderly patients)",
      "Nausea or vomiting",
    ],
    precautions: [
      "Get pneumonia and flu vaccines",
      "Don't smoke — damages lung defense",
      "Wash hands frequently",
      "Avoid contact with sick people",
      "Complete prescribed antibiotics fully",
    ],
    next24Hours: [
      "See a doctor today for chest X-ray and blood tests",
      "Take prescribed antibiotics on time",
      "Rest in a semi-upright position to breathe easier",
      "Drink warm fluids (water, soups, herbal tea)",
      "Use a steam inhaler to ease breathing",
      "Go to emergency if lips turn blue or breathing is very difficult",
    ],
  ),

  // 8. Diabetes
  DiseaseInfo(
    name: "Diabetes",
    keywords: [
      "diabetes", "diabtes", "diabeties", "diabetic", "daibetes",
      "sugar disease", "high sugar", "blood sugar", "insulin",
      "frequent urination thirst"
    ],
    symptoms: [
      "Frequent urination",
      "Excessive thirst",
      "Unexplained weight loss",
      "Increased hunger",
      "Blurred vision",
      "Slow-healing wounds or cuts",
      "Fatigue",
      "Tingling or numbness in hands and feet",
    ],
    precautions: [
      "Maintain a healthy, low-sugar and low-carb diet",
      "Exercise regularly (at least 30 mins/day)",
      "Check blood sugar levels regularly",
      "Take prescribed medication or insulin on time",
      "Avoid smoking and alcohol",
    ],
    next24Hours: [
      "Check blood sugar level immediately",
      "If level is very high (>300), go to a doctor",
      "Drink water — avoid sugary drinks",
      "Take your prescribed medication on schedule",
      "Eat small, balanced meals at regular intervals",
      "Check your feet for any wounds or infections",
    ],
  ),

  // 9. Hypertension (High Blood Pressure)
  DiseaseInfo(
    name: "Hypertension (High BP)",
    keywords: [
      "hypertension", "high blood pressure", "high bp", "hpertension",
      "hypertansion", "bp high", "blood pressure high", "hypertenshion",
      "headache bp", "pounding headache"
    ],
    symptoms: [
      "Severe headache (often at back of head)",
      "Nosebleeds",
      "Shortness of breath",
      "Chest pain",
      "Dizziness",
      "Blurred vision",
      "Pounding sensation in chest or neck",
    ],
    precautions: [
      "Reduce salt intake to less than 5g per day",
      "Exercise regularly",
      "Maintain a healthy body weight",
      "Avoid smoking and limit alcohol",
      "Manage stress through meditation or yoga",
    ],
    next24Hours: [
      "Check BP reading immediately",
      "If BP is above 180/120 — visit emergency NOW",
      "Take prescribed BP medicines without skipping",
      "Avoid caffeine, salty snacks, and stress",
      "Lie down and rest in a calm environment",
      "Breathe slowly and deeply to help reduce BP",
    ],
  ),

  // 10. Chickenpox
  DiseaseInfo(
    name: "Chickenpox",
    keywords: [
      "chickenpox", "chicken pox", "chicenpox", "cickenpox", "varicella",
      "pox", "itchy blisters", "itchy rash blister", "pox rash"
    ],
    symptoms: [
      "Itchy, blister-like rash starting on chest/back/face",
      "Fever",
      "Fatigue and loss of appetite",
      "Headache",
      "Rash spreading across the whole body",
      "Blisters that break and crust over",
    ],
    precautions: [
      "Isolate the patient to prevent spread",
      "Do not scratch blisters — causes scarring and infection",
      "Get the varicella vaccine",
      "Keep fingernails short and clean",
      "Use calamine lotion to soothe the itch",
    ],
    next24Hours: [
      "Apply calamine lotion on blisters for relief",
      "Take antihistamines (like Cetirizine) for itching",
      "Give paracetamol for fever — AVOID aspirin in children",
      "Luke-warm oatmeal baths can soothe itching",
      "Keep the patient isolated from others",
      "See a doctor if fever is very high or blisters get infected",
    ],
  ),

  // 11. Diarrhea
  DiseaseInfo(
    name: "Diarrhea",
    keywords: [
      "diarrhea", "diarrhoea", "diarhea", "diarrea", "loose motion",
      "loose stool", "stomach upset", "runnin stomach", "stomach", "loose"
    ],
    symptoms: [
      "Frequent loose or watery stools (3+ times/day)",
      "Stomach cramps and pain",
      "Nausea",
      "Fever (in some cases)",
      "Bloating",
      "Urgency to pass stool",
      "Signs of dehydration — dry mouth, dark urine",
    ],
    precautions: [
      "Drink ORS to replace lost fluids",
      "Wash hands before eating and after toilet",
      "Eat freshly cooked, light food",
      "Avoid spicy, oily, or street food",
      "Boil water before drinking",
    ],
    next24Hours: [
      "Start ORS immediately — 1 sachet per 1 litre of water",
      "Eat BRAT diet: Banana, Rice, Applesauce, Toast",
      "Avoid dairy, spicy, and fatty food",
      "Do not take antibiotics without prescription",
      "If stools contain blood or diarrhea lasts >2 days — see a doctor",
      "Keep track of number of stools per hour",
    ],
  ),

  // 12. Asthma
  DiseaseInfo(
    name: "Asthma",
    keywords: [
      "asthma", "athma", "ashtma", "astma", "asthama", "breathing problem",
      "wheezing", "breath difficulty", "short of breath", "chest tightness"
    ],
    symptoms: [
      "Wheezing (whistling sound while breathing)",
      "Shortness of breath",
      "Chest tightness",
      "Coughing (especially at night)",
      "Difficulty sleeping due to breathing trouble",
    ],
    precautions: [
      "Avoid triggers: dust, smoke, pollen, cold air",
      "Always carry your rescue inhaler",
      "Do not smoke and avoid secondhand smoke",
      "Take prescribed preventive inhaler daily",
      "Know your asthma action plan",
    ],
    next24Hours: [
      "Use rescue inhaler (Salbutamol) if wheezing starts",
      "Sit upright — do not lie down during an attack",
      "Breathe slowly and calmly through pursed lips",
      "Remove yourself from any dust or smoke environment",
      "If inhaler doesn't help within 20 mins — call emergency",
      "Avoid cold drinks and cold air",
    ],
  ),

  // 13. Jaundice
  DiseaseInfo(
    name: "Jaundice",
    keywords: [
      "jaundice", "joundice", "jandice", "jaundis", "yellow skin",
      "yellow eyes", "yellowing", "yellow urine liver"
    ],
    symptoms: [
      "Yellowing of skin and whites of eyes",
      "Dark yellow or brown urine",
      "Pale or clay-colored stools",
      "Fatigue",
      "Abdominal pain (especially upper right side)",
      "Nausea and vomiting",
      "Itchy skin",
    ],
    precautions: [
      "Drink only boiled or purified water",
      "Avoid alcohol completely",
      "Eat fresh, home-cooked food",
      "Do not share food or utensils",
      "Get Hepatitis A and B vaccines",
    ],
    next24Hours: [
      "Visit a doctor for liver function tests (LFT)",
      "Drink sugarcane juice, lemon water, and barley water",
      "Eat very light food — khichdi, dal, fruits",
      "AVOID oily, spicy food and alcohol",
      "Rest completely — liver needs to heal",
      "Monitor urine color — should become lighter with hydration",
    ],
  ),

  // 14. Malnutrition
  DiseaseInfo(
    name: "Malnutrition",
    keywords: [
      "malnutrition", "malnutrishion", "malnourished", "underweight",
      "vitamin deficiency", "nutrient deficiency", "weakness hunger",
      "thin body listless"
    ],
    symptoms: [
      "Low body weight for age/height",
      "Fatigue and weakness",
      "Swollen belly (in severe cases)",
      "Dull, dry hair and skin",
      "Poor wound healing",
      "Frequent infections",
      "Listlessness and irritability",
    ],
    precautions: [
      "Eat a balanced diet with protein, carbs, fats, and vitamins",
      "Promote breastfeeding for infants",
      "Take prescribed nutritional supplements",
      "Grow kitchen gardens for fresh vegetables",
      "Access government nutrition programs (ICDS, MDM)",
    ],
    next24Hours: [
      "Start with small, frequent nutritious meals",
      "Give peanut-based therapeutic food (RUTF) if available",
      "Give ORS if dehydrated",
      "See an ASHA worker or doctor for nutritional assessment",
      "Give prescribed iron, zinc, and vitamin supplements",
      "Ensure child gets Vitamin A dose at health center",
    ],
  ),

  // 15. Heat Stroke
  DiseaseInfo(
    name: "Heat Stroke",
    keywords: [
      "heat stroke", "heatstroke", "heat strk", "sun stroke", "sunstroke",
      "too hot faint", "heat faint", "hot weather collapse"
    ],
    symptoms: [
      "Extremely high body temperature (104°F+)",
      "Hot, red, dry skin (not sweating)",
      "Confusion or altered mental state",
      "Rapid, strong pulse",
      "Headache and dizziness",
      "Nausea",
      "Loss of consciousness in severe cases",
    ],
    precautions: [
      "Stay indoors during peak heat (12pm–4pm)",
      "Drink water regularly — don't wait until thirsty",
      "Wear loose, light-colored clothing",
      "Use shade, hats, and umbrellas outdoors",
      "Never leave children/elderly in parked vehicles",
    ],
    next24Hours: [
      "EMERGENCY — Call for help immediately",
      "Move patient to cool, shady area instantly",
      "Cool the body with wet cloths or ice packs on neck/armpits/groin",
      "Give cold water to sip if conscious",
      "Do NOT give fever medicine — it won't help heat stroke",
      "Rush to hospital — heat stroke can be fatal",
    ],
  ),

  // 16. Measles
  DiseaseInfo(
    name: "Measles",
    keywords: [
      "measles", "meazles", "measels", "morbilli", "rubeola",
      "red rash fever", "koplik spots", "measle"
    ],
    symptoms: [
      "High fever",
      "Runny nose and cough",
      "Red, watery eyes (conjunctivitis)",
      "White spots inside mouth (Koplik spots)",
      "Red-brown blotchy rash starting at face, spreading downward",
      "Sensitivity to light",
    ],
    precautions: [
      "Get MMR vaccine (Measles, Mumps, Rubella)",
      "Isolate infected person for 4 days after rash appears",
      "Wash hands frequently",
      "Good nutrition and Vitamin A supplementation for children",
      "Ensure community vaccination coverage",
    ],
    next24Hours: [
      "See a doctor to confirm diagnosis",
      "Give paracetamol for fever",
      "Keep the child well-hydrated",
      "Give Vitamin A as recommended by doctor",
      "Keep lights dim — rash causes light sensitivity",
      "Isolate from unvaccinated people, especially infants",
    ],
  ),

  // 17. Conjunctivitis (Pink Eye)
  DiseaseInfo(
    name: "Conjunctivitis (Pink Eye)",
    keywords: [
      "conjunctivitis", "pink eye", "pinkeye", "eye infection", "red eye",
      "eye discharge", "sore eye", "conjunctivitus", "conjunctivis",
      "itchy eye watery"
    ],
    symptoms: [
      "Redness in whites of eyes",
      "Watery or thick, sticky discharge from eye",
      "Itching and burning sensation in eye",
      "Swollen eyelids",
      "Sensitivity to light",
      "Crusting around eyelids in the morning",
    ],
    precautions: [
      "Do not touch or rub your eyes",
      "Wash hands frequently with soap",
      "Do not share towels, handkerchiefs, or eye drops",
      "Isolate infected person to prevent spread",
      "Avoid wearing contact lenses until fully healed",
    ],
    next24Hours: [
      "See a doctor for antibiotic eye drops if bacterial",
      "Gently clean eye discharge with clean, wet cotton",
      "Apply cool or warm compress for comfort",
      "Avoid touching the eyes",
      "Stay home from school or work to prevent spread",
      "Do not use old or shared eye drops",
    ],
  ),

  // 18. Food Poisoning
  DiseaseInfo(
    name: "Food Poisoning",
    keywords: [
      "food poisoning", "food poison", "bad food", "stomach poisoning",
      "vomiting diarrhea food", "ate something bad", "food intoxication",
      "food poisoining"
    ],
    symptoms: [
      "Nausea and vomiting",
      "Diarrhea (watery or bloody)",
      "Stomach cramps",
      "Fever",
      "Headache",
      "Weakness",
      "Signs of dehydration",
    ],
    precautions: [
      "Eat food that is freshly cooked and hot",
      "Refrigerate leftovers promptly",
      "Wash hands before cooking and eating",
      "Avoid raw or undercooked meat and eggs",
      "Check expiry dates on packaged food",
    ],
    next24Hours: [
      "Stop eating solid food for a few hours to rest the stomach",
      "Drink ORS, coconut water, or clear broth",
      "After 4–6 hours, try bland food like rice, banana, toast",
      "See a doctor if vomiting is continuous or if blood in stool",
      "Take ORS — do not take antibiotics without prescription",
      "Seek emergency if dehydration signs appear (no urine in 6 hrs)",
    ],
  ),

  // 19. Anemia
  DiseaseInfo(
    name: "Anemia",
    keywords: [
      "anemia", "anaemia", "anemea", "aneamia", "low hemoglobin", "low hb",
      "iron deficiency", "pale skin fatigue", "blood deficiency", "pandu"
    ],
    symptoms: [
      "Extreme fatigue and weakness",
      "Pale or yellowish skin",
      "Shortness of breath on exertion",
      "Dizziness and lightheadedness",
      "Irregular or fast heartbeat",
      "Chest pain",
      "Cold hands and feet",
      "Brittle nails and hair loss",
    ],
    precautions: [
      "Eat iron-rich foods: spinach, beans, lentils, jaggery, meat",
      "Pair with Vitamin C foods to increase iron absorption",
      "Take prescribed iron and folic acid tablets",
      "Avoid tea/coffee with meals (reduces iron absorption)",
      "Deworm regularly (especially in children)",
    ],
    next24Hours: [
      "Get a hemoglobin blood test done",
      "Start prescribed iron supplement if not already taken",
      "Eat a meal with iron-rich food: dal, spinach, or eggs",
      "Drink orange juice with iron-rich food",
      "If very dizzy or chest pain — go to hospital",
      "Do not self-prescribe iron injections",
    ],
  ),

  // 20. Scabies
  DiseaseInfo(
    name: "Scabies",
    keywords: [
      "scabies", "scabees", "skabies", "scabes", "intense itching skin",
      "burrow skin", "skin mite", "itching night skin rash", "sarcoptes"
    ],
    symptoms: [
      "Intense itching (worse at night)",
      "Thin, irregular burrow tracks on skin",
      "Rash with pimple-like sores",
      "Sores from scratching (can get infected)",
      "Rash commonly between fingers, wrists, elbows, armpits",
    ],
    precautions: [
      "Do not share clothing, bedding, or towels",
      "Wash all bedding and clothes in hot water",
      "Treat all family members simultaneously",
      "Avoid close physical contact until treated",
      "Cut fingernails short to prevent scratching infection",
    ],
    next24Hours: [
      "See a doctor for prescription scabicide cream (Permethrin)",
      "Apply cream from neck downward, leave for 8–14 hours",
      "Everyone in the household must be treated",
      "Wash all clothes and bedding in hot water (60°C+)",
      "Do not re-use untreated clothing or bedding",
      "Itching may continue for 1–2 weeks after treatment — this is normal",
    ],
  ),

  // 21. Influenza (Flu)
  DiseaseInfo(
    name: "Influenza (Flu)",
    keywords: [
      "influenza", "flu", "flue", "inflenza", "infuenza", "seasonal flu",
      "common flu", "grippe", "body ache fever cold"
    ],
    symptoms: [
      "Sudden onset of fever (100–104°F)",
      "Severe body aches and muscle pain",
      "Headache",
      "Chills and sweating",
      "Dry cough",
      "Sore throat",
      "Runny or stuffy nose",
      "Fatigue (can be extreme)",
    ],
    precautions: [
      "Get annual flu vaccine",
      "Wash hands regularly",
      "Cover mouth while sneezing or coughing",
      "Avoid close contact with sick people",
      "Stay home when sick to avoid spreading",
    ],
    next24Hours: [
      "Rest completely and avoid physical activity",
      "Drink warm fluids: warm water, herbal tea, soup",
      "Take paracetamol/ibuprofen for fever and body aches",
      "Use saline nasal spray for congestion",
      "See a doctor if fever is very high or difficulty breathing",
      "Isolate from elderly, infants, and immunocompromised people",
    ],
  ),

  // 22. Migraine
  DiseaseInfo(
    name: "Migraine",
    keywords: [
      "migraine", "migraene", "migren", "migrene", "migrain",
      "one side headache", "throbbing headache", "pulsating headache",
      "vomiting headache nausea"
    ],
    symptoms: [
      "Intense throbbing headache (usually one side of head)",
      "Nausea and vomiting",
      "Sensitivity to light and sound",
      "Visual disturbances (aura — flashes, zigzag lines)",
      "Pain worsening with physical activity",
      "Dizziness",
    ],
    precautions: [
      "Identify and avoid personal triggers (stress, bright light, certain foods)",
      "Maintain a regular sleep schedule",
      "Stay hydrated",
      "Avoid skipping meals",
      "Keep a migraine diary to track triggers",
    ],
    next24Hours: [
      "Rest in a dark, quiet room",
      "Apply cold or warm compress on forehead",
      "Take prescribed migraine medicine at first sign of pain",
      "Drink water — dehydration worsens migraine",
      "Avoid screen time, bright lights, and loud sounds",
      "If pain is worst-ever — see a doctor to rule out serious causes",
    ],
  ),
];

// ─── Public API ─────────────────────────────────────────────────────────────

/// Returns the matching DiseaseInfo if the query matches any disease.
/// Returns null if no match found.
DiseaseInfo? findDiseaseByQuery(String query) {
  if (query.trim().isEmpty) return null;
  for (final disease in offlineDiseaseDatabase) {
    if (_queryMatchesKeywords(query, disease.keywords)) {
      return disease;
    }
  }
  return null;
}

/// Formats the DiseaseInfo into a single text string for display,
/// structured as: name, symptoms, precautions, next 24 hours.
String formatDiseaseResponse(DiseaseInfo disease) {
  final buf = StringBuffer();
  buf.writeln("Disease: ${disease.name}");
  buf.writeln("");
  buf.writeln("Symptoms:");
  for (final s in disease.symptoms) {
    buf.writeln("- $s");
  }
  buf.writeln("");
  buf.writeln("Precautions:");
  for (final p in disease.precautions) {
    buf.writeln("- $p");
  }
  buf.writeln("");
  buf.writeln("What to do in the next 24 hours:");
  for (final n in disease.next24Hours) {
    buf.writeln("- $n");
  }
  return buf.toString().trim();
}
