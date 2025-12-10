# Sandwich Shop

A feature-rich Flutter app for ordering sandwiches with full cart management, order history, profile settings, and persistent data storage.

## Features

### Core Functionality
- **Sandwich Customization**: Choose from 4 sandwich types (Veggie Delight, Chicken Teriyaki, Italian BMT, Meatball Marinara)
- **Size Selection**: Toggle between six-inch and footlong sandwiches
- **Bread Options**: Select from white, brown, or wholegrain bread
- **Quantity Management**: Adjust order quantities with + and - buttons

### Cart Management
- **Add to Cart**: Add customized sandwiches with specified quantities
- **View Cart**: See all items with detailed pricing
- **Modify Cart**: Increment/decrement quantities or remove items
- **Live Updates**: Real-time cart summary showing total items and price

### Order Processing
- **Checkout Flow**: Complete order summary with itemized pricing
- **Payment Simulation**: 2-second payment processing simulation
- **Order Confirmation**: Receive order ID and estimated time
- **Order History**: View all past orders with timestamps and totals

### User Features
- **Profile Management**: Save name and preferred location
- **Welcome Messages**: Personalized greetings after profile setup
- **Settings**: Adjustable font size (12-24px) with live preview
- **Persistent Settings**: Font preferences saved across sessions

### Technical Features
- **State Management**: Provider pattern for cart state
- **Database**: SQLite for order history persistence
- **Pricing System**: Repository pattern for price calculations
- **Validation**: Input validation for forms and cart operations
- **Navigation**: Multi-screen navigation with state preservation

## Pricing
- Six-inch sandwich: £6.00
- Footlong sandwich: £11.00
- Prices automatically calculated based on selection

## Platforms Supported
- ✅ Android (release APK available)
- ✅ Windows (requires Visual Studio toolchain)
- ✅ Web
- ✅ iOS/macOS (requires Xcode)

## Install the essential tools

1. **Terminal**:

    - **macOS** – use the built-in Terminal app by pressing **⌘ + Space**, typing **Terminal**, and pressing **Return**.
    - **Windows** – open the start menu using the **Windows** key. Then enter **cmd** to open the **Command Prompt**. Alternatively, you can use **Windows PowerShell** or **Windows Terminal**.

2. **Git** – verify that you have `git` installed by entering `git --version`, in the terminal.
    If this is missing, download the installer from [Git's official site](https://git-scm.com/downloads?utm_source=chatgpt.com).

3. **Package managers**:

    - **Homebrew** (macOS) – verify that you have `brew` installed with `brew --version`; if missing, follow the instructions on the [Homebrew installation page](https://brew.sh/).
    - **Chocolatey** (Windows) – verify that you have `choco` installed with `choco --version`; if missing, follow the instructions on the [Chocolatey installation page](https://chocolatey.org/install).

4. **Flutter SDK** – verify that you have `flutter` installed and it is working with `flutter doctor`; if missing, install it using your package manager:

    - **macOS**: `brew install --cask flutter`
    - **Windows**: `choco install flutter`

5. **Visual Studio Code** – verify that you have `code` installed with `code --version`; if missing, use your package manager to install it:

    - **macOS**: `brew install --cask visual-studio-code`
    - **Windows**: `choco install vscode`

6. **Android Studio** (for Android builds/emulator):
    - Download from [developer.android.com](https://developer.android.com/studio)
    - Install Android SDK and create a virtual device for testing

## Get the code

### If this is your first time working on this project

Enter the following commands in your terminal to clone the repository and
open it in Visual Studio Code.
You may want to change directory (`cd`) to the directory where you want to clone the
repository first.

```bash
git clone --branch 8 https://github.com/manighahrmani/sandwich_shop
cd sandwich_shop
code .
```

### If you have already cloned the repository

Enter the following commands in your terminal to switch to the correct branch.
Remember to `cd` to the directory where you cloned the repository first.

```bash
git fetch origin
git checkout 8
```

## Run the app

### Development Mode

Open the integrated terminal in Visual Studio Code by first opening the Command
Palette with **⌘ + Shift + P** (macOS) or **Ctrl + Shift + P** (Windows) and
typing **Terminal: Create New Terminal** then pressing **Enter**.

In the terminal, run the following commands to install the dependencies and run
the app:

```bash
flutter pub get
flutter run
```

Select your target device when prompted (Chrome for web, emulator for Android, etc.).

### Running on Different Platforms

**Web:**
```bash
flutter run -d chrome
```

**Windows:**
```bash
flutter run -d windows
```

**Android Emulator:**
```bash
# List available devices
flutter devices

# Run on specific device
flutter run -d <device-id>
```

### Building for Production

**Android APK:**
```bash
flutter build apk --release
```
Output: `build/app/outputs/flutter-apk/app-release.apk`

**Android App Bundle (for Play Store):**
```bash
flutter build appbundle --release
```

**Windows:**
```bash
flutter build windows --release
```

**Web:**
```bash
flutter build web --release
```

## Testing

### Unit and Widget Tests
```bash
flutter test
```

### Integration Tests
```bash
# On Android emulator
flutter test integration_test/app_test.dart -d <emulator-id>

# On Windows (requires Developer Mode enabled)
flutter test integration_test/app_test.dart -d windows
```

**Note:** Windows integration tests require Developer Mode to be enabled for symlink support.
Run `start ms-settings:developers` to open settings and enable it.

## Project Structure

```
lib/
├── main.dart                    # App entry point
├── models/                      # Data models
│   ├── cart.dart               # Cart state management
│   ├── sandwich.dart           # Sandwich types and properties
│   └── saved_order.dart        # Order history model
├── repositories/                # Business logic layer
│   └── pricing_repository.dart # Pricing calculations
├── services/                    # External services
│   └── database_service.dart   # SQLite database operations
├── views/                       # UI screens
│   ├── app_styles.dart         # Global styling and theming
│   ├── order_screen.dart       # Main ordering interface
│   ├── cart_screen.dart        # Shopping cart view
│   ├── checkout_screen.dart    # Payment processing
│   ├── order_history_screen.dart # Past orders
│   ├── profile_screen.dart     # User profile
│   └── settings_screen.dart    # App settings
└── widgets/                     # Reusable components
    └── common_widgets.dart     # Shared UI widgets

integration_test/
└── app_test.dart               # Integration tests

test/
└── [unit and widget tests]     # Test files
```

## Dependencies

- **provider**: ^6.1.5 - State management
- **shared_preferences**: ^2.5.3 - Settings persistence
- **sqflite**: ^2.4.2 - SQLite database
- **path**: ^1.9.1 - Path manipulation
- **integration_test**: SDK - Integration testing

## Release Information

**Current Version:** 1.0.0+1

**Release Build:** Available as `app-release.apk` (87.8 MB)
- Optimized for production
- Tree-shaken assets (99.8% reduction in icon size)
- Ready for distribution

## Get support

Use [the dedicated Discord channel](https://discord.com/channels/760155974467059762/1370633732779933806)
to ask your questions and get help from the community.
Please provide as much context as possible, including the error messages you are seeing and
screenshots (you can open Discord in your web browser).
