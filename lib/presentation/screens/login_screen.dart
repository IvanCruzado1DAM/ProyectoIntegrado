import 'package:flutter/material.dart';
import 'package:football_zone/services/user_services.dart';
import 'register_screen.dart';
import 'user_screen.dart';
import 'player_screen.dart';
import 'president_screen.dart';
import 'physio_screen.dart';
import 'dietist_screen.dart';
import 'coach_screen.dart';
import 'package:football_zone/models/users.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [BackGround(), Content()],
      ),
    );
  }
}

class Content extends StatefulWidget {
  const Content({Key? key}) : super(key: key);

  @override
  _ContentState createState() => _ContentState();
}

class _ContentState extends State<Content> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Football Zone',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 30,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          const SizedBox(
            height: 15,
          ),
          const LoginForm(),
        ],
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final UserService _userService = UserService(); // Instancia de UserService

  String username = "";
  String password = "";
  bool isObscure = true;

  void _navigateBasedOnRole(UserData userData) {
    String? role = userData.role;
    switch (role) {
      case 'ROLE_USER':
        /*Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => UserScreen(token: token)),
        );*/
        break;
      case 'ROLE_PLAYER':
      Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PlayerScreen(user: userData)),
        );
        break;
      case 'ROLE_PRESIDENT':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PresidentScreen(user: userData)),
        );
        break;
      case 'ROLE_PHYSIO':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PhysioScreen(user: userData)),
        );
        break;
      case 'ROLE_DIETIST':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DietistScreen(user: userData)),
        );
        break;
      case 'ROLE_COACH':
        /*Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CoachScreen(user: userData)),
        );*/
        break;
      default:
        print('Unknown role: $role');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Username',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          TextFormField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Enter your username',
            ),
            onChanged: (value) {
              setState(() {
                username = value;
              });
            },
          ),
          const SizedBox(
            height: 5,
          ),
          const Text(
            'Password',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          TextFormField(
            obscureText: isObscure,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              hintText: 'Enter your password',
              suffixIcon: IconButton(
                icon: Icon(
                  isObscure ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() {
                    isObscure = !isObscure;
                  });
                },
              ),
            ),
            onChanged: (value) {
              setState(() {
                password = value;
              });
            },
          ),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                print("Username:"+username);
                _userService.login(username, password).then((result) {
                  if (result.error != null) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Error'),
                          content: const Text('Credenciales Incorrectas'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('OK', style: TextStyle(color: Colors.white)),
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.red,
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  } else {       
                    UserData userData=result.userData!;    
                    _navigateBasedOnRole(userData);
                  }
                }).catchError((error) {
                  print("Error: $error");
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff142047),
              ),
              child: const Text(
                'Login',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const RegisterScreen()),
              );
            },
            child: const Center(
              child: Text(
                'Register',
                style: TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BackGround extends StatelessWidget {
  const BackGround({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
        colors: [Colors.blue.shade300, Colors.blue],
        begin: Alignment.centerRight,
        end: Alignment.centerLeft,
      )),
    );
  }
}
