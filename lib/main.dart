import 'package:flutter/material.dart';
import 'package:notepad/screens/home.dart';
import 'package:notepad/screens/profile.dart';
import 'package:notepad/screens/register.dart';
import 'package:notepad/screens/login.dart';
import 'package:notepad/screens/note.dart';
import 'package:notepad/screens/checklist.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Asegura que los Widgets de Flutter estén inicializados, se necesita para que shared preferences funcione bien.
  // Verifica si el usuario ya ha iniciado sesión utilizando SharedPreferences
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  // Si el usuario ya habia iniciado sesión, la aplicación se inicia en la pantalla de inicio
  runApp(MainApp(initialRoute: isLoggedIn ? '/' : '/login'));
}

class MainApp extends StatelessWidget {
  final String initialRoute;

  const MainApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/': (context) => const Home(),
        '/register': (context) => const Register(),
        '/login': (context) => const Login(),
        '/profile': (context) => const Profile(),
        '/note': (context) => const Note(),
        '/checklist': (context) => const Checklist(),
      },
      initialRoute: initialRoute,
    );
  }
}
