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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyAuNZXCB6aBH5uiueHLnc4jkfbXyfVx194',
    appId: '1:247505605589:web:f5fafc489ab586176ea35c',
    messagingSenderId: '247505605589',
    projectId: 'splendid-parsec-364609',
    authDomain: 'splendid-parsec-364609.firebaseapp.com',
    storageBucket: 'splendid-parsec-364609.appspot.com',
    measurementId: 'G-C6N0NP3W3E',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC55gDYnR65uiMlM3ZbaI1L5x3OEAMdau4',
    appId: '1:247505605589:android:18ab17ec2137dda76ea35c',
    messagingSenderId: '247505605589',
    projectId: 'splendid-parsec-364609',
    storageBucket: 'splendid-parsec-364609.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBg29PHC2nz1pVRl7MSZOCf5Y1jhb5_sis',
    appId: '1:247505605589:ios:4e15757abb9eb15d6ea35c',
    messagingSenderId: '247505605589',
    projectId: 'splendid-parsec-364609',
    storageBucket: 'splendid-parsec-364609.appspot.com',
    iosBundleId: 'com.example.socialNetwork',
  );
}