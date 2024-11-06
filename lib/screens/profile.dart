import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF3B3B3B),
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        title: const Text('Perfil',
            style: TextStyle(color: Colors.white, fontSize: 32)),
      ),
      backgroundColor: const Color(0xFF252525),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              const Icon(Icons.account_circle, color: Colors.white, size: 100),
              const Text(
                'Nombre de usuario',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w400,
                    color: Colors.white),
              ),
              const Text(
                'correo@gmail.com',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w300,
                    color: Colors.white),
              ),
              const SizedBox(height: 20),
              /*ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFC000),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.edit, color: Colors.black),
                    const SizedBox(width: 10),
                    const Text('Editar perfil',
                        style: TextStyle(color: Colors.black)),
                  ],
                ),
              ),*/
              ElevatedButton(
                onPressed: logout,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 212, 212, 212),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.logout, color: Colors.black),
                    const SizedBox(width: 10),
                    const Text('Cerrar sesión',
                        style: TextStyle(color: Colors.black)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Limpia todos los datos de sesión

    // Redirige al usuario a la pantalla de inicio de sesión
    Navigator.pushReplacementNamed(context, '/login');
  }
}
