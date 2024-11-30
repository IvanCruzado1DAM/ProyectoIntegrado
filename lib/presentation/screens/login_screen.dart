import 'package:flutter/material.dart';
import 'package:BarDamm/services/user_services.dart';
import 'user_screen.dart';
import 'package:BarDamm/models/user.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final UserService _userService = UserService();
  String username = "";
  String password = "";
  bool isObscure = true;
  String loginError = ""; 

  void _navigateBasedOnRole(UserData userData) {
    String? role = userData.role;
    String? token = userData.token;
    int? idUser = userData.idUser;
    String? username=userData.username;
    switch (role) {
      case 'ROLE_USER':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => UserScreen(token: token!, idUser: idUser!, username:username!)),
        );
        break;
      case 'ROLE_COACH':
        break;
      default:
        print('Unknown role: $role');
    }
  }

  Future<void> _login() async {
    final result = await _userService.login(username, password);

    if (result.error != null) {
      setState(() {
        loginError = result.error!; 
      });
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: Text(loginError),
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
      UserData userData = result.userData!;
      _navigateBasedOnRole(userData); 
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    "assets/images/fondologinapp.jpg"), 
                fit: BoxFit
                    .cover, 
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 15),
                Image.asset(
                  'assets/images/file.png',
                  height: 150, 
                  width: 150,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 15),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color:
                        Colors.white.withOpacity(0.8), 
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Username', style: TextStyle(fontSize: 20)),
                      TextFormField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Enter your username',
                        ),
                        onChanged: (value) => setState(() => username = value),
                      ),
                      const SizedBox(height: 10),
                      const Text('Password', style: TextStyle(fontSize: 20)),
                      TextFormField(
                        obscureText: isObscure,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          hintText: 'Enter your password',
                          suffixIcon: IconButton(
                            icon: Icon(
                              isObscure
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () =>
                                setState(() => isObscure = !isObscure),
                          ),
                        ),
                        onChanged: (value) => setState(() => password = value),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _login, 
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff142047),
                          ),
                          child: const Text('Login',
                              style: TextStyle(color: Colors.white)),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const RegisterScreen()),
                            );
                          },
                          child: const Text(
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
                ),
              ],
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
        ),
      ),
    );
  }
}
