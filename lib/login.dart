import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String mensajeValidacion =
      ''; // Variable para mostrar mensaje de validación al interactuar con el formulario
  bool isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
          const Text('Inicio de sesión'),
          const SizedBox(height: 20),
          Center(
              child: Card(
                  margin: const EdgeInsets.all(20),
                  color: const Color(0xFF131313),
                  child: Column(children: <Widget>[
                    TextField(
                        controller: emailController,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(), labelText: 'Correo')),
                    const SizedBox(height: 20),
                    TextField(
                      controller: passwordController,
                      obscureText:
                          isPasswordVisible, // Para ocultar la contraseña
                      decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: 'Contraseña',
                          prefixIcon: const Icon(Icons.lock),
                          suffixIcon: IconButton(
                            icon: Icon(
                              isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.black.withOpacity(0.6),
                            ),
                            onPressed: () {
                              setState(() {
                                isPasswordVisible = !isPasswordVisible;
                              });
                            },
                          )),
                    ),
                    Text(mensajeValidacion,
                        style: const TextStyle(color: Colors.red))
                  ]))),
          const SizedBox(height: 20),
          ElevatedButton(
              onPressed: () {
                validarFormulario();
              },
              child: const Text('Ingresar'))
        ])));
  }

  void validarFormulario() {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      setState(() {
        mensajeValidacion = 'Por favor, complete todos los campos';
      });
    } else {
      setState(() {
        mensajeValidacion = '';
      });
    }
  }

  void ingresar() {
    validarFormulario();
    if (mensajeValidacion.isEmpty) {
      // Lógica para autenticar al usuario
      Navigator.pushNamed(context, '/home');
    }
  }
}
