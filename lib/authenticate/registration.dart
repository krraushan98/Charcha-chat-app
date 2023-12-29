import 'package:flutter/material.dart';
import '../services/auth.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class Registration extends StatefulWidget {
  final Function toggleView;
  const Registration({super.key, required this.toggleView});

  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  final AuthServices _auth = AuthServices();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _namecontroller = TextEditingController();

  String email = '';
  String password = '';
  String name = " ";
  String error = '';
  bool isLoading = false;

  void _showErrorSnackBar(String errorMessage) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(errorMessage),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  bool _isObscure = true; // Add this variable

  void _togglePasswordVisibility() {
    setState(() {
      _isObscure = !_isObscure;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        alignment: Alignment.center,
        children: [
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assests/image.png',
                    height: 250,
                  ),
                  const SizedBox(
                    height: 40.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: TextField(
                      controller: _namecontroller,
                      decoration: const InputDecoration(
                        hintText: 'Name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: TextField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        hintText: 'Email',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: TextField(
                      controller: _passwordController,
                      obscureText: _isObscure,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isObscure
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: _togglePasswordVisibility,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 30.0),
                    child: ElevatedButton(
                      onPressed: isLoading
                          ? null
                          : () async {
                              setState(() {
                                email = _emailController.text;
                                password = _passwordController.text;
                                name = _namecontroller.text;
                                error = '';
                                isLoading = true;
                              });
                              if (email == '' || password == '' || name == '') {
                                setState(() {
                                  error = 'Please fill all the fields';
                                });
                                _showErrorSnackBar(error);
                                setState(() {
                                  isLoading = false;
                                });
                              } else if (password.length < 6) {
                                setState(() {
                                  error =
                                      'Password must be at least 6 characters long';
                                });
                                _showErrorSnackBar(error);
                                setState(() {
                                  isLoading = false;
                                });
                              } else if (name == "Admin" || name == "admin") {
                                setState(() {
                                  error = 'Name cannot be Admin';
                                });
                                _showErrorSnackBar(error);
                                setState(() {
                                  isLoading = false;
                                });
                              } else {
                                dynamic result =
                                    await _auth.registerWithEmailAndPassword(
                                        name, email, password);
                                if (result == null) {
                                  setState(() {
                                    error = 'Please supply a valid email';
                                  });
                                  _showErrorSnackBar(error);
                                }
                                setState(() {
                                  isLoading = false;
                                });
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        primary: Color.fromARGB(235, 37, 142, 212),
                        onPrimary: Color.fromARGB(255, 251, 251, 251),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Text(
                          'Sign up',
                          style: TextStyle(
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Already have an account?",
                        style: TextStyle(
                          fontSize: 15.0,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          widget.toggleView();
                        },
                        child: const Text(
                          'Sign in',
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Color.fromARGB(235, 37, 142, 212),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: LoadingAnimationWidget.staggeredDotsWave(
                  color: const Color.fromARGB(255, 205, 158, 76),
                  size: 70,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
