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
hardware: https://wokwi.com/projects/458756188281467905

## Impact
- Enables healthcare access in low-connectivity areas
- Reduces emergency response time
- Enables accessible healthcare in rural and low-connectivity areas
- Reduces emergency response time through offline triggers
- Improves patient monitoring and medication adherence through smart automated pill and liquid dispensers
- Creates a complete smart medical environment with connected wearables, personalized dispensers, and centralized monitoring
- Assists doctors and caregivers with quick insights, real-time vitals, and better decision-making
- Scalable for hospital wards, disaster zones, remote regions, and large-scale public health systems

**Hardware**
<img width="876" height="837" alt="image" src="https://github.com/user-attachments/assets/35b2559b-e3bf-4fee-b551-b5d3a1ee3f06" />
<img width="910" height="846" alt="image" src="https://github.com/user-attachments/assets/9986a42d-870c-40f1-b02d-d7f000a3ed50" />

**Patient Dashboard for doctors**
<img width="1552" height="917" alt="image" src="https://github.com/user-attachments/assets/b2ed987a-0a75-44b0-9017-21062a5964a9" />
<img width="1600" height="912" alt="image" src="https://github.com/user-attachments/assets/ae8d8b4d-d589-4e7a-a2c3-fe3eb25f5bc9" />
<img width="1578" height="961" alt="image" src="https://github.com/user-attachments/assets/ab4be104-f8bc-4ea4-8cdb-1c7ba40fb958" />
<img width="1600" height="862" alt="image" src="https://github.com/user-attachments/assets/7b973165-728d-4970-85ae-9d0d34eef2dc" />

**Articuno - Medlink App**
<img width="720" height="1600" alt="image" src="https://github.com/user-attachments/assets/a94f39e4-4a50-4400-ba93-fce90a371ee9" />
<img width="752" height="1600" alt="image" src="https://github.com/user-attachments/assets/c16e7abd-cdd8-4c46-915e-830304243d6f" />
<img width="750" height="1600" alt="image" src="https://github.com/user-attachments/assets/399951c9-2578-46fd-9b0e-2b0b72f7ad07" />
<img width="751" height="1600" alt="image" src="https://github.com/user-attachments/assets/d7023b17-8fef-433f-974e-f5bdb3f0abfe" />
<img width="720" height="1600" alt="image" src="https://github.com/user-attachments/assets/e39d5b14-a947-4763-bd2a-2318986f2e1b" />


**SMS integration**
<img width="401" height="527" alt="image" src="https://github.com/user-attachments/assets/10d915bd-b76a-4e36-85ef-2011a4632622" />

**Whatsapp Chatbot**
<img width="406" height="532" alt="image" src="https://github.com/user-attachments/assets/baa49072-0651-44de-834e-98d9395e71b1" />
