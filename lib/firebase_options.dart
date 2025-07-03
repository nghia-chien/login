import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
    apiKey: "AIzaSyBLMZdcyUh9hQkJjldqm3HGLOVmbDnA1mg",
    authDomain: "login-register-p1.firebaseapp.com",
    projectId: "login-register-p1",
    storageBucket: "login-register-p1.firebasestorage.app",
    messagingSenderId: "164330312661",
    appId: "1:164330312661:web:751e080cf4c4fe3f11e35c",
    measurementId: "G-JS7SJTST8X",
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: "AIzaSyBLMZdcyUh9hQkJjldqm3HGLOVmbDnA1mg",
    appId: "1:164330312661:android:751e080cf4c4fe3f11e35c",
    messagingSenderId: "164330312661",
    projectId: "login-register-p1",
    storageBucket: "login-register-p1.firebasestorage.app",
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: "AIzaSyBLMZdcyUh9hQkJjldqm3HGLOVmbDnA1mg",
    appId: "1:164330312661:ios:751e080cf4c4fe3f11e35c",
    messagingSenderId: "164330312661",
    projectId: "login-register-p1",
    storageBucket: "login-register-p1.firebasestorage.app",
    iosClientId: "164330312661-web",
    iosBundleId: "com.example.fashionmix",
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: "AIzaSyBLMZdcyUh9hQkJjldqm3HGLOVmbDnA1mg",
    appId: "1:164330312661:ios:751e080cf4c4fe3f11e35c",
    messagingSenderId: "164330312661",
    projectId: "login-register-p1",
    storageBucket: "login-register-p1.firebasestorage.app",
    iosClientId: "164330312661-web",
    iosBundleId: "com.example.fashionmix",
  );
} 