import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:firebase_storage/firebase_storage.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  final CameraController _cameraController =
      CameraController(CameraLensDirection.back);
  XFile? _takenPicture;

  @override
  void initState() {
    super.initState();

    _cameraController.initialize().then((_) {
      if (!mounted) {
        return;
      }

      setState(() {});
    });
  }

  @override
  void dispose() {
    _cameraController.dispose();

    super.dispose();
  }

  Future<void> _takePicture() async {
    if (_takenPicture != null) {
      return;
    }

    final XFile takenPicture = await _cameraController.takePicture();

    setState(() {
      _takenPicture = takenPicture;
    });

    // Upload the taken picture to Firebase Storage.
    final storageReference =
        FirebaseStorage.instance.ref().child('pictures/${takenPicture.name}');
    final uploadTask = storageReference.putFile(takenPicture);
    await uploadTask.whenComplete(() async {
      // Send a notification to the admin with the URL of the uploaded picture.
      // TODO: Implement this method to send a notification to the admin.
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_cameraController.value.isInitialized) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Camera'),
        ),
        body: Center(
          child: CameraPreview(_cameraController),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _takePicture,
          child: Icon(Icons.camera),
        ),
      );
    } else {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
  }
}
