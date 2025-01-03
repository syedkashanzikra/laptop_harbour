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
    apiKey: 'AIzaSyC_CG6WSJLfmdXHLNsLkOJUfTDlkR2ZZDY',
    appId: '1:1032895306683:web:40e2fff8d82a61d717c29e',
    messagingSenderId: '1032895306683',
    projectId: 'laptop-c11d3',
    authDomain: 'laptop-c11d3.firebaseapp.com',
    databaseURL: 'https://laptop-c11d3-default-rtdb.firebaseio.com',
    storageBucket: 'laptop-c11d3.firebasestorage.app',
    measurementId: 'G-45EHQNCL61',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD-zztxk4AElSzJpfa6THT8Pl9rHkUyrdg',
    appId: '1:1032895306683:android:eb00a903201f908217c29e',
    messagingSenderId: '1032895306683',
    projectId: 'laptop-c11d3',
    databaseURL: 'https://laptop-c11d3-default-rtdb.firebaseio.com',
    storageBucket: 'laptop-c11d3.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDYWWOqWXNsON67q3aZiEacbqEUF0TozTs',
    appId: '1:1032895306683:ios:613e90d079c6ae1517c29e',
    messagingSenderId: '1032895306683',
    projectId: 'laptop-c11d3',
    databaseURL: 'https://laptop-c11d3-default-rtdb.firebaseio.com',
    storageBucket: 'laptop-c11d3.firebasestorage.app',
    iosClientId: '1032895306683-t60ssj9hdrclhmpp0pokv6infqhq3p3r.apps.googleusercontent.com',
    iosBundleId: 'com.example.lhstore',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDYWWOqWXNsON67q3aZiEacbqEUF0TozTs',
    appId: '1:1032895306683:ios:613e90d079c6ae1517c29e',
    messagingSenderId: '1032895306683',
    projectId: 'laptop-c11d3',
    databaseURL: 'https://laptop-c11d3-default-rtdb.firebaseio.com',
    storageBucket: 'laptop-c11d3.firebasestorage.app',
    iosClientId: '1032895306683-t60ssj9hdrclhmpp0pokv6infqhq3p3r.apps.googleusercontent.com',
    iosBundleId: 'com.example.lhstore',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyC_CG6WSJLfmdXHLNsLkOJUfTDlkR2ZZDY',
    appId: '1:1032895306683:web:40e2fff8d82a61d717c29e',
    messagingSenderId: '1032895306683',
    projectId: 'laptop-c11d3',
    authDomain: 'laptop-c11d3.firebaseapp.com',
    databaseURL: 'https://laptop-c11d3-default-rtdb.firebaseio.com',
    storageBucket: 'laptop-c11d3.firebasestorage.app',
    measurementId: 'G-45EHQNCL61',
  );

}