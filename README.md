# Tirono Technologies Flutter Task

A comprehensive Flutter application demonstrating modern mobile development practices, including robust authentication, role-based access control, and location services.

## Demo Video

<video width="100%" controls>
  <source src="https://github.com/oliulhasnat/tirono_flutter_task/raw/main/media/demo.mp4" type="video/mp4">
  Your browser does not support the video tag.
</video>

## Features

- **Advanced Authentication**: 
  - Email & Password Login/Signup.
  - Role-based registration (Doctor & Patient).
  - Form validation with error handling.

- **Role-Based Access Control**:
  - Distinct worklows for Doctors and Patients.
  - Dynamic UI adjustments based on selected role.

- **Location Services**:
  - Integrated geolocation features using `geolocator`.
  - Geocoding support.

- **Modern Architecture**:
  - **State Management**: Built with [Flutter Riverpod](https://pub.dev/packages/flutter_riverpod) for scalable and testable state management.
  - **Routing**: Uses [GoRouter](https://pub.dev/packages/go_router) for declarative routing.
  - **Networking**: Implemented with [Dio](https://pub.dev/packages/dio).
  - **Responsive Design**: Utilizes `flutter_screenutil` for pixel-perfect UI across devices.

## Tech Stack

- **Framework**: Flutter
- **Language**: Dart
- **State Management**: Riverpod
- **Navigation**: GoRouter
- **Maps/Location**: Geolocator, Geocoding
- **UI Components**: `on_process_button_widget`, `on_text_input_widget`, `flutter_svg`, `google_fonts`

## Getting Started

This project is a starting point for a Flutter application.

### Prerequisites
- Flutter SDK
- Android Studio / Xcode (for mobile development)

### Installation

1.  **Clone the repository**:
    ```bash
    git clone <repository-url>
    ```

2.  **Install dependencies**:
    ```bash
    flutter pub get
    ```

3.  **Run the app**:
    ```bash
    flutter run
    ```

## Resources

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
