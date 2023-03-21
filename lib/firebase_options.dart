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
    apiKey: 'AIzaSyCC0V6cFBzBZTE_FI2FWbSbgPhqGZVDMKw',
    appId: '1:834039320104:web:9b216144965144736aef1d',
    messagingSenderId: '834039320104',
    projectId: 'rotc-emu',
    authDomain: 'rotc-emu.firebaseapp.com',
    storageBucket: 'rotc-emu.appspot.com',
    measurementId: 'G-6394XVCHB9',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCUSWOEEpcrhYYRUyhDu4rZPHCn5LvDV-Y',
    appId: '1:834039320104:android:16ceb9ab4b0df7136aef1d',
    messagingSenderId: '834039320104',
    projectId: 'rotc-emu',
    storageBucket: 'rotc-emu.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyANIyjD7TgVZOy6BN0J2nGW3piecqUOcYg',
    appId: '1:834039320104:ios:67822fa85e2b8c0f6aef1d',
    messagingSenderId: '834039320104',
    projectId: 'rotc-emu',
    storageBucket: 'rotc-emu.appspot.com',
    iosClientId: '834039320104-t0mpmo60s11sq3ls1k4apfvdt7qmstcc.apps.googleusercontent.com',
    iosBundleId: 'com.example.rotcEmu',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyANIyjD7TgVZOy6BN0J2nGW3piecqUOcYg',
    appId: '1:834039320104:ios:67822fa85e2b8c0f6aef1d',
    messagingSenderId: '834039320104',
    projectId: 'rotc-emu',
    storageBucket: 'rotc-emu.appspot.com',
    iosClientId: '834039320104-t0mpmo60s11sq3ls1k4apfvdt7qmstcc.apps.googleusercontent.com',
    iosBundleId: 'com.example.rotcEmu',
  );
}
