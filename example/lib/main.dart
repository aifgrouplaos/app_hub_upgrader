import 'package:app_hub_upgrader/app_hub_upgrader.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Hub Upgrader Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
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
  UpdateInfo? _updateInfo;
  bool _isChecking = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _upgrader = AppHubUpgrader(
      appID: 'your-app-id', // Replace with your actual app ID
      context: context,
      useProduction: true,
      dialogConfig: UpdateDialogConfig(
        title: 'New Version Available!',
        updateButtonText: 'Update Now',
        laterButtonText: 'Maybe Later',
        primaryColor: Colors.blue,
        onUpdate: () {
          debugPrint('User clicked update button');
        },
        onLater: () {
          debugPrint('User clicked later button');
        },
      ),
    );
  }

  Future<void> _checkForUpdate({bool showDialog = true}) async {
    setState(() {
      _isChecking = true;
      _errorMessage = null;
    });

    try {
      final updateInfo = await _upgrader.checkForUpdate(
        context: context,
        showDialog: showDialog,
      );

      setState(() {
        _updateInfo = updateInfo;
        _isChecking = false;
      });

      if (updateInfo != null && updateInfo.hasUpdate) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Update available: ${updateInfo.latestVersion}'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('You are using the latest version!'),
            backgroundColor: Colors.blue,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isChecking = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    }
  }

  Future<void> _checkOnly() async {
    setState(() {
      _isChecking = true;
      _errorMessage = null;
    });

    try {
      final updateInfo = await _upgrader.checkForUpdate(
        context: context,
        checkOnly: true,
      );

      setState(() {
        _updateInfo = updateInfo;
        _isChecking = false;
      });

      if (updateInfo != null && updateInfo.hasUpdate) {
        // Show dialog manually
        await _upgrader.showUpdateDialog(context, updateInfo);
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isChecking = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('App Hub Upgrader Example'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Icon(Icons.system_update, size: 80, color: Colors.blue),
              const SizedBox(height: 32),
              const Text(
                'App Hub Upgrader',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Check for app updates from API',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 48),
              if (_isChecking)
                const CircularProgressIndicator()
              else
                Column(
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => _checkForUpdate(showDialog: true),
                      icon: const Icon(Icons.check_circle),
                      label: const Text('Check for Update (Auto Dialog)'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: _checkOnly,
                      icon: const Icon(Icons.info),
                      label: const Text('Check Only (Manual Dialog)'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 32),
              if (_updateInfo != null) ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Update Information:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text('Has Update: ${_updateInfo!.hasUpdate}'),
                      if (_updateInfo!.currentVersion != null)
                        Text('Current Version: ${_updateInfo!.currentVersion}'),
                      if (_updateInfo!.latestVersion != null)
                        Text('Latest Version: ${_updateInfo!.latestVersion}'),
                      Text('Forced Update: ${_updateInfo!.isForcedUpdate}'),
                      if (_updateInfo!.downloadUrl != null)
                        Text('Download URL: ${_updateInfo!.downloadUrl}'),
                    ],
                  ),
                ),
              ],
              if (_errorMessage != null) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.red[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Error: $_errorMessage',
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
