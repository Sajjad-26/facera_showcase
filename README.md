# Facera AI - Technical Showcase

![Facera AI Banner](assets/images/finallogo.jpg)

**Note: This repository is a technical showcase. It contains a subset of the production code for demonstration purposes.**

## 📱 Project Overview

Facera AI is a Flutter-based application that analyzes facial features using advanced geometry and machine learning to provide actionable aesthetic advice ("looksmaxxing"). The app uses on-device face mesh detection to calculate metrics like jawline definition, symmetry, and facial width-to-height ratio (fWHR).

**This public repository limits the scope to:**
*   **Architecture & State Management**: Clean Architecture principles with a service-based integration layer.
*   **UI/UX Implementation**: High-fidelity, smooth animations, and premium dark-mode aesthetics.
*   **Service Abstraction**: Demonstrating how external APIs (Firebase, RevenueCat, ML Kit) are abstracted behind interfaces.

## 🛠 Tech Stack

*   **Framework**: Flutter (Dart)
*   **Architecture**: Modular / Feature-first
*   **Styling**: Custom `ThemeData` based on Google Fonts (Outfit) and CSS-like gradients.
*   **Animations**: `flutter_animate` for complex sequenced animations.
*   **Local Storage**: `shared_preferences` for persistence (mocking cloud sync).

## 🏗 Architecture Structure

The project follows a feature-driven structure:

```
lib/
├── core/               # Shared logic, services, and utilities
│   ├── services/       # Mocked for this showcase (Auth, Subscription, Analysis)
│   ├── theme/          # App-wide visual identity (colors, typography)
│   ├── ui/             # Reusable widgets (GlassContainer, etc.)
│   └── utils/          # Math & geometry logic (FaceMathUtils)
├── features/           # Feature-specific code
│   ├── analysis/       # Facial analysis logic & models
│   ├── auth/           # Login/Signup UI (Mocked Auth)
│   ├── home/           # Navigation & Dashboard
│   ├── onboarding/     # Welcome/Intro screens
│   └── profile/        # User settings
└── main.dart           # Entry point
```

## 🔒 Security & Privacy

This repository has been strictly sanitized:
*   **No API Keys**: All RevenueCat/Firebase keys have been removed.
*   **Mocked Services**: `AuthService`, `SubscriptionService`, and `AnalysisService` return simulated data to demonstrate the UI flow without requiring backend access.
*   **No Proprietary Algorithms**: The core ML model integration has been replaced with a mock implementation (`AnalysisService`).

## 🚀 Getting Started

1.  **Clone the repository**
2.  **Install dependencies**:
    ```bash
    flutter pub get
    ```
3.  **Run the app**:
    ```bash
    flutter run
    ```
    *Note: The app runs in "Mock Mode". Login works with any credentials, and scanning simulates a result.*

## 📸 Screenshots

*(Placeholder for screenshots of the Welcome Screen, Home Screen, and Analysis Results)*

---
*Developed by Sajjad. Contact for full implementation details.*
