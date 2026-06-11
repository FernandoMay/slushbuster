# SlushBuster

A modern e-commerce Flutter application with rich animations and a smooth shopping experience.

Built with **Flutter**, **BLoC** state management, and a vibrant **Pink** brand identity.

## Features

- Product catalog with search and grid/featured views
- Shopping cart with quantity management
- Product detail pages with add-to-cart
- Dark mode support
- Responsive UI with Material Design 3

## Stack

| Layer | Technology |
|-------|-----------|
| **Framework** | Flutter (SDK >=3.0.0) |
| **State Management** | flutter_bloc + bloc |
| **Animations** | Lottie, AnimateDo, Shimmer |
| **UI Components** | Flutter Rating Bar, Carousel Slider, Flutter Slidable, Staggered Grid |
| **Networking & Storage** | cached_network_image, shared_preferences |
| **Theming** | Google Fonts, Material 3, ColorScheme.fromSeed |

## Quick Start

```bash
# Install dependencies
flutter pub get

# Run the app
flutter run

# Analyze code
flutter analyze

# Run tests
flutter test
```

## CI/CD

This project uses GitHub Actions for continuous integration:

- **Analyze** — `flutter analyze` for code quality
- **Test** — `flutter test` for unit & widget tests
- **Build** — `flutter build apk --release` for Android release

On every push/PR to `main` or `master`, the full pipeline runs automatically.

## Project Structure

```
lib/
  main.dart              — App entry point and BLoC providers
  home.dart              — Product listing with search
  productpage.dart       — Product detail page
  cart.dart              — Shopping cart UI
  cartbloc.dart          — Cart BLoC (state management)
  models.dart            — Product, Cart, CartItem entities
  config/
    constants/
      app_constants.dart  — App-wide constants
    theme/
      app_theme.dart      — Material 3 theme with pink seed color
```

## Brand

- **Name:** SlushBuster
- **Primary Color:** Pink (#FF4081)
- **Theme:** Material Design 3 (useMaterial3: true)
- **Color Scheme:** Auto-generated via `ColorScheme.fromSeed`
