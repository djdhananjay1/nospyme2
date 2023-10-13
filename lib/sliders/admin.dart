import 'package:flutter/material.dart';
import 'package:nospyme2/sliders/recordmc.dart';
import '../main.dart';

class AdminDashboard extends StatelessWidget {
  final CallRecorder callRecorder;

  const AdminDashboard({Key? key, required this.callRecorder})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('The recording is currently running.'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                callRecorder.stopRecording();
              },
              child: Text('Stop Recording'),
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
  _AdminCameraButtonState createState() => _AdminCameraButtonState();
}

class _AdminCameraButtonState extends State<AdminCameraButton> {
  @override
  Widget build(BuildContext context) {
    // TODO: Implement this method to check if the user is logged in as an admin.
    // If the user is not logged in as an admin, return an empty widget.

    return FloatingActionButton(
      onPressed: widget.onPressed,
      child: Icon(Icons.camera),
    );
  }
}
