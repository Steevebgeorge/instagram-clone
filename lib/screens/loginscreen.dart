import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:instagram/screens/signupscreen.dart';
import 'package:instagram/services/authentication.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailcontroller = TextEditingController();
  final TextEditingController passwordcontroller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isloading = false;

  @override
  void dispose() {
    emailcontroller.dispose();
    passwordcontroller.dispose();
    super.dispose();
  }

  loginInUser() async {
    final loginValidation = _formKey.currentState!.validate();
    if (loginValidation) {
      try {
        setState(() {
          isloading = true;
        });
        Authentication().logInUser(
          email: emailcontroller.text,
          password: passwordcontroller.text,
        );
        setState(() {
          isloading = false;
        });
      } on FirebaseAuthException catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.message.toString())),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(50),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(
                    height: size.height * 0.09,
                  ),
                  Center(
                    child: Text(
                      "Instagram",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.xanhMono(
                          fontSize: 60, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.03,
                  ),
                  TextFormField(
                    controller: emailcontroller,
                    style: TextStyle(
                        color: Theme.of(context).textTheme.bodyMedium!.color),
                    decoration: InputDecoration(
                      label: const Text("Email"),
                      labelStyle: TextStyle(
                          color: Theme.of(context).textTheme.bodyMedium!.color),
                    ),
                    validator: (value) {
                      if (value == null ||
                          value.trim().isEmpty ||
                          !value.contains("@")) {
                        return "Enter a valid email address";
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  TextFormField(
                    controller: passwordcontroller,
                    style: TextStyle(
                        color: Theme.of(context).textTheme.bodyMedium!.color),
                    decoration: InputDecoration(
                      label: const Text("Password"),
                      labelStyle: TextStyle(
                          color: Theme.of(context).textTheme.bodyMedium!.color),
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value == null ||
                          value.trim().isEmpty ||
                          value.trim().length < 6) {
                        return "Passwords must be at least 6 characters";
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  ElevatedButton(
                    onPressed: loginInUser,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context)
                          .elevatedButtonTheme
                          .style!
                          .backgroundColor
                          ?.resolve(
                        {MaterialState.pressed},
                      ),
                      fixedSize: const Size(300, 50),
                    ),
                    child: !isloading
                        ? const Text(
                            "Log in",
                            style: TextStyle(fontSize: 20),
                          )
                        : const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          ),
                  ),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.facebook,
                        color: Colors.blue,
                      ),
                      SizedBox(
                        width: 7,
                      ),
                      Text("Log in with facebook")
                    ],
                  ),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  const Text("OR"),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Dont't have an account?",
                        style: TextStyle(fontSize: 15),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const SignUpScreen(),
                          ));
                        },
                        child: const Text(
                          "Sign up",
                          style: TextStyle(color: Colors.blue, fontSize: 15),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
