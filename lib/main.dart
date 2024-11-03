import 'package:flutter/material.dart';
import 'package:notepad/home.dart';
import 'package:notepad/profile.dart';
import 'package:notepad/register.dart';
import 'package:notepad/login.dart';
import 'package:notepad/note.dart';
import 'package:notepad/checklist.dart';

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
    );
  }
}
