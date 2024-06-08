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
      print('Failed to load teams: $e');
    }
  }

  void _register() async {
    if (selectedTeamId == null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Please select a team'),
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
        Navigator.of(context).pop();
      }
    } catch (e) {
      print('Registration failed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<int>(
              hint: const Text('Select Team'),
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
              child: const Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
