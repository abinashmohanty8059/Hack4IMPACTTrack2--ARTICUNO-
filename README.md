# ARTICUNO - Offline Healthcare & Emergency Response App

## Team Members
- Abinash Mohanty
- Shanu
- Pratyusha Mohanty
- Yogisha Rani

## Domain
Healthcare / AI / Emergency Response 

## Problem Statement
Many people in rural or low-network areas lack access to timely medical guidance, and internet-dependent healthcare apps often fail during critical situations. In hospitals, especially common wards, managing multiple patients’ medication schedules and vital data manually is inefficient and prone to errors, increasing health risks.

There is a need for an offline-capable, intelligent healthcare system that integrates personalized automated pill and liquid dispensers for each patient, with medicine schedules mapped to individual profiles. A health monitoring band continuously tracks vitals like SpO₂ and temperature, updating patient data in real time. All information is connected to a centralized system accessible via a web or mobile dashboard, enabling nurses and supervisors to monitor, control, and respond quickly to patient needs

## Solution
ARTICUNO is a Flutter-based offline-first healthcare app that provides disease guidance using a trained ML model without internet access. It includes SMS and WhatsApp-based emergency triggering to contact nearby ambulances and a health dashboard for monitoring patient data.

It integrates emergency SOS via SMS and WhatsApp automation to quickly contact nearby ambulances, along with a health dashboard that tracks patient data from wearables in real time. The system also supports NLP-based querying for quick and efficient patient summaries.

Additionally, it includes a smart automated pill and liquid dispensing system, where each patient is assigned a personalized dispenser with pre-mapped medication schedules. These dispensers, along with continuous vitals from health bands, are connected to a centralized dashboard, allowing nurses and supervisors to monitor, manage, and intervene when necessary.

## Tech Stack
Flutter (Dart), Firebase, Node.js, Python, TensorFlow/PyTorch, Scikit-learn, SQLite/Hive, SMS Gateway API, WhatsApp API
**Hardware**: Esp32

## Key Features
- Offline disease prediction
- Precautions and remedy suggestions
- Emergency SOS via SMS
- WhatsApp-triggered ambulance system
- Health dashboard (simulated data)
- Medication tracking
- NLP-based patient summaries
- Pillbox + healthbad 

## System Flow
- User input -> ML model -> Disease prediction
- Emergency -> SMS/WhatsApp -> Backend -> Ambulance
- Wearable healthband + pillbox data -> Backend + ML-> Dashboard

## Impact
- Enables healthcare access in low-connectivity areas
- Reduces emergency response time
- Enables accessible healthcare in rural and low-connectivity areas
- Reduces emergency response time through offline triggers
- Improves patient monitoring and medication adherence through smart automated pill and liquid dispensers
- Creates a complete smart medical environment with connected wearables, personalized dispensers, and centralized monitoring
- Assists doctors and caregivers with quick insights, real-time vitals, and better decision-making
- Scalable for hospital wards, disaster zones, remote regions, and large-scale public health systems

