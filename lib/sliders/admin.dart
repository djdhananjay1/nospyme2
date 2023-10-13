import 'package:flutter/material.dart';
import 'package:nospyme2/sliders/recordmc.dart';

class AdminDashboard extends StatelessWidget {
  final CallRecorder callRecorder;

  const AdminDashboard({Key? key, required this.callRecorder})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('The recording is currently running.'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                callRecorder.stopRecording();
              },
              child: const Text('Stop Recording'),
            ),
          ],
        ),
      ),
    );
  }
}

class AdminCameraButton extends StatefulWidget {
  final VoidCallback onPressed;

  const AdminCameraButton({Key? key, required this.onPressed})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AdminCameraButtonState createState() => _AdminCameraButtonState();
}

class _AdminCameraButtonState extends State<AdminCameraButton> {
  @override
  Widget build(BuildContext context) {
    // Implement this method to check if the user is logged in as an admin.
    // If the user is not logged in as an admin, return an empty widget.

    return FloatingActionButton(
      onPressed: widget.onPressed,
      child: const Icon(Icons.camera),
    );
  }
}
