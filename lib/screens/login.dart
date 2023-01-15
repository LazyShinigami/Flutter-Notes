import 'package:flutter/material.dart';
import 'package:notes/screens/resetPassword.dart';
import 'package:notes/common.dart';
import 'package:notes/firebase/back_end_helper.dart';

class Login extends StatefulWidget {
  // Login({required this.user, super.key});
  // MyUser user;
  const Login({super.key, required this.showSignUpPage});
  final VoidCallback showSignUpPage;

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final AuthService _auth = AuthService();
  // _LoginState(this.user);
  // MyUser user;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final colors = ColorPallete();
  String errorMessage = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Image
                Container(
                  height: 250,
                  width: 250,
                  decoration: BoxDecoration(
                    border: Border.all(
                        width: 1.5, color: colors.purplePallete[900]!),
                    shape: BoxShape.circle,
                    color: const Color.fromARGB(138, 73, 19, 83),
                  ),
                  child: Image.asset("assets/catWhite.png"),
                ),
                const SizedBox(height: 30),

                // Login Title
                myText(
                  "Login",
                  weight: FontWeight.bold,
                  size: 36,
                  spacing: 5,
                  color: colors.purplePallete[800],
                ),

                // Error Message
                const SizedBox(height: 10),
                myText(
                  errorMessage,
                  color: Colors.orange,
                  weight: FontWeight.bold,
                ),
                const SizedBox(height: 10),

                // Text Fields
                MyTextField(
                  label: myText(
                    "E-mail",
                    spacing: 2,
                    weight: FontWeight.bold,
                    color: colors.purplePallete[800],
                  ),
                  controller: emailController,
                  hintText: "Enter your e-mail address",
                ),
                const SizedBox(height: 10),
                MyTextField(
                  label: myText(
                    "Password",
                    spacing: 2,
                    weight: FontWeight.bold,
                    color: colors.purplePallete[800],
                  ),
                  controller: passwordController,
                  hintText: "Enter your password",
                  obscureText: true,
                ),
                const SizedBox(height: 10),

                // Login Button
                TextButton(
                  onPressed: () async {
                    errorMessage = _validate(emailController.text.trim(),
                        passwordController.text.trim());

                    if (errorMessage.isEmpty) {
                      var error = await _auth.signInWithEmailAndPassword(
                        email: emailController.text.trim(),
                        password: passwordController.text.trim(),
                      );
                      if (error.runtimeType == String) {
                        errorMessage = error;
                        setState(() {});
                      }
                    } else {
                      setState(() {});
                    }
                  },
                  child: myText(
                    "Login",
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(height: 10),

                // Register Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    myText("New here?", spacing: 1),
                    const SizedBox(width: 5),
                    GestureDetector(
                      onTap: widget.showSignUpPage,
                      child: myText(
                        "Register now!",
                        weight: FontWeight.bold,
                        color: colors.purplePallete[700],
                        spacing: 1,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),

                // Forgot Password
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ResetPassword(),
                      ),
                    );
                  },
                  child: myText(
                    "Forgot Password?",
                    weight: FontWeight.bold,
                    color: colors.purplePallete[700],
                    spacing: 1,
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _validate(String email, String password) {
    if (email.isEmpty || password.isEmpty) {
      return "All fields are mandatory!";
    } else {
      return "";
    }
  }
}
