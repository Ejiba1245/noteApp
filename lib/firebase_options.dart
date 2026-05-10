import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyD0-lYIZwiNm1W2Ia3cbh85LzsOhfxHdA4',
    appId: '1:322921047191:web:4ae2347c3115eda051b5d2',
    messagingSenderId: '322921047191',
    projectId: 'gen-lang-client-0799498704',
    authDomain: 'gen-lang-client-0799498704.firebaseapp.com',
    storageBucket: 'gen-lang-client-0799498704.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD0-lYIZwiNm1W2Ia3cbh85LzsOhfxHdA4',
    appId: '1:322921047191:android:your_android_appid', // Placeholder
    messagingSenderId: '322921047191',
    projectId: 'gen-lang-client-0799498704',
    storageBucket: 'gen-lang-client-0799498704.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD0-lYIZwiNm1W2Ia3cbh85LzsOhfxHdA4',
    appId: '1:322921047191:ios:your_ios_appid', // Placeholder
    messagingSenderId: '322921047191',
    projectId: 'gen-lang-client-0799498704',
    storageBucket: 'gen-lang-client-0799498704.firebasestorage.app',
    iosBundleId: 'com.example.aiNotesAssistant',
  );
}
