// health_alerts_data.dart
// Dummy Twitter-like health alert pool — mimics a real health API feed.
// The service randomly picks from this pool on each refresh to simulate
// fresh incoming data.

class HealthAlert {
  final String id;
  final String title;
  final String body;
  final String source;       // display name (e.g. "Ministry of Health India")
  final String handle;       // @handle (e.g. "@MoHFW_INDIA")
  final String category;     // "vaccination" | "program" | "alert" | "camp"
  final String timeAgo;      // e.g. "2h ago"
  final int likes;
  final int retweets;

  const HealthAlert({
    required this.id,
    required this.title,
    required this.body,
    required this.source,
    required this.handle,
    required this.category,
    required this.timeAgo,
    required this.likes,
    required this.retweets,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'body': body,
        'source': source,
        'handle': handle,
        'category': category,
        'timeAgo': timeAgo,
        'likes': likes,
        'retweets': retweets,
      };

  factory HealthAlert.fromJson(Map<String, dynamic> j) => HealthAlert(
        id: j['id'],
        title: j['title'],
        body: j['body'],
        source: j['source'],
        handle: j['handle'],
        category: j['category'],
        timeAgo: j['timeAgo'],
        likes: j['likes'],
        retweets: j['retweets'],
      );
}

// ─── Full pool (28 items) ──────────────────────────────────────────────────
const List<HealthAlert> kAlertPool = [
  HealthAlert(
    id: 'a001',
    title: 'Free COVID-19 Booster Drive Launched',
    body:
        'The Ministry of Health has launched a nationwide free COVID-19 booster drive. All adults above 18 can walk in to their nearest PHC or government hospital for the booster shot. No appointment is required. Drive runs till 31st March.',
    source: 'Ministry of Health India',
    handle: '@MoHFW_INDIA',
    category: 'vaccination',
    timeAgo: '12m ago',
    likes: 2341,
    retweets: 987,
  ),
  HealthAlert(
    id: 'a002',
    title: 'Pulse Polio Immunization Sunday',
    body:
        'National Pulse Polio immunization day is this Sunday. Every child under 5 years must receive oral polio drops. Booths will be set up at all government schools, anganwadi centres, and PHCs from 8 AM to 5 PM. Do not miss it!',
    source: 'MoHFW India',
    handle: '@MoHFW_INDIA',
    category: 'vaccination',
    timeAgo: '34m ago',
    likes: 4120,
    retweets: 1803,
  ),
  HealthAlert(
    id: 'a003',
    title: 'Free TB Screening Camp — DOTS Centers',
    body:
        'RNTCP is organizing free tuberculosis (TB) screening camps at all DOTS centers this week. Sputum tests, chest X-rays, and TB medicines are free. Early detection saves lives. Visit your nearest DOTS center now.',
    source: 'RNTCP India',
    handle: '@RNTCPIndia',
    category: 'camp',
    timeAgo: '1h ago',
    likes: 1120,
    retweets: 620,
  ),
  HealthAlert(
    id: 'a004',
    title: 'Dengue Outbreak Alert — East Zone',
    body:
        'The health department has issued a dengue alert for the eastern districts. Aedes mosquito breeding sites have been identified. Citizens must drain all stagnant water, use mosquito nets and repellent, and report fever cases to their nearest PHC immediately.',
    source: 'State Health Dept',
    handle: '@StateHealthODISHA',
    category: 'alert',
    timeAgo: '2h ago',
    likes: 3200,
    retweets: 2100,
  ),
  HealthAlert(
    id: 'a005',
    title: 'Ayushman Bharat Camp — Free Surgery',
    body:
        'Ayushman Bharat Pradhan Mantri Jan Arogya Yojana (PM-JAY) health camps are being held across rural blocks. Free cataract surgeries, hernia operations, and knee replacements are being offered. Visit your district hospital with your Ayushman card.',
    source: 'PM-JAY India',
    handle: '@AyushmanNHA',
    category: 'program',
    timeAgo: '3h ago',
    likes: 5500,
    retweets: 3400,
  ),
  HealthAlert(
    id: 'a006',
    title: 'Pentavalent Vaccine for Infants — Free',
    body:
        'Pentavalent vaccine (DPT + HepB + Hib) is available free for all infants at 6, 10, and 14 weeks of age at government hospitals. Protect your baby from diphtheria, pertussis, tetanus, hepatitis B, and meningitis. Check with your ANM today.',
    source: 'Universal Immunization Programme',
    handle: '@UIP_India',
    category: 'vaccination',
    timeAgo: '4h ago',
    likes: 2800,
    retweets: 1450,
  ),
  HealthAlert(
    id: 'a007',
    title: 'Malaria Free India Campaign 2024',
    body:
        'India aims to eliminate malaria by 2027. Free rapid diagnostic tests (RDTs) and artemisinin-based therapy are available at all PHCs. If you have fever with chills, visit your PHC immediately for a free malaria test.',
    source: 'NVBDCP India',
    handle: '@NVBDCP',
    category: 'program',
    timeAgo: '5h ago',
    likes: 1990,
    retweets: 780,
  ),
  HealthAlert(
    id: 'a008',
    title: 'Blood Donation Camp — O+ Shortage',
    body:
        'Urgent appeal: there is a critical shortage of O+ and B− blood at district hospitals. The Red Cross Society is organizing emergency donation camps. Donors above 18 years and 50 kg weight can visit any blood bank. Walk-ins accepted.',
    source: 'Red Cross India',
    handle: '@IndianRedCross',
    category: 'camp',
    timeAgo: '6h ago',
    likes: 6700,
    retweets: 4200,
  ),
  HealthAlert(
    id: 'a009',
    title: 'HPV Vaccine Now Free for Girls 9–14',
    body:
        'The Government of India has included the HPV (Human Papillomavirus) vaccine in the Universal Immunization Programme. Girls aged 9–14 years can receive the free vaccine at all government health facilities. Prevents cervical cancer.',
    source: 'MoHFW India',
    handle: '@MoHFW_INDIA',
    category: 'vaccination',
    timeAgo: '7h ago',
    likes: 8200,
    retweets: 5100,
  ),
  HealthAlert(
    id: 'a010',
    title: 'National Mental Health Helpline — iCall',
    body:
        'iCall mental health helpline is now available 24/7 at 9152987821. Free, confidential counseling for depression, anxiety, stress, and trauma. NIMHANS-trained counselors available in multiple Indian languages. You are not alone.',
    source: 'NIMHANS Outreach',
    handle: '@NIMHANS_Official',
    category: 'program',
    timeAgo: '8h ago',
    likes: 12300,
    retweets: 8700,
  ),
  HealthAlert(
    id: 'a011',
    title: 'Free Eye Check-up Camp — NPCB',
    body:
        'National Programme for Control of Blindness (NPCB) is conducting free eye check-up camps at taluk hospitals. Free spectacles and cataract surgeries for eligible patients. Camp dates: every Tuesday and Thursday from 9 AM to 2 PM.',
    source: 'NPCB India',
    handle: '@NPCB_INDIA',
    category: 'camp',
    timeAgo: '10h ago',
    likes: 1300,
    retweets: 550,
  ),
  HealthAlert(
    id: 'a012',
    title: 'Cholera Outbreak — Water Safety Warning',
    body:
        'Cholera cases reported in low-lying flood-affected areas. ONLY drink boiled or chlorinated water. Oral rehydration therapy (ORS) packets are free at PHCs. Wash hands frequently. Rush severe diarrhea patients to hospital immediately — do not delay.',
    source: 'District Health Officer',
    handle: '@DHO_Alert',
    category: 'alert',
    timeAgo: '11h ago',
    likes: 4100,
    retweets: 3900,
  ),
  HealthAlert(
    id: 'a013',
    title: 'PMJAY — 5 Lakh Free Treatment',
    body:
        'Under Pradhan Mantri Jan Arogya Yojana, eligible families receive up to ₹5 lakh per year for free hospital treatment. Visit the nearest Ayushman Bharat empaneled hospital with your Ayushman card or ration card to check eligibility.',
    source: 'Ayushman Bharat NHA',
    handle: '@AyushmanNHA',
    category: 'program',
    timeAgo: '13h ago',
    likes: 19000,
    retweets: 11200,
  ),
  HealthAlert(
    id: 'a014',
    title: 'Janani Suraksha Yojana — Free Delivery',
    body:
        'Pregnant women can avail free institutional delivery and cash incentives under the Janani Suraksha Yojana (JSY). Contact your local ASHA worker or ANM for enrollment. Free ante-natal check-ups, iron supplements, and nutrition support available.',
    source: 'RCH India',
    handle: '@RCH_MoHFW',
    category: 'program',
    timeAgo: '15h ago',
    likes: 6800,
    retweets: 3200,
  ),
  HealthAlert(
    id: 'a015',
    title: 'Heat Wave Warning — Stay Hydrated',
    body:
        'Severe heat wave conditions expected in central and northern India. Stay indoors between 12 PM – 4 PM. Drink at least 10 glasses of water per day. ORS sachets are free at PHCs. Do not step out without head cover. Check on elderly neighbors.',
    source: 'IMD Health Advisory',
    handle: '@Indiametdept',
    category: 'alert',
    timeAgo: '16h ago',
    likes: 21000,
    retweets: 14500,
  ),
  HealthAlert(
    id: 'a016',
    title: 'Nipah Virus Precaution — Kerala',
    body:
        'Health authorities in Kerala are monitoring a cluster of Nipah virus cases. Avoid contact with fruit bats or raw date palm sap. Seek immediate care if you have fever, headache, or altered consciousness after contact with potential cases. Do not panic — isolation protocols are in place.',
    source: 'Kerala Health Dept',
    handle: '@KeralaHealth',
    category: 'alert',
    timeAgo: '18h ago',
    likes: 34000,
    retweets: 22000,
  ),
  HealthAlert(
    id: 'a017',
    title: 'Anemia Mukt Bharat — Free Iron Tablets',
    body:
        'Under Anemia Mukt Bharat, free weekly iron and folic acid (IFA) tablets are being distributed to adolescent girls, pregnant women, and school children. Pick up your IFA tablets from your local school, anganwadi, or PHC.',
    source: 'Anemia Mukt Bharat',
    handle: '@MoHFW_INDIA',
    category: 'program',
    timeAgo: '20h ago',
    likes: 3400,
    retweets: 1560,
  ),
  HealthAlert(
    id: 'a018',
    title: 'J–O Vaccination for Encephalitis',
    body:
        'Japanese Encephalitis vaccination drive is underway in high-risk districts of UP, Bihar, Assam, and West Bengal. Children aged 1–15 years are eligible for the free JE vaccine. Visit your nearest PHC or sub-centre immediately.',
    source: 'NVBDCP India',
    handle: '@NVBDCP',
    category: 'vaccination',
    timeAgo: '22h ago',
    likes: 2100,
    retweets: 980,
  ),
  HealthAlert(
    id: 'a019',
    title: 'Nutrition Rehabilitation Center — SAM Children',
    body:
        'Children with Severe Acute Malnutrition (SAM) can receive FREE intensive nutrition therapy at Nutrition Rehabilitation Centers (NRCs). Admission includes therapeutic food, medical care, and caregiver counseling. Contact your block CDPO or ASHA worker.',
    source: 'ICDS India',
    handle: '@WCD_Ministry',
    category: 'program',
    timeAgo: '1d ago',
    likes: 1800,
    retweets: 760,
  ),
  HealthAlert(
    id: 'a020',
    title: 'Free Dialysis — Pradhan Mantri NDD',
    body:
        'Under the Pradhan Mantri National Dialysis Programme, free dialysis services are available for BPL patients at government hospitals and PPP units. Over 5 lakh sessions provided annually. Register at your district hospital with BPL card.',
    source: 'PM-NDP India',
    handle: '@MoHFW_INDIA',
    category: 'program',
    timeAgo: '1d ago',
    likes: 4600,
    retweets: 2300,
  ),
  HealthAlert(
    id: 'a021',
    title: 'Rabies Post-Exposure Prophylaxis Free',
    body:
        'Dog bite or animal bite? Post-exposure prophylaxis (PEP) anti-rabies vaccine is available FREE at all government hospitals. Clean the wound thoroughly with soap and water for 15 minutes, then go to the nearest CHC immediately.',
    source: 'NCDC India',
    handle: '@NCDC_MoHFW',
    category: 'camp',
    timeAgo: '2d ago',
    likes: 5100,
    retweets: 3800,
  ),
  HealthAlert(
    id: 'a022',
    title: 'Swasth Bharat Yatra — Rural Health Drive',
    body:
        'Swasth Bharat Yatra is reaching your village! Free screenings for hypertension, diabetes, cancer, and TB are being conducted by the mobile health unit. Check your local panchayat notice board for dates and venues.',
    source: 'Swasth Bharat Mission',
    handle: '@SwasthBharat',
    category: 'camp',
    timeAgo: '2d ago',
    likes: 2900,
    retweets: 1300,
  ),
  HealthAlert(
    id: 'a023',
    title: 'Meningitis Vaccine for Hajj Pilgrims',
    body:
        'Meningococcal vaccine is mandatory for all pilgrims travelling for Hajj or Umrah. Free vaccination is available at designated government hospitals. Carry your vaccination certificate during travel. Visit your nearest port health office.',
    source: 'Ministry of Health India',
    handle: '@MoHFW_INDIA',
    category: 'vaccination',
    timeAgo: '3d ago',
    likes: 1100,
    retweets: 430,
  ),
  HealthAlert(
    id: 'a024',
    title: 'PMSSY — Affordable Hospital Treatment',
    body:
        'Pradhan Mantri Swasthya Suraksha Yojana is upgrading AIIMS and government hospitals in underserved regions. Patients can access specialist care at subsidized rates. Telemedicine consultations available via eSanjeevani portal (esanjeevani.mohfw.gov.in).',
    source: 'PMSSY India',
    handle: '@MoHFW_INDIA',
    category: 'program',
    timeAgo: '3d ago',
    likes: 3700,
    retweets: 1900,
  ),
  HealthAlert(
    id: 'a025',
    title: 'Monsoon Leptospirosis Advisory',
    body:
        'Heavy rainfall has increased leptospirosis risk. Avoid wading in floodwater. Wear rubber boots. Prophylactic doxycycline is recommended for high-risk individuals — consult your doctor. Report any fever within 2 weeks of flood exposure at your PHC.',
    source: 'State Health Dept',
    handle: '@StateHealthDept',
    category: 'alert',
    timeAgo: '4d ago',
    likes: 2200,
    retweets: 1600,
  ),
  HealthAlert(
    id: 'a026',
    title: 'National Deworming Day — All Children',
    body:
        'National Deworming Day is approaching! All children aged 1–19 years will receive a free albendazole tablet at their school or anganwadi. Deworming improves nutrition, cognition, and growth. No child should be missed.',
    source: 'MoHFW India',
    handle: '@MoHFW_INDIA',
    category: 'program',
    timeAgo: '4d ago',
    likes: 7800,
    retweets: 4200,
  ),
  HealthAlert(
    id: 'a027',
    title: 'ASHA Helpdesk — 104 Health Helpline',
    body:
        '104 is your free 24/7 health helpline. Get medical advice, information on government health schemes, ambulance coordination, and ASHA worker contacts — all in your local language. Available across all Indian states.',
    source: 'National Health Mission',
    handle: '@NHM_India',
    category: 'program',
    timeAgo: '5d ago',
    likes: 9100,
    retweets: 5600,
  ),
  HealthAlert(
    id: 'a028',
    title: 'Fluorosis Alert — Safe Water Campaign',
    body:
        'High fluoride groundwater has been detected in several districts. Long-term consumption causes dental and skeletal fluorosis. Safe drinking water RO kiosks have been set up at gram panchayat offices. Do NOT use borewell water directly for drinking.',
    source: 'Jal Jeevan Mission',
    handle: '@jaljeevanmission',
    category: 'alert',
    timeAgo: '6d ago',
    likes: 1600,
    retweets: 900,
  ),
];

// Initial 10 shown on first launch (indices into kAlertPool)
const List<int> kInitialAlertIndices = [0, 3, 4, 8, 7, 9, 12, 14, 15, 1];

// Pool of "new" alerts injected on each refresh (cycles through remaining ones)
final List<int> kRefreshAlertIndices = [
  2, 5, 6, 10, 11, 13, 16, 17, 18, 19,
  20, 21, 22, 23, 24, 25, 26, 27,
];
