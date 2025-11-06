# Aura - Health & Fitness Companion

A modern Flutter health and fitness app with a calm, minimal lavender theme.

## Features

- **Welcome Screen**: Beautiful onboarding experience
- **Setup Page**: Terms and conditions with user consent
- **Dashboard**: Track daily wellness metrics
  - Steps tracking
  - Water intake monitoring
  - Cycle progress
  - Gut health logging
- **Personalized Insights**: AI-driven health recommendations
- **Bottom Navigation**: Easy access to Home, Stats, Profile, and Chats

## Design

- Material 3 design system
- Lavender (#A78BFA) color palette
- Google Fonts (Poppins)
- Smooth page transitions
- Responsive layout for all screen sizes

## Getting Started

### Prerequisites

- Flutter SDK (3.0.0 or higher)
- Dart SDK
- Android Studio / Xcode for mobile development

### Installation

1. Clone the repository
2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

## Project Structure

```
lib/
├── main.dart              # App entry point
├── theme/
│   └── app_colors.dart    # Color definitions
├── screens/
│   ├── welcome_page.dart  # Welcome screen
│   ├── setup_page.dart    # Setup/terms screen
│   └── dashboard_page.dart # Main dashboard
└── widgets/
    └── health_card.dart   # Reusable health metric card
```

## Future Enhancements

- Supabase integration for data persistence
- Real-time health tracking
- Advanced analytics and charts
- Social features and challenges
- Push notifications for reminders
