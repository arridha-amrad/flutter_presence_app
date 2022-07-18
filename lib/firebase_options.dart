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
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBKkFNyL8NsMH5doE2ShML4joipnN4lhGI',
    appId: '1:368184108664:android:a44308216279820f662f8d',
    messagingSenderId: '368184108664',
    projectId: 'flutter-presence-081215',
    storageBucket: 'flutter-presence-081215.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBVViM6b-hWzO_AHRZD2hVVGs_7KQzNDC4',
    appId: '1:368184108664:ios:75c6c585a25f30ca662f8d',
    messagingSenderId: '368184108664',
    projectId: 'flutter-presence-081215',
    storageBucket: 'flutter-presence-081215.appspot.com',
    androidClientId: '368184108664-886iap76m9o7sn332qlt0pccglqql2mg.apps.googleusercontent.com',
    iosClientId: '368184108664-pftomk6s4tf2jps70gtm2s9vlb4vuus3.apps.googleusercontent.com',
    iosBundleId: 'com.ari.presenceApp',
  );
}
