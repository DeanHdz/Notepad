import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import '../services/auth_service.dart';
import '../db/database_helper.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String validationMessage = '';
  bool isPasswordHidden = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF252525),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize
                  .min, // Para que la columna no ocupe todo el espacio
              children: <Widget>[
                Image.asset(
                  'assets/images/logo.png',
                  width: 100,
                ),
                const SizedBox(height: 20),
                const Text(
                  'Registro',
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
                          controller: usernameController,
                          style: const TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(40))),
                            filled: true,
                            fillColor: Colors.white,
                            hintText: 'Nombre de usuario',
                            hintStyle:
                                TextStyle(color: Colors.black.withOpacity(0.6)),
                            prefixIcon:
                                const Icon(Icons.person, color: Colors.black),
                          ),
                          keyboardType: TextInputType.name,
                        ),
                        const SizedBox(height: 20),
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
                // Texto que redirige a la vista de login
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                  child: const Text(
                    '¿Ya tienes una cuenta?\n Inicia sesión',
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
                    registerUser();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFC000),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 10),
                  ),
                  child: const Text(
                    'Registrar',
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
    //Remover espacio en blanco
    usernameController.text = usernameController.text.trim();
    emailController.text = emailController.text.trim();
    passwordController.text = passwordController.text.trim();

    // Validar que los campos no estén vacíos
    if (usernameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty) {
      setState(() {
        validationMessage = 'Por favor, complete todos los campos';
      });
      return false;
    }

    // Validar que el correo sea válido
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

  Future<void> registerUser() async {
    // Validar formulario
    if (!formIsValid()) {
      return;
    }

    // Obtener los valores de los campos de texto
    String username = usernameController.text.trim();
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    // Verificar si el correo ya está registrado
    bool emailExists = await DatabaseHelper().emailExists(email);
    if (emailExists) {
      setState(() {
        validationMessage = 'El correo electrónico ya está registrado';
      });
      return;
    }

    // Crear el usuario
    bool success = await AuthService().registerUser(username, email, password);
    if (success) {
      // Mostrar un diálogo de éxito
      AwesomeDialog(
        context: context,
        animType: AnimType.leftSlide,
        headerAnimationLoop: false,
        dialogType: DialogType.success,
        showCloseIcon: true,
        title: 'Creación exitosa',
        desc: 'La cuenta ha sido creada. Por favor, inicia sesión',
      ).show();

      // Pausar la ejecución por 5 segundos
      await Future.delayed(const Duration(seconds: 5));

      // Redirigir a la vista de inicio
      Navigator.pushReplacementNamed(context, '/login');
    } else {
      // Mostrar un diálogo de error
      AwesomeDialog(
        context: context,
        animType: AnimType.leftSlide,
        headerAnimationLoop: false,
        dialogType: DialogType.error,
        showCloseIcon: true,
        title: 'Error',
        desc: 'Ha ocurrido un error al crear la cuenta',
      ).show();
    }
  }
}
