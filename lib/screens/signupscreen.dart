import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:instagram/screens/loginscreen.dart';
import 'package:instagram/services/authentication.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailcontroller = TextEditingController();
  final TextEditingController passwordcontroller = TextEditingController();
  final TextEditingController usernamecontroller = TextEditingController();
  bool isloading = false;

  void registerUser() async {
    final registerationValidation = _formKey.currentState!.validate();
    if (registerationValidation) {
      setState(() {
        isloading = true;
      });
      try {
        final result = await Authentication().signUpUser(
            email: emailcontroller.text,
            password: passwordcontroller.text,
            username: usernamecontroller.text,
            context: context);
        if (result == 'success') {
          if (mounted) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Account Successfully Created")),
            );
          }
        }
        setState(() {
          isloading = false;
        });
      } on FirebaseAuthException catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(e.code.toString())));
        }
      }
    }
  }

  @override
  void dispose() {
    emailcontroller.dispose();
    passwordcontroller.dispose();
    usernamecontroller.dispose();
    super.dispose();
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
                  SizedBox(height: size.height * 0.09),
                  Center(
                    child: Text(
                      "Instagram",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.xanhMono(
                          fontSize: 60, fontWeight: FontWeight.bold),
                    ),
                  ),
                  TextFormField(
                    style: TextStyle(
                        color: Theme.of(context).textTheme.bodyMedium!.color),
                    decoration: InputDecoration(
                      label: const Text("User Name"),
                      labelStyle: TextStyle(
                          color: Theme.of(context).textTheme.bodyMedium!.color),
                    ),
                    controller: usernamecontroller,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "enter a username";
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: size.height * 0.03,
                  ),
                  TextFormField(
                    style: TextStyle(
                        color: Theme.of(context).textTheme.bodyMedium!.color),
                    decoration: InputDecoration(
                      label: const Text("Email"),
                      labelStyle: TextStyle(
                          color: Theme.of(context).textTheme.bodyMedium!.color),
                    ),
                    controller: emailcontroller,
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
                    style: TextStyle(
                        color: Theme.of(context).textTheme.bodyMedium!.color),
                    decoration: InputDecoration(
                      label: const Text("Password"),
                      labelStyle: TextStyle(
                          color: Theme.of(context).textTheme.bodyMedium!.color),
                    ),
                    obscureText: true,
                    controller: passwordcontroller,
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
                    onPressed: registerUser,
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
                            "Sign Up",
                            style: TextStyle(fontSize: 18),
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
                      Text("Sign up with facebook")
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
                        "already have an account?",
                        style: TextStyle(fontSize: 15),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context)
                              .pushReplacement(MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ));
                        },
                        child: const Text(
                          "Login in",
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
