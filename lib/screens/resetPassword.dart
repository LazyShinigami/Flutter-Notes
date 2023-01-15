import 'package:flutter/material.dart';
import 'package:notes/firebase/back_end_helper.dart';
import 'package:notes/common.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  TextEditingController emailController = TextEditingController();
  final AuthService _auth = AuthService();
  final colors = ColorPallete();
  Color messageColor = Colors.orange;
  String errorMessage = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
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
                  child: Image.asset("assets/bear.png"),
                ),
                const SizedBox(height: 30),

                // Title
                myText(
                  "Enter your registered E-mail. We'll send a reset link!",
                  weight: FontWeight.bold,
                  size: 20,
                  // spacing: 1,
                  color: colors.purplePallete[800],
                ),

                // Error Message
                const SizedBox(height: 10),
                myText(
                  errorMessage,
                  color: messageColor,
                  weight: FontWeight.bold,
                ),
                const SizedBox(height: 10),

                // Text Field
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

                // Login Button
                TextButton(
                  onPressed: () async {
                    errorMessage = (emailController.text.trim().isEmpty)
                        ? "All fields are mandatory!"
                        : "";

                    if (errorMessage.isEmpty) {
                      var error = await _auth.resetPassword(
                          email: emailController.text.trim());
                      if (error != null) {
                        errorMessage = error;
                      }
                    }
                    if (errorMessage.isEmpty) {
                      errorMessage = "E-mail sent. Check your inbox!";
                      messageColor = Colors.green;
                    }
                    setState(() {});
                  },
                  child: myText(
                    "Send me a reset link!",
                    color: Colors.white,
                    size: 20,
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
}
