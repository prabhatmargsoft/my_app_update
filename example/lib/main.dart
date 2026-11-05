import 'package:flutter/material.dart';
import 'package:my_app_update/margsoft_in_app_update.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: UpdateTestScreen(),
    );
  }
}

class UpdateTestScreen extends StatefulWidget {
  const UpdateTestScreen({super.key});

  @override
  State<UpdateTestScreen> createState() => _UpdateTestScreenState();
}

class _UpdateTestScreenState extends State<UpdateTestScreen> {
  String message = 'Ready to check update';
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    checkUpdate();
  }

  Future<void> checkUpdate() async {
    setState(() {
      isLoading = true;
      message = 'Checking for updates...';
    });

    try {
      final version = await MargsoftInAppUpdate.getPlatformVersion();

      final response = await MargsoftInAppUpdate.checkForUpdate();

      final updateAvailable = response['updateAvailable'] ?? false;

      setState(() {
        message =
            '''
Platform: $version

Update Available: $updateAvailable

Available Version: ${response['availableVersionCode']}

Update Availability: ${response['updateAvailability']}

Immediate Allowed: ${response['immediateAllowed']}

Flexible Allowed: ${response['flexibleAllowed']}

Full Response:
$response
''';
      });
    } catch (e) {
      setState(() {
        message = 'Error: $e';
      });
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Margsoft In-App Update'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            ElevatedButton.icon(
              onPressed: isLoading ? null : checkUpdate,
              icon: const Icon(Icons.system_update),
              label: const Text('Check Update'),
            ),
            const SizedBox(height: 20),
            if (isLoading) const CircularProgressIndicator(),
            Expanded(
              child: SingleChildScrollView(child: SelectableText(message)),
            ),
          ],
        ),
      ),
    );
  }
}
