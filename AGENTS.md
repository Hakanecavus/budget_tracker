# AGENTS.md

This file contains instructions for agentic coding agents working on the budget_tracker Flutter app. It includes build/lint/test commands and code style guidelines to ensure consistency and quality.

## Overview

The budget_tracker is a Flutter mobile application for tracking personal finances with international support. It allows users to:

**Core Features:**
- Create color-coded categories for income and expenses (with type classification)
- Add transactions (income/expense) linked to categories and dates
- View transactions on a localized calendar with color-coded markers
- See total income, expenses, and balance at the top of the calendar
- Swipe-to-delete transactions and categories with confirmation dialogs

**Advanced Features:**
- **Reports Screen**: Pie chart visualizations for income vs expense breakdowns
- **Theme Support**: Light, dark, and system theme modes
- **Multi-language**: English, Spanish, and Turkish localization
- **Calendar Integration**: Localized date formatting and selection
- **Data Persistence**: Local storage with SharedPreferences

The app uses Provider for state management, SharedPreferences for persistence, fl_chart for visualizations, and flutter_localizations for internationalization.

## Build/Lint/Test Commands

### Dependencies
- `flutter pub get`: Install all project dependencies from pubspec.yaml
- `flutter pub upgrade`: Upgrade dependencies to their latest compatible versions
- `flutter pub outdated`: Check for outdated dependencies
- **Key Dependencies:**
  - `provider`: State management
  - `shared_preferences`: Local data persistence
  - `table_calendar`: Calendar widget with localization
  - `fl_chart`: Chart visualizations
  - `flutter_localizations`: Internationalization support
  - `intl`: Date/time formatting and localization

### Running the App
- `flutter run`: Run the app in debug mode on the default device
- `flutter run -d <device_id>`: Run on a specific device (e.g., `flutter run -d chrome` for web)
- `flutter run --release`: Run in release mode
- `flutter run --profile`: Run in profile mode for performance analysis

### Building
- `flutter build apk`: Build an APK for Android
- `flutter build ios`: Build for iOS (requires macOS)
- `flutter build web`: Build for web deployment
- `flutter build windows`: Build for Windows desktop
- `flutter build linux`: Build for Linux desktop
- `flutter build macos`: Build for macOS

### Testing
- `flutter test`: Run all unit and widget tests
- `flutter test test/specific_test.dart`: Run a single test file (replace `specific_test.dart` with the actual filename)
- `flutter test --coverage`: Run tests and generate coverage report
- `flutter test --update-goldens`: Update golden test images
- `flutter test --tags <tag>`: Run tests with specific tags

### Linting and Code Quality
- `flutter analyze`: Run static analysis to check for errors, warnings, and lint violations
- `flutter format .`: Automatically format all Dart files in the project
- `flutter format lib/`: Format only the lib directory
- `dart fix --apply`: Automatically apply available fixes for lint violations
- `dart fix --dry-run`: Preview fixes without applying them

### Cleaning
- `flutter clean`: Remove build artifacts and cached files
- `flutter pub cache clean`: Clean the pub cache

## Code Style Guidelines

### General Principles
- Follow the official [Dart style guide](https://dart.dev/guides/language/effective-dart)
- Use the flutter_lints package for consistent linting rules
- Write readable, maintainable code with clear intent
- Prefer composition over inheritance
- Keep methods short and focused on a single responsibility
- Use meaningful, descriptive names for variables, methods, and classes

### Project Structure
- `lib/main.dart`: App entry point with localization and theme setup
- `lib/models/`: Data model classes (`category.dart`, `transaction.dart`)
- `lib/providers/`: State management using Provider:
  - `category_provider.dart`: Category CRUD operations
  - `transaction_provider.dart`: Transaction management and calculations
  - `theme_provider.dart`: Theme mode management
  - `locale_provider.dart`: Language/locale management
- `lib/screens/`: UI screens/pages:
  - `main_screen.dart`: Bottom navigation container
  - `home_screen.dart`: Calendar view with transactions
  - `category_screen.dart`: Category management
  - `reports_screen.dart`: Chart visualizations
  - `settings_screen.dart`: App settings (theme, language)
  - `add_transaction_screen.dart`: Transaction creation form
- `lib/l10n/`: Localization files (generated from ARB files)
- `test/`: Unit and widget tests
- Follow the established directory structure; create new directories as needed

### Imports
- Use relative imports for files within the lib/ directory: `import '../models/category.dart';`
- Use package imports for external dependencies: `import 'package:provider/provider.dart';`
- Group imports in this order:
  1. Dart standard library imports
  2. Package imports (third-party)
  3. Relative imports
- Add empty lines between import groups for readability
- Avoid wildcard imports (`import 'package:some_package/some_file.dart';`) except for Flutter material icons

### Naming Conventions
- **Classes**: PascalCase (e.g., `CategoryProvider`, `HomeScreen`)
- **Variables and methods**: camelCase (e.g., `totalIncome`, `addTransaction()`)
- **Constants**: UPPER_SNAKE_CASE (e.g., `CATEGORY_KEY`)
- **Files**: snake_case (e.g., `category_provider.dart`, `add_transaction_screen.dart`)
- **Enums**: PascalCase for the enum name, camelCase for values (e.g., `enum TransactionType { income, expense }`)
- Use nouns for classes, verbs for methods, and descriptive phrases for variables

### Types and Type Annotations
- Always specify explicit types for:
  - Class properties
  - Method parameters and return types
  - Local variables (except when the type is obvious)
- Use `var` only when the type is immediately clear from the initializer
- Prefer `final` over `var` for variables that don't change
- Use `const` for compile-time constants and immutable collections
- Avoid `dynamic` unless absolutely necessary; prefer specific types

### Formatting
- Use `flutter format` to automatically format code
- Line length: Aim for 80 characters, but allow up to 120 for readability
- Indentation: 2 spaces (handled automatically by formatter)
- Use trailing commas in multi-line parameter lists and collections for cleaner diffs

### Error Handling
- Use try-catch blocks for operations that can throw exceptions (e.g., network calls, file I/O)
- Provide meaningful error messages to users when possible
- Use assertions (`assert`) for development-time checks and preconditions
- Avoid empty catch blocks; always handle or rethrow exceptions appropriately
- Use custom exceptions for business logic errors

### State Management
- Use Provider for state management as established in the project
- **Providers:**
  - `CategoryProvider`: Category CRUD operations and default "Unknown" categories
  - `TransactionProvider`: Transaction management, calculations (totals, balance)
  - `ThemeProvider`: Theme mode persistence and management
  - `LocaleProvider`: Language/locale selection and persistence
- Notify listeners only when necessary to avoid unnecessary rebuilds
- Use `Consumer` widgets or `context.watch`/`context.read` appropriately
- Keep providers focused on data management, not UI logic
- Persist user preferences (theme, language) using SharedPreferences

### Models and Data Classes
- Define data models in the `lib/models/` directory
- Use classes with immutable properties where possible
- Implement `toJson()` and `fromJson()` methods for serialization
- Use factory constructors for complex object creation
- Override `toString()`, `==`, and `hashCode` when appropriate

### Widgets and UI
- Prefer `StatelessWidget` over `StatefulWidget` when possible
- Use `const` constructors for widgets that don't depend on runtime values
- Separate UI building from business logic
- Use meaningful keys for widgets that need to be identified in tests
- Follow Material Design guidelines
- Use `Theme.of(context)` for consistent theming
- Support light, dark, and system theme modes
- Handle different screen sizes with `MediaQuery` or responsive layouts
- **Charts:** Use `fl_chart` for pie chart visualizations with category colors
- **Navigation:** Bottom navigation bar with 4 tabs (Home, Categories, Reports, Settings)
- **Gestures:** Swipe-to-delete with confirmation dialogs for transactions and categories

### Internationalization (i18n)
- Use `flutter_localizations` for multi-language support
- Supported languages: English (en), Spanish (es), Turkish (tr)
- Localization files in `lib/l10n/` generated from ARB files
- Use `AppLocalizations.of(context)!` to access localized strings
- Calendar and date formatting automatically adapts to selected locale
- **Important:** Place `GlobalMaterialLocalizations.delegate` FIRST in localizationsDelegates to ensure Material Icons load properly

### Asynchronous Programming
- Use `async`/`await` for asynchronous operations
- Avoid `Future.then()` chains; prefer `await`
- Handle errors in async functions with try-catch
- Use `Future.microtask()` or `WidgetsBinding.instance.addPostFrameCallback()` for operations that need to run after build
- Be cautious with `setState` in async operations to avoid calling it on disposed widgets

### Testing
- Write unit tests for business logic (providers, models)
- Write widget tests for UI components and user interactions
- Use descriptive test names that explain the behavior being tested
- Use `setUp` and `tearDown` for test preparation and cleanup
- Mock external dependencies (e.g., SharedPreferences) in tests
- Aim for good test coverage, especially for critical paths
- Test error conditions and edge cases

### Performance Considerations
- Use `const` widgets to avoid unnecessary rebuilds
- Use `ListView.builder` or similar for large lists
- Avoid expensive operations in `build` methods
- Use `memoization` or caching for expensive computations
- Profile the app regularly with `flutter run --profile`

### Security
- Never log sensitive information (passwords, API keys, personal data)
- Use secure storage (flutter_secure_storage) for sensitive data if needed
- Validate user inputs to prevent injection attacks
- Keep dependencies updated to address security vulnerabilities
- Follow Flutter security best practices

### Documentation
- Add doc comments (`///`) for public APIs (classes, methods, properties)
- Keep comments concise and focused on the "why" rather than "what"
- Update documentation when changing public interfaces
- Use TODO comments for temporary code that needs attention

### Version Control
- Commit frequently with clear, descriptive messages
- Use conventional commit format: `type(scope): description`
- Keep commits focused on single changes
- Use feature branches for new features
- Write meaningful pull request descriptions

## Cursor Rules

No Cursor rules found in `.cursor/rules/` or `.cursorrules`.

## Localization Setup

The app supports internationalization with ARB files:
- `lib/l10n/app_en.arb`: English translations
- `lib/l10n/app_es.arb`: Spanish translations
- `lib/l10n/app_tr.arb`: Turkish translations

Generated localization classes are in `lib/l10n/app_localizations*.dart`. Run `flutter gen-l10n` after updating ARB files.

## Additional Notes

- **Localization Setup:** When adding new strings, update all ARB files (`app_en.arb`, `app_es.arb`, `app_tr.arb`) and run `flutter gen-l10n`
- **Material Icons:** Ensure `GlobalMaterialLocalizations.delegate` is listed FIRST in localizationsDelegates to prevent icon loading issues
- **Theme Support:** Test UI in both light and dark modes; use `Theme.of(context)` for consistent theming
- **Chart Colors:** Category colors are used for chart segments; ensure good contrast for readability
- **Data Persistence:** User preferences (theme, language) are automatically saved and restored
- Always run `flutter analyze` before committing code
- Test on multiple devices/platforms when possible, especially localization and theming
- Keep the pubspec.yaml dependencies minimal and up-to-date
- Follow semantic versioning for any published packages
- Document any new patterns or conventions introduced in this file