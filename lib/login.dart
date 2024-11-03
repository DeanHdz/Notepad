import 'package:flutter/material.dart';
import 'package:notepad/home.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String validationMessage =
      ''; // Variable para mostrar mensaje de validación al interactuar con el formulario
  bool isPasswordHidden = true; // Variable para ocultar la contraseña

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFF252525),
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
              Image.asset(
                'assets/images/logo.png',
                width: 100,
              ),
              const SizedBox(height: 20),
              const Text('Inicio de sesión',
                  style: TextStyle(
                      fontSize: 43,
                      fontWeight: FontWeight.w500,
                      color: Colors.white)),
              const SizedBox(height: 20),
              Card(
                  margin: const EdgeInsets.all(24),
                  color: const Color(0xFF131313),
                  child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(children: <Widget>[
                        TextField(
                          controller: emailController,
                          style: const TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(40))),
                            filled: true,
                            fillColor: Colors.white,
                            hintText: 'Correo electrónico',
                            hintStyle:
                                TextStyle(color: Colors.black.withOpacity(0.6)),
                            prefixIcon:
                                const Icon(Icons.email, color: Colors.black),
                          ),
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: passwordController,
                          style: const TextStyle(color: Colors.black),
                          obscureText:
                              isPasswordHidden, // Para ocultar la contraseña
                          decoration: InputDecoration(
                              border: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(40))),
                              filled: true,
                              fillColor: Colors.white,
                              hintText: 'Contraseña',
                              hintStyle: TextStyle(
                                  color: Colors.black.withOpacity(0.6)),
                              prefixIcon: const Icon(
                                Icons.lock,
                                color: Colors.black,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  isPasswordHidden
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.black.withOpacity(0.6),
                                ),
                                onPressed: () {
                                  setState(() {
                                    isPasswordHidden = !isPasswordHidden;
                                  });
                                },
                              )),
                        ),
                        validationMessage.isEmpty
                            ? const SizedBox()
                            : Text(validationMessage,
                                style: const TextStyle(color: Colors.red)),
                      ]))),
              const SizedBox(height: 20),
              ElevatedButton(
                  onPressed: () {
                    loginUser();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFC000),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 10),
                  ),
                  child: const Text('Iniciar',
                      style: TextStyle(fontSize: 24, color: Colors.black))),
            ])));
  }

  bool formIsValid() {
    //Validar que los campos no estén vacíos
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      setState(() {
        validationMessage = 'Por favor, complete todos los campos';
      });
      return false;
    }

    // Validar que el correo tenga un formato válido
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
        .hasMatch(emailController.text)) {
      setState(() {
        validationMessage = 'Por favor, ingrese un correo válido';
      });
      return false;
    }

    // Validar que la contraseña tenga al menos 6 caracteres
    if (passwordController.text.length < 6) {
      setState(() {
        validationMessage = 'La contraseña debe tener al menos 6 caracteres';
      });
      return false;
    }

    setState(() {
      validationMessage = '';
    });
    return true;
  }

  void loginUser() {
    // Validar el formulario
    if (!formIsValid()) {
      return;
    }

    // Redirigir al usuario a la pantalla principal
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return const Home();
    }));
  }
}
