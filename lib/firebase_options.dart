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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCDZmKGNwmillPvRVXlV7Kk3T5p0WZWcQw',
    appId: '1:917839972201:android:26c11fc1ca1377df651ff8',
    messagingSenderId: '917839972201',
    projectId: 'instagram-26378',
    storageBucket: 'instagram-26378.appspot.com',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAfEALjedO2sqgxnU0iTNQE--hwpyrpzuk',
    appId: '1:917839972201:web:7599b6a259677fee651ff8',
    messagingSenderId: '917839972201',
    projectId: 'instagram-26378',
    authDomain: 'instagram-26378.firebaseapp.com',
    storageBucket: 'instagram-26378.appspot.com',
  );

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAfEALjedO2sqgxnU0iTNQE--hwpyrpzuk',
    appId: '1:917839972201:web:2c262bedf59428b8651ff8',
    messagingSenderId: '917839972201',
    projectId: 'instagram-26378',
    authDomain: 'instagram-26378.firebaseapp.com',
    storageBucket: 'instagram-26378.appspot.com',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCDMoZYqT0ICjQqhf-hctZ7WiqOaf0tJh4',
    appId: '1:917839972201:ios:a12fed1635071971651ff8',
    messagingSenderId: '917839972201',
    projectId: 'instagram-26378',
    storageBucket: 'instagram-26378.appspot.com',
    iosBundleId: 'com.example.instagram',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCDMoZYqT0ICjQqhf-hctZ7WiqOaf0tJh4',
    appId: '1:917839972201:ios:a12fed1635071971651ff8',
    messagingSenderId: '917839972201',
    projectId: 'instagram-26378',
    storageBucket: 'instagram-26378.appspot.com',
    iosBundleId: 'com.example.instagram',
  );

}