import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import '../services/auth_service.dart';
import '../db/database_helper.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController emailController =
      TextEditingController(); // Controlador para el campo de correo electrónico
  TextEditingController passwordController =
      TextEditingController(); // Controlador para el campo de contraseña
  String validationMessage = ''; // Variable para mostrar mensajes de validación
  bool isPasswordHidden = true; // Variable para ocultar/mostrar la contraseña

  @override
  Widget build(BuildContext context) {
    // Inicializa la base de datos cuando el widget de Login es construido
    DatabaseHelper().database;

    return Scaffold(
      backgroundColor: const Color(0xFF252525),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Image.asset(
                  'assets/images/logo.png',
                  width: 100,
                ),
                const SizedBox(height: 20),
                const Text(
                  'Inicio de sesión',
                  style: TextStyle(
                      fontSize: 43,
                      fontWeight: FontWeight.w500,
                      color: Colors.white),
                ),
                const SizedBox(height: 20),
                Card(
                  margin: const EdgeInsets.all(24),
                  color: const Color(0xFF131313),
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      children: <Widget>[
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
                          obscureText: isPasswordHidden,
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
                            : Text(
                                validationMessage,
                                style: const TextStyle(color: Colors.red),
                              ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Texto que redirige a la vista de registro
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacementNamed(context, '/register');
                  },
                  child: const Text(
                    '¿No tienes una cuenta?\n Regístrate',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
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
                  child: const Text(
                    'Iniciar',
                    style: TextStyle(fontSize: 24, color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool formIsValid() {
    // Limpiar espacios en blanco
    emailController.text = emailController.text.trim();
    passwordController.text = passwordController.text.trim();

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

  Future<void> loginUser() async {
    // Validar formulario
    if (!formIsValid()) {
      return;
    }

    // Obtener los valores de los campos de texto
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    try {
      // Verificar las credenciales e Iniciar sesión
      var user = await AuthService().loginUser(email, password);
      if (user == null) {
        setState(() {
          validationMessage = 'Correo electrónico o contraseña incorrectos';
        });
        return;
      }

      // Redirigir a la vista de inicio
      Navigator.pushReplacementNamed(context, '/');
    } catch (error) {
      // Mostrar un diálogo de error
      AwesomeDialog(
        context: context,
        animType: AnimType.leftSlide,
        headerAnimationLoop: false,
        dialogType: DialogType.error,
        showCloseIcon: true,
        title: 'Error',
        desc: 'Ha ocurrido un error al intentar iniciar sesión',
      ).show();
    }
  }
}
