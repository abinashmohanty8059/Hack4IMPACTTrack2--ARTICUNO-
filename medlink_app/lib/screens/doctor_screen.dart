import 'package:flutter/material.dart';

class Doctor {
  final String name;
  final String specialty;
  final int experience;
  final double rating;
  final String hospital;

  Doctor({
    required this.name,
    required this.specialty,
    required this.experience,
    required this.rating,
    required this.hospital,
  });
}

class DoctorScreen extends StatefulWidget {
  const DoctorScreen({super.key});

  @override
  State<DoctorScreen> createState() => _DoctorScreenState();
}

class _DoctorScreenState extends State<DoctorScreen> {
  final List<String> categories = [
    'Cardiology',
    'Neurology',
    'Pediatrics',
    'Orthopedics',
    'Dermatology',
    'Ophthalmology',
    'Gynecology',
    'Dentistry',
    'Psychiatry',
    'Endocrinology'
  ];

  final Map<String, List<Doctor>> doctorsByCategory = {
    'Cardiology': [
      Doctor(name: 'Dr. Rajesh Sharma', specialty: 'Cardiology', experience: 15, rating: 4.8, hospital: 'Apollo Hospital'),
      Doctor(name: 'Dr. Priya Singh', specialty: 'Cardiology', experience: 12, rating: 4.7, hospital: 'Fortis Hospital'),
      Doctor(name: 'Dr. Amit Kumar', specialty: 'Cardiology', experience: 10, rating: 4.6, hospital: 'Max Healthcare'),
      Doctor(name: 'Dr. Sunita Patel', specialty: 'Cardiology', experience: 18, rating: 4.9, hospital: 'Medanta Hospital'),
      Doctor(name: 'Dr. Vikram Malhotra', specialty: 'Cardiology', experience: 14, rating: 4.7, hospital: 'Artemis Hospital'),
      Doctor(name: 'Dr. Neha Gupta', specialty: 'Cardiology', experience: 11, rating: 4.5, hospital: 'BLK Hospital'),
      Doctor(name: 'Dr. Anil Joshi', specialty: 'Cardiology', experience: 16, rating: 4.8, hospital: 'Columbia Asia'),
      Doctor(name: 'Dr. Meera Reddy', specialty: 'Cardiology', experience: 13, rating: 4.6, hospital: 'Manipal Hospital'),
      Doctor(name: 'Dr. Sanjay Verma', specialty: 'Cardiology', experience: 9, rating: 4.4, hospital: 'Jaslok Hospital'),
      Doctor(name: 'Dr. Kavita Das', specialty: 'Cardiology', experience: 17, rating: 4.9, hospital: 'Ruby Hall Clinic'),
    ],
    'Neurology': [
      Doctor(name: 'Dr. Arvind Chaturvedi', specialty: 'Neurology', experience: 14, rating: 4.7, hospital: 'Apollo Hospital'),
      Doctor(name: 'Dr. Sunil Mehta', specialty: 'Neurology', experience: 16, rating: 4.8, hospital: 'Fortis Hospital'),
      Doctor(name: 'Dr. Rekha Nair', specialty: 'Neurology', experience: 12, rating: 4.6, hospital: 'Max Healthcare'),
      Doctor(name: 'Dr. Alok Khanna', specialty: 'Neurology', experience: 18, rating: 4.9, hospital: 'Medanta Hospital'),
      Doctor(name: 'Dr. Pooja Desai', specialty: 'Neurology', experience: 11, rating: 4.5, hospital: 'Artemis Hospital'),
      Doctor(name: 'Dr. Ravi Menon', specialty: 'Neurology', experience: 15, rating: 4.7, hospital: 'BLK Hospital'),
      Doctor(name: 'Dr. Anjali Srinivasan', specialty: 'Neurology', experience: 13, rating: 4.6, hospital: 'Columbia Asia'),
      Doctor(name: 'Dr. Karan Johar', specialty: 'Neurology', experience: 10, rating: 4.4, hospital: 'Manipal Hospital'),
      Doctor(name: 'Dr. Nandini Kapoor', specialty: 'Neurology', experience: 17, rating: 4.9, hospital: 'Jaslok Hospital'),
      Doctor(name: 'Dr. Mohan Iyer', specialty: 'Neurology', experience: 9, rating: 4.3, hospital: 'Ruby Hall Clinic'),
    ],
  };

  String selectedCategory = 'Cardiology';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Doctor Consultation'),
        backgroundColor: Colors.teal.shade700,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          SizedBox(
            height: 80,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FilterChip(
                    label: Text(categories[index]),
                    selected: selectedCategory == categories[index],
                    onSelected: (bool selected) {
                      setState(() {
                        selectedCategory = categories[index];
                      });
                    },
                    selectedColor: Colors.teal.shade200,
                    checkmarkColor: Colors.teal.shade900,
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: (doctorsByCategory[selectedCategory] ?? []).length,
              itemBuilder: (context, index) {
                final doctor = doctorsByCategory[selectedCategory]![index];
                return DoctorCard(
                  doctor: doctor,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatScreen(doctor: doctor),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class DoctorCard extends StatelessWidget {
  final Doctor doctor;
  final VoidCallback onTap;

  const DoctorCard({
    super.key,
    required this.doctor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: Colors.teal.shade100,
          radius: 30,
          child: const Icon(Icons.person, size: 30, color: Colors.teal),
        ),
        title: Text(
          doctor.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(doctor.specialty),
            Text('${doctor.experience} years experience'),
            Text(doctor.hospital),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.star, color: Colors.amber, size: 20),
            Text('${doctor.rating}'),
          ],
        ),
      ),
    );
  }
}

class ChatScreen extends StatefulWidget {
  final Doctor doctor;

  const ChatScreen({super.key, required this.doctor});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [];

  void _sendMessage() {
    if (_messageController.text.isNotEmpty) {
      setState(() {
        _messages.add(ChatMessage(
          text: _messageController.text,
          isUser: true,
          timestamp: DateTime.now(),
        ));
        _messageController.clear();
      });

      Future.delayed(const Duration(seconds: 1), () {
        setState(() {
          _messages.add(ChatMessage(
            text: "Thank you for your message. I'll get back to you shortly regarding your query.",
            isUser: false,
            timestamp: DateTime.now(),
          ));
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.teal.shade100,
              child: const Icon(Icons.person, color: Colors.teal),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.doctor.name),
                Text(
                  widget.doctor.specialty,
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ],
        ),
        backgroundColor: Colors.teal.shade700,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(8.0),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  return MessageBubble(
                    text: message.text,
                    isUser: message.isUser,
                    timestamp: message.timestamp,
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                bottom: 24.0,
                left: 12.0,
                right: 12.0,
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(24.0),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        decoration: const InputDecoration(
                          hintText: 'Type your message...',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                        ),
                        onSubmitted: (_) => _sendMessage(),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.send, color: Colors.teal),
                      onPressed: _sendMessage,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}

class MessageBubble extends StatelessWidget {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  const MessageBubble({
    super.key,
    required this.text,
    required this.isUser,
    required this.timestamp,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isUser)
            CircleAvatar(
              backgroundColor: Colors.teal.shade100,
              child: const Icon(Icons.person, color: Colors.teal, size: 20),
            ),
          const SizedBox(width: 8),
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
              decoration: BoxDecoration(
                color: isUser ? Colors.teal.shade600 : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                text,
                style: TextStyle(
                  color: isUser ? Colors.white : Colors.black,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          if (isUser)
            CircleAvatar(
              backgroundColor: Colors.green.shade100,
              child: const Icon(Icons.person, color: Colors.green, size: 20),
            ),
        ],
      ),
    );
  }
}
