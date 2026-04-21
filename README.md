![Flutter CI](https://github.com/AnaghaSreedharan/flutter-weather-app-bloc-clean-architecture/actions/workflows/flutter_ci.yml/badge.svg)
# 🌤️ Weather App

A Flutter weather application demonstrating Clean Architecture and BLoC pattern.

## 📐 Architecture

- **Presentation Layer** — BLoC (Events, States, BlocBuilder)
- **Domain Layer** — Entities, Repository Interface, Use Cases
- **Data Layer** — Repository Implementation, Remote Data Source

## ✨ Features

- Search weather by city name
- Real-time temperature and description
- Error handling for invalid cities
- Unit tested with mocktail

## 🛠️ Tech Stack

- Flutter & Dart
- BLoC for state management
- Clean Architecture
- REST API (OpenWeatherMap)
- Unit Testing (flutter_test, mocktail, bloc_test)

## 🧪 Running Tests

```bash
flutter test
```

## 📁 Folder Structure

```
lib/
├── core/
├── features/
│   └── weather/
│       ├── data/
│       ├── domain/
│       └── presentation/
└── main.dart
```