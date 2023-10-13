import 'package:flutter/material.dart';

class EnvRecPage extends StatefulWidget {
  const EnvRecPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _EnvRecPageState createState() => _EnvRecPageState();
}

class _EnvRecPageState extends State<EnvRecPage> {
  final EnvironmentRecorder _environmentRecorder = EnvironmentRecorder();

  bool isRecording = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Environment Recorder'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(isRecording
                ? 'Recording the environment...'
                : 'Not recording the environment'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (isRecording) {
                  await _environmentRecorder.stopRecording();
                  setState(() {
                    isRecording = false;
                  });
                } else {
                  await _environmentRecorder.startRecording();
                  setState(() {
                    isRecording = true;
                  });
                }
              },
              child: Text(isRecording ? 'Stop Recording' : 'Start Recording'),
            ),
          ],
        ),
      ),
    );
  }
}

class EnvironmentRecorder {
  Future<void> startRecording() async {
    final audioRecorder = AudioRecorder(source: AudioSource.mic);
    await audioRecorder.start();
  }
}
