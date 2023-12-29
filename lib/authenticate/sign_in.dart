import 'package:flutter/material.dart';
import 'package:flutter_firebase/authenticate/forget.dart';
import 'package:flutter_firebase/services/auth.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;

  const SignIn({Key? key, required this.toggleView}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthServices _auth = AuthServices();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String email = '';
  String password = '';
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
                      decoration:  InputDecoration(
                        hintText: 'Password',
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isObscure ? Icons.visibility : Icons.visibility_off,
                          ),
                          onPressed: _togglePasswordVisibility,
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 25, 0),
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ForgetPage(),
                              ),
                            );
                          },
                          child: const Text(
                            'Forget Password?',
                            style: TextStyle(
                              fontSize: 15.0,
                              color: Color.fromARGB(235, 37, 142, 212),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: isLoading
                        ? null
                        : () async {
                            setState(() {
                              email = _emailController.text;
                              password = _passwordController.text;
                              error = '';
                              isLoading = true;
                            });
                            if (email == '' || password == '') {
                              setState(() {
                                error = 'Please fill all the fields';
                              });
                              _showErrorSnackBar(error);
                              setState(() {
                                isLoading = false;
                              });
                            } else {
                              dynamic result = await _auth
                                  .signInWithEmailAndPassword(email, password);
                              if (result == null) {
                                setState(() {
                                  error = 'Invalid email or password';
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
                      onPrimary: Color.fromARGB(255, 255, 255, 253),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.fromLTRB(20, 20.0, 20, 20.0),
                      child: Text(
                        'Sign in',
                        style: TextStyle(
                          fontSize: 20.0,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Not a member yet?",
                        style: TextStyle(
                          fontSize: 15.0,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          widget.toggleView();
                        },
                        child: const Text(
                          'Register',
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
