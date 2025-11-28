# App Hub Upgrader

[![pub package](https://img.shields.io/pub/v/app_hub_upgrader.svg)](https://pub.dev/packages/app_hub_upgrader)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![GitHub](https://img.shields.io/github/stars/aifgrouplaos/app_hub_upgrader?style=social)](https://github.com/aifgrouplaos/app_hub_upgrader)

A Flutter package for checking app version updates from an API and displaying a customizable update dialog to users.

## Table of Contents

- [Features](#features)
- [Installation](#installation)
- [Usage](#usage)
  - [Quick Start](#quick-start)
  - [Initialization](#initialization)
  - [Step-by-Step Integration](#step-by-step-integration)
  - [Common Use Cases](#common-use-cases)
  - [Advanced Configuration](#advanced-configuration)
- [API Response Format](#api-response-format)
- [API Configuration](#api-configuration)
- [UpdateDialog Widget](#updatedialog-widget)
- [Models](#models)
- [Error Handling](#error-handling)
- [Forced Updates](#forced-updates)
- [Platform Support](#platform-support)
- [Versioning](#versioning)
- [Example](#example)
- [License](#license)
- [Contributing](#contributing)

## Features

- ✅ Check for app updates from API
- ✅ Automatic version detection using `package_info_plus`
- ✅ Customizable update dialog with changelog display
- ✅ Support for forced updates
- ✅ Platform-specific version checking (Android/iOS)
- ✅ Easy to integrate and use

## Installation

### From pub.dev (Recommended)

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  app_hub_upgrader: ^1.0.1
```

Then run:

```bash
flutter pub get
```

**Note:** When using git, make sure to specify a tag (e.g., `v1.0.1`) for stable versions, or use a branch name for development versions.

## Usage

### Quick Start

**Step 1: Initialize AppHubUpgrader (Recommended)**

Initialize once in your `main()` function:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize AppHubUpgrader with global parameters
  AppHubUpgrader.initialize(
    appID: 'your-app-id',
    navigatorKey: MyApp.navigatorKey,
    useProduction: true,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'My App',
      home: MyHomePage(),
    );
  }
}
```

**Step 2: Use AppHubUpgrader**

After initialization, create instances without parameters:

```dart
// Create instance using initialized values
final upgrader = AppHubUpgrader();

// Check for updates (no context needed!)
await upgrader.checkForUpdate();
```

**Alternative: Without Initialization**

You can also use AppHubUpgrader without calling `initialize()`:

```dart
final upgrader = AppHubUpgrader(
  appID: 'your-app-id',
  navigatorKey: MyApp.navigatorKey, // Recommended
  useProduction: true,
);

await upgrader.checkForUpdate();
```

That's it! The package will automatically check for updates and show a dialog if a new version is available.

### Initialization

The `AppHubUpgrader.initialize()` method allows you to set global parameters once, then create instances without passing them each time.

#### Benefits of Initialization

- **Cleaner code**: No need to pass `appID` and `navigatorKey` every time
- **Centralized configuration**: Manage all settings in one place
- **Easier maintenance**: Update configuration in one location

#### Initialize in main()

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize once with all parameters
  AppHubUpgrader.initialize(
    appID: 'your-app-id',
    navigatorKey: MyApp.navigatorKey,
    useProduction: true,
    dialogConfig: UpdateDialogConfig(
      title: 'Update Available',
      updateButtonText: 'Update Now',
      laterButtonText: 'Maybe Later',
    ),
  );

  runApp(MyApp());
}
```

#### Use After Initialization

After calling `initialize()`, you can create instances without parameters:

```dart
// Simple - uses all initialized values
final upgrader = AppHubUpgrader();
await upgrader.checkForUpdate();

// Override specific values if needed
final devUpgrader = AppHubUpgrader(useProduction: false);
```

#### Check Initialization Status

```dart
if (AppHubUpgrader.isInitialized) {
  print('App ID: ${AppHubUpgrader.initializedAppID}');
}
```

### Step-by-Step Integration

#### Step 1: Initialize in Your App's Entry Point

Initialize AppHubUpgrader in your `main()` function:

```dart
import 'package:app_hub_upgrader/app_hub_upgrader.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize AppHubUpgrader
  AppHubUpgrader.initialize(
    appID: 'your-app-id', // Get this from your backend/API
    navigatorKey: MyApp.navigatorKey,
    useProduction: true,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Global navigator key for showing dialogs
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'My App',
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late AppHubUpgrader _upgrader;

  @override
  void initState() {
    super.initState();

    // Create instance using initialized values (no parameters needed!)
    _upgrader = AppHubUpgrader();

    // Check for updates after the first frame is rendered
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkForUpdates();
    });
  }

  Future<void> _checkForUpdates() async {
    try {
      await _upgrader.checkForUpdate();
    } catch (e) {
      // Handle errors silently or show a message
      debugPrint('Update check failed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My App')),
      body: const Center(
        child: Text('Welcome to My App'),
      ),
    );
  }
}
```

#### Step 2: Customize the Update Dialog (Optional)

You can customize the appearance and behavior of the update dialog:

```dart
final upgrader = AppHubUpgrader(
  appID: 'your-app-id',
  context: context,
  useProduction: true,
  dialogConfig: UpdateDialogConfig(
    // Customize dialog text
    title: 'New Version Available!',
    updateButtonText: 'Update Now',
    laterButtonText: 'Maybe Later',

    // Customize colors
    primaryColor: Colors.blue,
    backgroundColor: Colors.white,

    // Customize icon
    customIcon: const Icon(
      Icons.cloud_download,
      size: 64,
      color: Colors.blue,
    ),

    // Add callbacks
    onUpdate: () {
      debugPrint('User clicked update button');
      // You can add analytics tracking here
    },
    onLater: () {
      debugPrint('User clicked later button');
      // You can add analytics tracking here
    },
  ),
);

await upgrader.checkForUpdate();
```

### Common Use Cases

#### Use Case 1: Check on App Launch (Recommended)

Initialize in `main()` and check for updates when the app starts:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  AppHubUpgrader.initialize(
    appID: 'your-app-id',
    navigatorKey: MyApp.navigatorKey,
  );

  runApp(MyApp());
}

@override
void initState() {
  super.initState();
  final upgrader = AppHubUpgrader(); // Uses initialized values

  WidgetsBinding.instance.addPostFrameCallback((_) {
    upgrader.checkForUpdate();
  });
}
```

#### Use Case 2: Check on Button Tap

Allow users to manually check for updates:

```dart
ElevatedButton(
  onPressed: () async {
    final upgrader = AppHubUpgrader(); // Uses initialized values
    await upgrader.checkForUpdate();
  },
  child: const Text('Check for Updates'),
)
```

#### Use Case 3: Check Periodically

Check for updates at regular intervals:

```dart
Timer.periodic(const Duration(hours: 24), (timer) async {
  final upgrader = AppHubUpgrader(); // Uses initialized values
  await upgrader.checkForUpdate();
});
```

#### Use Case 4: Check Without Auto-Dialog

Check for updates and handle the result manually:

```dart
final upgrader = AppHubUpgrader(); // Uses initialized values

// Check without showing dialog automatically
final updateInfo = await upgrader.checkForUpdate(
  checkOnly: true, // Don't show dialog automatically
);

if (updateInfo?.updateAvailable == true) {
  // Custom logic based on update info
  if (updateInfo!.isForced) {
    // Show custom forced update UI
    await upgrader.showUpdateDialog(updateInfo); // context optional when using navigatorKey
  } else {
    // Show custom optional update UI
    _showCustomUpdateNotification(updateInfo);
  }
} else {
  // No update available
  if (mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('You are using the latest version!')),
    );
  }
}
```

#### Use Case 5: Manual Version and Platform Specification

Override automatic detection:

```dart
final upgrader = AppHubUpgrader(); // Uses initialized values

final updateInfo = await upgrader.checkForUpdate(
  currentVersion: '1.0.0', // Override auto-detected version
  platform: 'android',     // Override auto-detected platform
);
```

### Advanced Configuration

#### Using Development API

Switch to development API for testing:

```dart
// Option 1: Override in instance
final upgrader = AppHubUpgrader(
  useProduction: false, // Override initialized value
);

// Option 2: Initialize with development API
AppHubUpgrader.initialize(
  appID: 'your-app-id',
  navigatorKey: MyApp.navigatorKey,
  useProduction: false, // Use development API
);
```

#### Error Handling

Handle errors gracefully:

```dart
try {
  await upgrader.checkForUpdate();
} on AppException catch (e) {
  // Handle API errors
  debugPrint('Update check failed: ${e.message} (${e.statusCode})');

  if (e.statusCode == 404) {
    // No update endpoint found
  } else if (e.statusCode >= 500) {
    // Server error
  }
} catch (e) {
  // Handle other errors
  debugPrint('Unexpected error: $e');
}
```

#### Using UpdateDialog Independently

You can use the `UpdateDialog` widget directly if you have your own update checking logic:

```dart
// After getting UpdateInfo from your own API call
showDialog(
  context: context,
  barrierDismissible: !updateInfo.isForced,
  builder: (context) => UpdateDialog(
    updateInfo: updateInfo,
    title: 'Update Required',
    updateButtonText: 'Update Now',
    laterButtonText: 'Later',
    primaryColor: Colors.blue,
  ),
);
```

## API Response Format

The package expects the API to return a response in the following format:

```json
{
  "status_code": 200,
  "is_success": true,
  "message": "Success",
  "data": {
    "updateAvailable": true,
    "latestVersion": "1.2.0",
    "currentVersion": "1.1.0",
    "isForced": false,
    "downloadURL": "https://play.google.com/store/apps/details?id=com.example.app",
    "changelog": {
      "fixes": [
        "Fixed bug in login screen",
        "Improved performance",
        "Added new features"
      ]
    },
    "releaseDate": "2024-01-15"
  }
}
```

The package will automatically fall back to these defaults if:

- `.env` file is not found
- `AppHubUpgrader.initialize()` is not called
- Environment variables are not set

### Alternative: Modify api_config.dart

You can also modify the default URLs directly in `lib/config/api_config.dart` if you prefer not to use `.env` files.

## API Parameters

The package sends the following query parameters to the API:

- `app_id`: Your application ID
- `current_version`: Current app version (auto-detected or manually provided)
- `platform`: Platform name (`android` or `ios`, auto-detected)

## UpdateDialog Widget

The `UpdateDialog` widget can be used independently if needed. The `isForced` property is automatically read from `updateInfo.isForced`:

```dart
showDialog(
  context: context,
  barrierDismissible: !updateInfo.isForced, // Prevent dismissal for forced updates
  builder: (context) => UpdateDialog(
    updateInfo: updateInfo, // isForced is read from here
    title: 'Update Required',
    updateButtonText: 'Update Now',
    laterButtonText: 'Later',
    primaryColor: Colors.blue,
  ),
);
```

## UpdateDialogConfig Properties

| Property           | Type            | Description                                         |
| ------------------ | --------------- | --------------------------------------------------- |
| `title`            | `String?`       | Custom title for the dialog                         |
| `updateButtonText` | `String?`       | Text for the update button                          |
| `laterButtonText`  | `String?`       | Text for the later button (hidden if forced update) |
| `onUpdate`         | `VoidCallback?` | Callback when update button is clicked              |
| `onLater`          | `VoidCallback?` | Callback when later button is clicked               |
| `primaryColor`     | `Color?`        | Primary color for buttons and icon                  |
| `backgroundColor`  | `Color?`        | Background color of the dialog                      |
| `titleStyle`       | `TextStyle?`    | Custom style for the title                          |
| `contentStyle`     | `TextStyle?`    | Custom style for content text                       |
| `customIcon`       | `Widget?`       | Custom icon widget                                  |

## Models

### UpdateInfo

Contains information about available updates:

```dart
class UpdateInfo {
  final bool updateAvailable;
  final String? latestVersion;
  final String? currentVersion;
  final bool isForced;
  final String? downloadURL;
  final Changelog? changelog;
  final String? releaseDate;
}
```

### Changelog

Contains changelog information:

```dart
class Changelog {
  final List<String> fixes;
}
```

## Error Handling

The package throws `AppException` when API calls fail. You can catch and handle these:

```dart
try {
  await upgrader.checkForUpdate();
} on AppException catch (e) {
  print('Error: ${e.message} (Status: ${e.statusCode})');
} catch (e) {
  print('Unexpected error: $e');
}
```

## Forced Updates

When `isForced` is `true`:

- The dialog cannot be dismissed by tapping outside
- The "Later" button is hidden
- Users must update to continue using the app

## Platform Support

- ✅ Android
- ✅ iOS

## Dependencies

This package depends on the following:

- `http: ^1.6.0` - For making API requests
- `package_info_plus: ^9.0.0` - For getting app version information
- `url_launcher: ^6.3.1` - For opening download URLs

All dependencies are automatically installed when you add this package to your project.

## Example

See the `example` folder for a complete working example.

## Versioning

This package follows [Semantic Versioning](https://semver.org/). The current version is `1.0.1`.

For version history, see [CHANGELOG.md](CHANGELOG.md).

## License

See the `LICENSE` file for details.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## Related Documentation

- [Git Versioning Guide](GIT_VERSIONING.md) - How to version the package with git tags
- [Quick Tag Guide](QUICK_TAG_GUIDE.md) - Quick reference for creating release tags
