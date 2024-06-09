// file: lib/screens/register_screen.dart
import 'package:flutter/material.dart';
import 'package:football_zone/services/user_services.dart';
import 'package:football_zone/models/team.dart';

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
  List<TeamModel> teams = [];
  int? selectedTeamId;

  @override
  void initState() {
    super.initState();
    _fetchTeams();
  }

  void _fetchTeams() async {
    try {
      List<TeamModel> fetchedTeams = await _userService.getTeams();
      setState(() {
        teams = fetchedTeams;
      });
    } catch (e) {
      print('No se pudo cargar los equipos: $e');
    }
  }

  void _register() async {
    if (selectedTeamId == null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Por favor selecciona un equipo'),
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
      return;
    }

    String username = _usernameController.text;
    String password = _passwordController.text;
    String name = _nameController.text;

    try {
      Map<String, dynamic> result = await _userService.register(username, password, selectedTeamId!, name);
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
          Navigator.of(context).pop(); // Cerrar pantalla de registro
        });
      }
    } catch (e) {
      print('Registro fallido: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registrarse')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Usuario',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Contraseña',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nombre',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<int>(
              hint: const Text('Selecciona un equipo'),
              items: teams.map((TeamModel team) {
                return DropdownMenuItem<int>(
                  value: team.idTeam,
                  child: Text(team.name),
                );
              }).toList(),
              onChanged: (int? newValue) {
                setState(() {
                  selectedTeamId = newValue;
                });
              },
              value: selectedTeamId,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _register,
              child: const Text('Registrarse'),
            ),
          ],
        ),
      ),
    );
  }
}
