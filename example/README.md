# App Hub Upgrader Example

This example demonstrates how to use the `app_hub_upgrader` package to check for app updates and display update dialogs.

## Running the Example

1. Make sure you have Flutter installed and configured.

2. Navigate to the example directory:

   ```bash
   cd example
   ```

3. Get the dependencies:

   ```bash
   flutter pub get
   ```

4. Update the `appID` in `lib/main.dart` with your actual app ID.

5. Run the example:
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

1. Replace `'your-app-id'` in `lib/main.dart` with your actual app ID.
2. Ensure your API endpoint is correctly configured in the package's `api_config.dart` file.
3. Make sure your API returns the expected response format (see main README.md).
