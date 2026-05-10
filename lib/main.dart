import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'database/hive_database.dart';
import 'providers/notes_provider.dart';
import 'services/auth_service.dart';
import 'services/gemini_service.dart';
import 'services/ocr_service.dart';
import 'services/voice_service.dart';
import 'services/notification_service.dart';
import 'themes/app_theme.dart';
import 'screens/home_screen.dart';
import 'firebase_options.dart'; // Assume this is generated or manually correctly placed

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Initialize Hive
  await HiveDatabase.init();
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NotesProvider()),
        Provider(create: (_) => AuthService()),
        Provider(create: (_) => GeminiService()),
        Provider(create: (_) => OCRService()),
        Provider(create: (_) => VoiceService()),
        Provider(create: (_) => NotificationService()),
      ],
      child: const AINotesApp(),
    ),
  );
}

class AINotesApp extends StatelessWidget {
  const AINotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Notes Assistant',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const HomeScreen(),
    );
  }
}
