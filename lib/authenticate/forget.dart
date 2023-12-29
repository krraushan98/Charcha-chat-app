import 'package:flutter/material.dart';
import 'package:flutter_firebase/services/auth.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ForgetPage extends StatefulWidget {
  const ForgetPage({Key? key});

  @override
  State<ForgetPage> createState() => _ForgetPageState();
}

class _ForgetPageState extends State<ForgetPage> {
  String email = '';
  String error = '';
  final _emailController = TextEditingController();
  final AuthServices _auth = AuthServices();
  bool isLoading = false;

  void _showErrorSnackBar(String errorMessage) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(errorMessage),
        duration: const Duration(seconds: 3),
      ),
    );
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
                  const SizedBox(
                    height: 20.0,
                  ),
                  ElevatedButton(
                    onPressed: isLoading
                        ? null
                        : () async {
                            setState(() {
                              email = _emailController.text;
                              error = '';
                              isLoading = true;
                            });
                            if (email == '') {
                              setState(() {
                                error = 'Please fill in the email field';
                              });
                              _showErrorSnackBar(error);
                              setState(() {
                                isLoading = false;
                              });
                            } else {
                              await _auth.resetPassword(email);
                              setState(() {
                                error = 'Reset password link has been sent to your email';
                              });
                              _showErrorSnackBar(error);
                              Navigator.pop(context);
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      primary: Color.fromARGB(235, 37, 142, 212),
                      onPrimary: Color.fromARGB(255, 255, 255, 253),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(
                        'Reset Password',
                        style: TextStyle(
                          fontSize: 20.0,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
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
                  color:const Color.fromARGB(255, 205, 158, 76),
                  size: 70,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
