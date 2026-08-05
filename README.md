# Newschool

**kurdish new generate school.**

A comprehensive educational Flutter application offering video lessons, webinars, document viewing, and a robust set of features for an engaging learning experience.

## 🚀 Key Features

*   **Video Playback & Webinars**: High-quality video delivery using `vimeo_player_flutter`, `video_player`, `chewie`, and `pod_player`.
*   **Document & PDF Viewer**: Integrated document reading with `syncfusion_flutter_pdfviewer`.
*   **Authentication**: Secure login and sign-up with `google_sign_in`, `flutter_facebook_auth`, `sign_in_with_apple`, and `firebase_auth`.
*   **Offline Support & Caching**: Efficient local data storage using `hive` and `shared_preferences`.
*   **Push Notifications**: Real-time updates and alerts powered by `firebase_messaging` and `flutter_local_notifications`.
*   **Interactive UI**: Beautiful and engaging interfaces with `fl_chart` for statistics, `table_calendar` for scheduling, and `lottie` animations.
*   **Multi-language Support**: Internationalization (i18n) support out of the box using the `intl` package and custom fonts (SF-Pro and Vazir).

## 🛠 Prerequisites

Before you begin, ensure you have met the following requirements:
*   [Flutter SDK](https://flutter.dev/docs/get-started/install) (`>=3.1.5 <4.0.0`)
*   Dart SDK
*   Android Studio / Xcode for platform-specific builds

## 📦 Installation

1.  **Clone the repository:**
    ```bash
    git clone <repository_url>
    cd newschool
    ```

2.  **Install dependencies:**
    ```bash
    flutter pub get
    ```

3.  **Run code generation (if applicable):**
    ```bash
    flutter pub run build_runner build --delete-conflicting-outputs
    ```

4.  **Run the app:**
    ```bash
    flutter run
    ```

## 🏗 Architecture & Core Libraries

*   **State Management:** `provider`, `get_it`
*   **Networking:** `dio`, `http`
*   **Storage:** `hive`, `shared_preferences`
*   **Web Views:** `flutter_inappwebview`, `webview_flutter`, `flutter_widget_from_html`

## 🎨 Assets & Fonts

The application uses custom assets, including standard UI icons, flags, and specific fonts to support various languages, specifically **SF-Pro** for English and **Vazir** for Kurdish/Persian typography.

## 📄 License

This project is not licensed for public distribution (Private Package).
