# 🌾 Krishi Unnati (कृषि उन्नति)

> **Empowering Rural Growth** — Bridging the gap between farmers, AI technology, and government schemes for a prosperous agricultural future.

[![Flutter](https://img.shields.io/badge/Flutter-3.13+-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.0+-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
[![TensorFlow Lite](https://img.shields.io/badge/LiteRT-TFLite-FF6F00?style=for-the-badge&logo=tensorflow&logoColor=white)](https://tensorflow.org)
[![Firebase](https://img.shields.io/badge/Firebase-Core%20%7C%20Auth%20%7C%20Firestore-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)](https://firebase.google.com)

---

## 📌 About Krishi Unnati

**Krishi Unnati** is a comprehensive, AI-driven mobile application developed using Flutter. Designed specifically for Indian agriculture, the platform empowers farmers with instant AI pest and disease diagnosis, soil health analysis, precision fertilizer calculations, an agricultural marketplace, equipment rentals, and direct access to government schemes.

The app supports multi-role access (Farmers, Government Officers, and System Administrators), complete multi-language localization (English, Hindi, Marathi), and integrated **Text-to-Speech (TTS)** voice support to eliminate literacy barriers for rural users.

---

## ✨ Key Features

### 🚜 Farmer Portal
* **🤖 AI Crop Health & Pest Diagnosis**:
  * On-device image classification using TensorFlow Lite (`flutter_litert`).
  * Instant identification of crop diseases and pest infestations with probability scoring.
  * Organic and chemical remedy advisories with dosage guidelines.
* **🧪 Soil Health Hub**:
  * Upload soil test reports (image/PDF) or manually input soil parameters (NPK, pH, Organic Carbon, Electrical Conductivity).
  * Receive personalized crop suitability recommendations and soil treatment plans.
* **🌱 Fertilizer & Dosage Calculator**:
  * Input field size, crop selection, and soil test results.
  * Calculates exact requirement of Urea, DAP, MOP, or SSP fertilizers with scheduled application dates.
* **⚠️ Pest & Weather Alerts**:
  * Geospatial location detection via GPS.
  * Real-time regional pest outbreak warnings, weather advisories, and preventive measures.
* **🛒 Agricultural Marketplace**:
  * Direct platform for buying and selling farm produce, quality seeds, organic fertilizers, and tools without middlemen.
* **🚜 Equipment & Tool Rentals**:
  * Rent modern machinery (tractors, harvesters, tillers) with transparent daily rates and contact details.
* **🏛️ Government Schemes & Support**:
  * Easy access to agricultural subsidies, loan schemes, crop insurance (PMFBY), and helpline support.
* **🔊 Voice Accessibility & Localization**:
  * Voice read-out (Text-to-Speech) for diagnosis results and advisories.
  * Full interface availability in **English**, **Hindi (हिन्दी)**, and **Marathi (मराठी)**.

---

### 🛡️ Government Officer Portal
* **User & Verification Management**: Onboard and verify local farmers in assigned rural regions.
* **Advisory & Inspection**: Review crop damage reports and issue official regional agricultural advisories.

---

### 👑 Admin Portal
* **Central Dashboard**: Monitor platform metrics including registered farmers, active pest outbreaks, marketplace listings, and soil health records.
* **Content & Scheme Management**: Add, update, and manage government scheme listings, pest advisory alerts, and equipment hub catalogs.

---

## 🛠️ Technology Stack & Architecture

| Layer | Technology / Library | Description |
| :--- | :--- | :--- |
| **Framework** | [Flutter](https://flutter.dev) (Dart 3) | Cross-platform mobile application engine |
| **AI / Machine Learning** | LiteRT (`flutter_litert`) | On-device PyTorch/TFLite model inference (`pest_model_float32.tflite`) |
| **Image Processing** | `image` package | Image resize, normalization (Mean/Std), and center crop transforms |
| **Backend & Auth** | Firebase (Core, Auth, Firestore) | Real-time database, user state, and cloud storage |
| **Local Storage** | `shared_preferences`, Custom `LocalDB` | Offline caching for user sessions and history |
| **Mapping & GPS** | `flutter_map`, `latlong2`, `geolocator`, `geocoding` | Location-based alerts and interactive region mapping |
| **Voice / Accessibility** | `flutter_tts` | Text-To-Speech engine for voice guidance in regional languages |
| **UI Components** | Google Fonts, Material 3, Cupertino Icons | Modern responsive agricultural design system |

---

## 📂 Project Structure

```
krishi_unnati/
├── assets/
│   └── pest_model/
│       ├── pest_model_float32.tflite  # On-device AI classification model
│       └── labels.txt                 # Model class labels
├── lib/
│   ├── main.dart                      # Application entry point & provider initialization
│   ├── data/
│   │   ├── disease_info.dart          # Detailed disease remedies & advisory dataset
│   │   ├── pest_dataset.dart          # Regional pest alert records
│   │   └── maharashtra.dart           # Region-specific agricultural data
│   ├── l10n/
│   │   └── translations.dart          # Multilingual string dictionary (EN, HI, MR)
│   ├── screens/
│   │   ├── farmers/                   # Farmer screens (Crop Health, Marketplace, Soil, Fertilizers, etc.)
│   │   ├── officers/                  # Government Officer screens
│   │   └── admins/                    # Admin Dashboard screens
│   ├── services/
│   │   ├── disease_classifier_service.dart # TFLite model runner & image preprocessor
│   │   ├── firebase_service.dart      # Firebase initialization & operations
│   │   └── local_db.dart              # Shared Preferences & offline cache layer
│   ├── state/
│   │   ├── app_locale.dart            # Language state management
│   │   └── app_session.dart           # Session & Auth state provider
│   ├── welcome/                       # Language selection, onboarding & startup animations
│   └── widgets/                       # Reusable UI components (bottom nav, headers, cards)
└── pubspec.yaml                       # Project dependencies and asset configurations
```

---

## 🧠 AI Crop Health Detection Workflow

1. **Capture/Upload**: Farmer takes a leaf photo or selects an image from gallery.
2. **Preprocessing**: The image is decoded, resized (`_resizeTarget = 255`), and center-cropped (`224x224`), followed by RGB normalization (`mean=[0.485, 0.456, 0.406]`, `std=[0.229, 0.224, 0.225]`).
3. **On-Device Inference**: LiteRT runs the input tensor through `pest_model_float32.tflite` entirely offline.
4. **Post-processing**: Softmax activation yields confidence probabilities across defined pest/disease classes.
5. **Remedy & Voice Advisory**: The app matches predicted class with `disease_info.dart` remedies and provides a voice read-out option using `flutter_tts`.

---

## 🚀 Getting Started

### Prerequisites
* [Flutter SDK](https://docs.flutter.dev/get-started/install) (`>=3.13.0`)
* Android Studio or VS Code with Flutter extensions
* An Android or iOS device / emulator

### Installation Steps

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/your-username/krishi_unnati.git
   cd krishi_unnati
   ```

2. **Install Dependencies**:
   ```bash
   flutter pub get
   ```

3. **Firebase Setup**:
   * Create a project in the [Firebase Console](https://console.firebase.google.com/).
   * Add Android (`google-services.json`) and iOS (`GoogleService-Info.plist`) configuration files to their respective platform directories (`android/app/` and `ios/Runner/`).

4. **Run the Application**:
   ```bash
   flutter run
   ```

---

## 🌐 Localization & Multi-language Support

Krishi Unnati supports seamless language switching dynamically:
* **English**
* **Hindi (हिन्दी)**
* **Marathi (मराठी)**

All text content is mapped dynamically through `AppLocale` state provider and `translations.dart`.

---

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

---

<p align="center">Made with ❤️ for Indian Farmers 🌾</p>
