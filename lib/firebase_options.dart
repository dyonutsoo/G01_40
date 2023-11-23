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
    apiKey: 'AIzaSyAWR4hpO1Xtv6FxkmgM8v-jCZWnW-4Y-Mw',
    appId: '1:129252803791:web:c6deb566883d482ebca3ba',
    messagingSenderId: '129252803791',
    projectId: 'door-security-lock-c2216',
    authDomain: 'door-security-lock-c2216.firebaseapp.com',
    databaseURL: 'https://door-security-lock-c2216-default-rtdb.firebaseio.com',
    storageBucket: 'door-security-lock-c2216.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBXCz3oloUKASYlqtqS5QOkjj11J1JsncM',
    appId: '1:129252803791:android:740e04eb5d6fd32fbca3ba',
    messagingSenderId: '129252803791',
    projectId: 'door-security-lock-c2216',
    databaseURL: 'https://door-security-lock-c2216-default-rtdb.firebaseio.com',
    storageBucket: 'door-security-lock-c2216.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCHZSWRV5M661mabCPpGs-Z94HA-BTDxeM',
    appId: '1:129252803791:ios:250d271073bc0a5cbca3ba',
    messagingSenderId: '129252803791',
    projectId: 'door-security-lock-c2216',
    databaseURL: 'https://door-security-lock-c2216-default-rtdb.firebaseio.com',
    storageBucket: 'door-security-lock-c2216.appspot.com',
    iosBundleId: 'com.example.doorSecurityLockApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCHZSWRV5M661mabCPpGs-Z94HA-BTDxeM',
    appId: '1:129252803791:ios:2dd0f6e23ca26852bca3ba',
    messagingSenderId: '129252803791',
    projectId: 'door-security-lock-c2216',
    databaseURL: 'https://door-security-lock-c2216-default-rtdb.firebaseio.com',
    storageBucket: 'door-security-lock-c2216.appspot.com',
    iosBundleId: 'com.example.doorSecurityLockApp.RunnerTests',
  );
}
