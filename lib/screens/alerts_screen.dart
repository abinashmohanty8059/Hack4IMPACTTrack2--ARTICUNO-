import 'package:flutter/material.dart';

class AlertsScreen extends StatefulWidget {
  const AlertsScreen({super.key});

  @override
  State<AlertsScreen> createState() => _AlertsScreenState();
}

class _AlertsScreenState extends State<AlertsScreen> {
  final List<Map<String, dynamic>> alerts = [
    {
      "id": "1",
      "summary": "Free Health Camp",
      "text":
          "Join us for a free rural health camp in Bhadrak this Sunday. The camp will offer free general check-ups, blood pressure monitoring, diabetes screening, and basic medicines for all attendees. Experienced doctors and nurses will be available from 9 AM to 4 PM at the Community Health Centre ground.",
      "source": "Health Dept Odisha",
    },
    {
      "id": "2",
      "summary": "Vaccination Drive",
      "text":
          "The Ministry of Health and Family Welfare is conducting a vaccination drive this week across local Primary Health Centres (PHCs). Both COVID-19 booster doses and routine Polio vaccines will be available free of cost. Parents are urged to bring their children under the age of 5 for Polio immunization.",
      "source": "MoHFW India",
    },
    {
      "id": "3",
      "summary": "Blood Donation Camp",
      "text":
          "The Odisha Red Cross Society is organizing an urgent blood donation camp in Cuttack on 25th September. Due to rising demand in local hospitals, there is a shortage of O+ and B+ blood units. Volunteers above 18 years of age and weighing more than 50 kg are encouraged to participate.",
      "source": "Red Cross Odisha",
    },
    {
      "id": "4",
      "summary": "Dengue Alert",
      "text":
          "Rising dengue cases reported in Bhubaneswar and nearby areas. Citizens are advised to avoid stagnant water accumulation, use mosquito nets and repellents, and seek medical attention if experiencing high fever, headache, or body pain. Keep your surroundings clean.",
      "source": "BMC Health",
    },
    {
      "id": "5",
      "summary": "Mental Health Awareness",
      "text":
          "Free mental health counseling sessions available at district hospitals every Saturday. Trained counselors will be available for confidential consultations. Walk-ins welcome between 10 AM and 3 PM. No appointment needed.",
      "source": "NIMHANS Outreach",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: const Text(
          "Health Alerts",
          style: TextStyle(
            color: Color(0xFF1DA1F2),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // pull to refresh placeholder
          await Future.delayed(const Duration(seconds: 1));
        },
        child: ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: alerts.length,
          itemBuilder: (context, index) {
            final alert = alerts[index];

            return Card(
              color: Colors.grey[900],
              margin: const EdgeInsets.symmetric(vertical: 6),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.campaign, color: Colors.teal.shade300, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          alert['source'] ?? '',
                          style: TextStyle(
                            color: Colors.teal.shade300,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      alert['summary'] ?? '',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      alert['text'] ?? '',
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
