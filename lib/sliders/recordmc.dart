import 'dart:async';
import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class RecordMCPage extends StatefulWidget {
  const RecordMCPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _RecordMCPageState createState() => _RecordMCPageState();
}

class _RecordMCPageState extends State<RecordMCPage> {
  final CallRecorder _callRecorder = CallRecorder();

  bool isRecording = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Call Recorder'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(isRecording ? 'Recording...' : 'Not recording'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (isRecording) {
                  await _callRecorder.stopRecording();
                  setState(() {
                    isRecording = false;
                  });
                } else {
                  await _callRecorder.recordAndUploadCall();
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

class CallRecorder {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  Future<void> startRecording() async {
    // : Implement this method to start recording the call
  }

  Future<void> stopRecording() async {
    // : Implement this method to stop recording the call
  }

  Future<File> getRecordedAudioFile() async {
    // Get the audio recorder.
    final audioRecorder = AudioRecorder();

    // Start recording.
    await audioRecorder.start();

    // Stop recording.
    await audioRecorder.stop();

    // Get the recorded audio file.
    return await audioRecorder.getAudioFile();
  }

  Future<void> saveRecordedAudioFileToFirebaseStorage() async {
    // Get the recorded audio file.
    final recordedAudioFile = await getRecordedAudioFile();

    // Upload the recorded audio file to Firebase Storage.
    final storageReference =
        FirebaseStorage.instance.ref().child('recorded_audio_files');
    final uploadTask = storageReference.putFile(recordedAudioFile);
    await uploadTask.whenComplete(() async {
      // The uploaded audio file is now available at the URL returned by the upload task.
    });
  }

  Future<void> recordAndUploadCall() async {
    final permissionStatus = await Permission.microphone.status;
    if (permissionStatus.isDenied) {
      // Request the permission
      await Permission.microphone.request();
      // Check the status again
      final permissionStatus = await Permission.microphone.status;
      if (permissionStatus.isDenied) {
        // The user denied the permission
        return;
      }
    }

    // Start recording the call
    await startRecording();

    // Wait for 5 minutes
    final timer = Timer(const Duration(minutes: 5), () async {
      // Stop recording the call
      await stopRecording();

      // Save the recorded audio file to a location on the device
      final recordedAudioFile = await getRecordedAudioFile();
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/call_recording.mp3';
      await recordedAudioFile.writeAsBytes(filePath);

      // Upload the recorded audio file to Firebase Storage
      final storageReference =
          _storage.ref().child('calls/${DateTime.now().toString()}.mp3');
      final uploadTask = storageReference.putFile(recordedAudioFile);
      await uploadTask.whenComplete(() async {
        // Save the URL of the uploaded audio file to Firebase Realtime Database
        final databaseReference =
            _database.ref().child('calls/${DateTime.now().toString()}');
        await databaseReference.set(storageReference.getDownloadURL());

        // Make the URL of the uploaded audio file available to the admin
        // : Implement this method to make the URL of the uploaded audio file available to the admin
        // This could be done by saving the URL to a shared preference, or by sending the URL to the admin via a notification.
      });
    });

    // Wait for the timer to fire
    await timer.future;

    // Restart the recording
    await recordAndUploadCall();
  }
}
