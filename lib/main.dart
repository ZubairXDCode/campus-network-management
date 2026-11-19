
import 'package:material_ui/material_ui.dart';
import 'screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const CliqueApp());
}

class CliqueApp extends StatelessWidget {
  const CliqueApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Clique',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2563EB),
          brightness: Brightness.light,
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
