import 'package:flutter/material.dart';
import 'package:flutter/services.dart';  // Importar este paquete para SystemChrome
import 'presentation/screens/login_screen.dart';  // Asegúrate de tener este import

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Football Zone',
        debugShowCheckedModeBanner: false,
        initialRoute: 'home',
        routes: {
          'home': (context) => LoginScreen(),
        });
  }
}
