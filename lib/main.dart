import 'package:flutter/material.dart';
import 'package:notepad/screens/home.dart';
import 'package:notepad/screens/profile.dart';
import 'package:notepad/screens/register.dart';
import 'package:notepad/screens/login.dart';
import 'package:notepad/screens/note.dart';
import 'package:notepad/screens/checklist.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/': (context) => const Home(), // Home ahora es la ruta por default
        '/register': (context) => const Register(),
        '/login': (context) => const Login(),
        '/profile': (context) => const Profile(),
        '/note': (context) => const Note(),
        '/checklist': (context) => const Checklist(),
      },
      initialRoute: '/login',
    );
  }
}
