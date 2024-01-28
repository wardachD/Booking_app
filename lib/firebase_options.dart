// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyD2CQ64TdrOCWEdwJOJLgAuGpdkLOf2eC4',
    appId: '1:1093354743941:web:96cfa8f1e5db38323021ec',
    messagingSenderId: '1093354743941',
    projectId: 'findovio',
    authDomain: 'findovio.firebaseapp.com',
    databaseURL:
        'https://findovio-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'findovio.appspot.com',
    measurementId: 'G-GM0Q5MR9SN',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBVXCUqXoj_r9o7it_NxmlehkksAmrBSSg',
    appId: '1:1093354743941:android:e51f8636333c5ffe3021ec',
    messagingSenderId: '1093354743941',
    projectId: 'findovio',
    databaseURL:
        'https://findovio-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'findovio.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBBZZHcEP8exnfYqaFKUu4F1NsIp4QMHMM',
    appId: '1:1093354743941:ios:dd0d5321f847faa73021ec',
    messagingSenderId: '1093354743941',
    projectId: 'findovio',
    databaseURL:
        'https://findovio-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'findovio.appspot.com',
    iosClientId:
        '1093354743941-id9h1t0aafmaoufkvjicefl3d51bldse.apps.googleusercontent.com',
    iosBundleId: 'com.example.findovio',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBBZZHcEP8exnfYqaFKUu4F1NsIp4QMHMM',
    appId: '1:1093354743941:ios:8391f51ed1be45513021ec',
    messagingSenderId: '1093354743941',
    projectId: 'findovio',
    databaseURL:
        'https://findovio-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'findovio.appspot.com',
    iosClientId:
        '1093354743941-pqb3rhj1ooho6v177v13ebb4r1dl9ddh.apps.googleusercontent.com',
    iosBundleId: 'com.example.findovio.RunnerTests',
  );
}
