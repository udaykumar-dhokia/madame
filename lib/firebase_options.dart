// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        return windows;
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
    apiKey: 'AIzaSyDsrW14x6QLvhwtE-Gi3KyurerfSfnv-40',
    appId: '1:131292024891:web:6537f18063dfca6c454c1e',
    messagingSenderId: '131292024891',
    projectId: 'madame-acc47',
    authDomain: 'madame-acc47.firebaseapp.com',
    storageBucket: 'madame-acc47.appspot.com',
    measurementId: 'G-FVTSVFTSTF',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBtd1Q4H2sWTc0Ag3v_-EF0LbY7npU6Wps',
    appId: '1:131292024891:android:b3782ffd8fb92b50454c1e',
    messagingSenderId: '131292024891',
    projectId: 'madame-acc47',
    storageBucket: 'madame-acc47.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyACoHTHyRTBphmqMYI48P4mFFoUDiDSoU8',
    appId: '1:131292024891:ios:77a4b155bed8252a454c1e',
    messagingSenderId: '131292024891',
    projectId: 'madame-acc47',
    storageBucket: 'madame-acc47.appspot.com',
    iosBundleId: 'com.example.madame',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyACoHTHyRTBphmqMYI48P4mFFoUDiDSoU8',
    appId: '1:131292024891:ios:77a4b155bed8252a454c1e',
    messagingSenderId: '131292024891',
    projectId: 'madame-acc47',
    storageBucket: 'madame-acc47.appspot.com',
    iosBundleId: 'com.example.madame',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDsrW14x6QLvhwtE-Gi3KyurerfSfnv-40',
    appId: '1:131292024891:web:a7117b544c395fc4454c1e',
    messagingSenderId: '131292024891',
    projectId: 'madame-acc47',
    authDomain: 'madame-acc47.firebaseapp.com',
    storageBucket: 'madame-acc47.appspot.com',
    measurementId: 'G-1MVLE33X9J',
  );
}
