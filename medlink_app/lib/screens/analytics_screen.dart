import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  double heartRate = 72;
  double oxygenLevel = 98.2;
  double bodyTemp = 36.8;
  String bloodPressure = '120/80';
  double stressLevel = 35;
  double glucoseLevel = 95;

  late Timer _timer;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    // simulate live wearable data
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      setState(() {
        heartRate = 68 + _random.nextDouble() * 12;
        oxygenLevel = 96 + _random.nextDouble() * 3;
        bodyTemp = 36.4 + _random.nextDouble() * 0.8;
        stressLevel = 25 + _random.nextDouble() * 30;
        glucoseLevel = 85 + _random.nextDouble() * 25;
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          'Health Dashboard',
          style: TextStyle(color: Colors.tealAccent),
        ),
        backgroundColor: const Color.fromARGB(255, 3, 48, 51),
        foregroundColor: Colors.tealAccent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // heart rate and oxygen
            Row(
              children: [
                Expanded(
                  child: _buildGaugeCard(
                    title: "Heart Rate",
                    value: heartRate,
                    unit: "BPM",
                    maxValue: 120,
                    color: Colors.red,
                    icon: Icons.favorite,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildGaugeCard(
                    title: "Blood Oxygen",
                    value: oxygenLevel,
                    unit: "%",
                    maxValue: 100,
                    color: Colors.blue,
                    icon: Icons.air,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // body temp and stress
            Row(
              children: [
                Expanded(
                  child: _buildGaugeCard(
                    title: "Body Temp",
                    value: bodyTemp,
                    unit: "C",
                    maxValue: 42,
                    color: Colors.orange,
                    icon: Icons.thermostat,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildGaugeCard(
                    title: "Stress Level",
                    value: stressLevel,
                    unit: "%",
                    maxValue: 100,
                    color: Colors.purple,
                    icon: Icons.psychology,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // health monitor panel
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blueGrey[900]!, Colors.black],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.teal.withOpacity(0.3),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Health Monitor",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildHealthRow(
                    "Heart Rate",
                    "${heartRate.toStringAsFixed(1)} BPM",
                    Colors.orange,
                  ),
                  _buildHealthRow(
                    "Blood Oxygen",
                    "${oxygenLevel.toStringAsFixed(1)}%",
                    Colors.yellow,
                  ),
                  _buildHealthRow(
                    "Body Temperature",
                    "${bodyTemp.toStringAsFixed(1)}C",
                    Colors.red,
                  ),
                  _buildHealthRow(
                    "Blood Pressure",
                    "$bloodPressure mmHg",
                    Colors.blue,
                  ),
                  _buildHealthRow(
                    "Stress Level",
                    "${stressLevel.toStringAsFixed(0)}%",
                    Colors.purple,
                  ),
                  _buildHealthRow(
                    "Glucose Level",
                    "${glucoseLevel.toStringAsFixed(0)} mg/dL",
                    Colors.green,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGaugeCard({
    required String title,
    required double value,
    required String unit,
    required double maxValue,
    required Color color,
    required IconData icon,
  }) {
    final progress = (value / maxValue).clamp(0.0, 1.0);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.3), Colors.black],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 30),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
          const SizedBox(height: 12),
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 80,
                height: 80,
                child: CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 8,
                  backgroundColor: Colors.white.withOpacity(0.1),
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                ),
              ),
              Text(
                "${value.toStringAsFixed(1)}",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(unit, style: TextStyle(color: color, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildHealthRow(String label, String value, Color valueColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
          Text(value, style: TextStyle(color: valueColor, fontSize: 14)),
        ],
      ),
    );
  }
}
