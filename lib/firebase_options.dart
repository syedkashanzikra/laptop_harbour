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
    apiKey: 'AIzaSyA-eiAZln3YRxh3vUlUa673sUSdZxg6Tgg',
    appId: '1:735991667055:web:6864eb3e81a0256235f09a',
    messagingSenderId: '735991667055',
    projectId: 'laptopharbour-b6416',
    authDomain: 'laptopharbour-b6416.firebaseapp.com',
    databaseURL: 'https://laptopharbour-b6416-default-rtdb.firebaseio.com',
    storageBucket: 'laptopharbour-b6416.firebasestorage.app',
    measurementId: 'G-CJBW0QJZZ4',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDSPaY_z11sJS8cpMafOFMLYdCQFEpLZvc',
    appId: '1:735991667055:android:1f9bb6d92f433f6235f09a',
    messagingSenderId: '735991667055',
    projectId: 'laptopharbour-b6416',
    databaseURL: 'https://laptopharbour-b6416-default-rtdb.firebaseio.com',
    storageBucket: 'laptopharbour-b6416.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAJ6JbwKNkYSHjXk0SDCVXc0F0yMcZ1dwQ',
    appId: '1:735991667055:ios:d4ea96f173ebcf5735f09a',
    messagingSenderId: '735991667055',
    projectId: 'laptopharbour-b6416',
    databaseURL: 'https://laptopharbour-b6416-default-rtdb.firebaseio.com',
    storageBucket: 'laptopharbour-b6416.firebasestorage.app',
    iosBundleId: 'com.example.lhstore',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAJ6JbwKNkYSHjXk0SDCVXc0F0yMcZ1dwQ',
    appId: '1:735991667055:ios:d4ea96f173ebcf5735f09a',
    messagingSenderId: '735991667055',
    projectId: 'laptopharbour-b6416',
    databaseURL: 'https://laptopharbour-b6416-default-rtdb.firebaseio.com',
    storageBucket: 'laptopharbour-b6416.firebasestorage.app',
    iosBundleId: 'com.example.lhstore',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyA-eiAZln3YRxh3vUlUa673sUSdZxg6Tgg',
    appId: '1:735991667055:web:683740fd65e7aed635f09a',
    messagingSenderId: '735991667055',
    projectId: 'laptopharbour-b6416',
    authDomain: 'laptopharbour-b6416.firebaseapp.com',
    databaseURL: 'https://laptopharbour-b6416-default-rtdb.firebaseio.com',
    storageBucket: 'laptopharbour-b6416.firebasestorage.app',
    measurementId: 'G-F6SCG3K8NL',
  );

}