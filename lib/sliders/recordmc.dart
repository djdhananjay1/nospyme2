import 'dart:async';
import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class RecordMCPage extends StatefulWidget {
  const RecordMCPage({super.key});

  @override
  _RecordMCPageState createState() => _RecordMCPageState();
}

class _RecordMCPageState extends State<RecordMCPage> {
  final CallRecorder _callRecorder = CallRecorder();

  bool isRecording = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Call Recorder'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(isRecording ? 'Recording...' : 'Not recording'),
            SizedBox(height: 20),
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
    // TODO: Implement this method to start recording the call
  }

  Future<void> stopRecording() async {
    // TODO: Implement this method to stop recording the call
  }

  Future<File> getRecordedAudioFile() async {
    // TODO: Implement this method to return the recorded audio file
    // This could be done by using the `CallRecorder.recorder` property to get the audio recorder, and then calling the `AudioRecorder.stop()` method to stop recording.
    // Once the recording has stopped, you can get the recorded audio file by calling the `AudioRecorder.getAudioFile()` method.
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
    final timer = Timer(Duration(minutes: 5), () async {
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
        // TODO: Implement this method to make the URL of the uploaded audio file available to the admin
        // This could be done by saving the URL to a shared preference, or by sending the URL to the admin via a notification.
      });
    });

    // Wait for the timer to fire
    await timer.future;

    // Restart the recording
    await recordAndUploadCall();
  }
}
