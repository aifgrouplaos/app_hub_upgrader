# App Hub Upgrader Example

This example demonstrates how to use the `app_hub_upgrader` package to check for app updates and display update dialogs.

## Prerequisites

- Flutter SDK (>=1.17.0)
- Dart SDK (^3.8.1)

## Running the Example

1. **Navigate to the example directory:**

   ```bash
   cd example
   ```

2. **Get the dependencies:**

   ```bash
   flutter pub get
   ```

3. **Update the configuration:**

   - Replace `'your-app-id'` in `lib/main.dart` with your actual app ID
   - Ensure your API endpoint is correctly configured in the package's `api_config.dart` file

4. **Run the example:**

   ```bash
   flutter run
   ```

## Features Demonstrated

- **Automatic Update Check**: Check for updates and automatically show dialog
- **Manual Update Check**: Check for updates without showing dialog automatically
- **Custom Dialog Configuration**: Customize the appearance and behavior of the update dialog
- **Error Handling**: Handle errors gracefully

## Usage in the Example

The example app provides two buttons:

1. **Check for Update (Auto Dialog)**: Checks for updates and automatically shows the dialog if an update is available.

2. **Check Only (Manual Dialog)**: Checks for updates without showing the dialog automatically. You can then manually show the dialog if needed.

## Configuration

Before running, make sure to:

1. **Set your App ID**: Replace `'your-app-id'` in `lib/main.dart` with your actual app ID from your backend/API.

2. **Configure API Endpoint**: Ensure your API endpoint is correctly configured. The package uses default endpoints, but you can modify them in `lib/config/api_config.dart` if needed.

3. **API Response Format**: Make sure your API returns the expected response format. See the [main README.md](../README.md#api-response-format) for details.

## What This Example Demonstrates

- ✅ Automatic update checking with dialog display
- ✅ Manual update checking without auto-dialog
- ✅ Custom dialog configuration
- ✅ Error handling
- ✅ Update information display

## Troubleshooting

- **API Connection Issues**: Check your internet connection and API endpoint configuration
- **No Update Dialog**: Verify your API is returning the correct response format
- **Build Errors**: Make sure all dependencies are installed with `flutter pub get`
