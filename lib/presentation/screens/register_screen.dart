import 'package:flutter/material.dart';
import 'package:BarDamm/services/user_services.dart';
import 'package:BarDamm/presentation/screens/login_screen.dart'; // Asegúrate de que tienes la pantalla LoginScreen

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final UserService _userService = UserService();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  void _register() async {
    String username = _usernameController.text;
    String password = _passwordController.text;
    String name = _nameController.text;
    String email = _emailController.text;

    try {
      Map<String, dynamic> result = await _userService.register(username, password, name, email);
      if (result.containsKey('error')) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Error'),
              content: Text(result['error']),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('User registered successfully, please wait for redirection'),
            duration: const Duration(seconds: 5),
          ),
        );
        Future.delayed(const Duration(seconds: 5), () {
          Navigator.of(context).pop();
        });
      }
    } catch (e) {
      print('Registro fallido: $e');
    }
  }

  void _goBack() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fondo de imagen
          Positioned.fill(
            child: Image.asset(
              'assets/images/fondologinapp.jpg',
              fit: BoxFit.cover,
            ),
          ),
          // Contenido centrado en la pantalla
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Formulario
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8), // Fondo blanco semitransparente
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _usernameController,
                          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold), // Texto negro y en negrita
                          decoration: const InputDecoration(
                            labelText: 'Usuario',
                            labelStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold), // Etiqueta en negro y negrita
                            border: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            fillColor: Colors.white60, // Fondo semitransparente en el campo
                            filled: true, // Habilitar el fondo en el campo
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: true,
                          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold), // Texto negro y en negrita
                          decoration: const InputDecoration(
                            labelText: 'Contraseña',
                            labelStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold), // Etiqueta en negro y negrita
                            border: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            fillColor: Colors.white60, // Fondo semitransparente en el campo
                            filled: true, // Habilitar el fondo en el campo
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _nameController,
                          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold), // Texto negro y en negrita
                          decoration: const InputDecoration(
                            labelText: 'Nombre',
                            labelStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold), // Etiqueta en negro y negrita
                            border: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            fillColor: Colors.white60, // Fondo semitransparente en el campo
                            filled: true, // Habilitar el fondo en el campo
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _emailController,
                          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold), // Texto negro y en negrita
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            labelStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold), // Etiqueta en negro y negrita
                            border: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            fillColor: Colors.white60, // Fondo semitransparente en el campo
                            filled: true, // Habilitar el fondo en el campo
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Botones centrados horizontalmente
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center, // Centrado horizontal
                          children: [
                            ElevatedButton(
                              onPressed: _register,
                              child: const Text('Registrarse'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue, // Fondo del botón en azul
                                foregroundColor: Colors.white, // Texto del botón en blanco
                              ),
                            ),
                            const SizedBox(width: 16),
                            ElevatedButton(
                              onPressed: _goBack,
                              child: const Text('Back'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red, // Fondo del botón en gris
                                foregroundColor: Colors.white, // Texto del botón en blanco
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
