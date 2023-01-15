import 'package:flutter/material.dart';
import 'package:notes/common.dart';
import 'package:notes/firebase/back_end_helper.dart';

class SignUp extends StatefulWidget {
  final VoidCallback showLoginPage;

  const SignUp({super.key, required this.showLoginPage});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final AuthService _auth = AuthService();
  TextEditingController nameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController rePasswordController = TextEditingController();
  final colors = ColorPallete();
  String errorMessage = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(25, 30, 25, 0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Image
                Container(
                  height: 150,
                  width: 150,
                  decoration: BoxDecoration(
                    border: Border.all(
                        width: 1.5, color: colors.purplePallete[900]!),
                    shape: BoxShape.circle,
                    color: const Color.fromARGB(138, 73, 19, 83),
                  ),
                  child: Image.asset("assets/parrot.png"),
                ),
                const SizedBox(height: 30),

                // Login Title
                myText(
                  "Sign Up",
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
                // Name
                MyTextField(
                  label: myText(
                    "Name",
                    spacing: 2,
                    weight: FontWeight.bold,
                    color: colors.purplePallete[800],
                  ),
                  controller: nameController,
                  hintText: "Enter your name",
                ),
                const SizedBox(height: 10),

                // Username
                MyTextField(
                  label: myText(
                    "Username",
                    spacing: 2,
                    weight: FontWeight.bold,
                    color: colors.purplePallete[800],
                  ),
                  controller: usernameController,
                  hintText: "What should we call you?",
                ),
                const SizedBox(height: 10),

                // E-mail
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

                // Password
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

                // Re-Password
                MyTextField(
                  label: myText(
                    "Re-Password",
                    spacing: 2,
                    weight: FontWeight.bold,
                    color: colors.purplePallete[800],
                  ),
                  controller: rePasswordController,
                  hintText: "Re-enter your password",
                  obscureText: true,
                ),
                const SizedBox(height: 10),

                // SignUp Button
                TextButton(
                  onPressed: () async {
                    errorMessage = _validate(
                      nameController.text,
                      usernameController.text.trim(),
                      emailController.text.trim(),
                      passwordController.text,
                      rePasswordController.text,
                    );

                    if (errorMessage.isEmpty) {
                      var error = await _auth.signUpWithUserCredentials(
                        name: nameController.text,
                        username: usernameController.text.trim(),
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
                    "Sign Up",
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(height: 10),

                // Login Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    myText("Already have an account?", spacing: 1),
                    const SizedBox(width: 5),

                    // Link
                    GestureDetector(
                      // onTap: () {
                      //   Navigator.pushAndRemoveUntil(
                      //       context,
                      //       MaterialPageRoute(builder: (context) => Login()),
                      //       (route) => false);
                      // },
                      onTap: widget.showLoginPage,
                      child: myText(
                        "Login!",
                        weight: FontWeight.bold,
                        color: colors.purplePallete[700],
                        spacing: 1,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _validate(String name, String username, String email, String password,
      String rePassword) {
    String flag = validateName(name);
    if (flag.isEmpty) {
      flag = validateUsername(username);
    }
    if (flag.isEmpty) {
      flag = validateEmail(email);
    }
    if (flag.isEmpty) {
      flag = validatePasssword(password);
    }
    if (flag.isEmpty) {
      flag = validateRePassword(password, rePassword);
    }

    return flag;
  }

  // valiation functions
  String validateName(String name) {
    String errorMessage = "";
    bool flag = false;
    if (name.isEmpty) {
      errorMessage = "Empty Name field!";
    } else if (name.contains(RegExp('[~`!@#%^&*()-+={}[]:;"<>,.?/]')) ||
        name.contains("_")) {
      errorMessage = "Name can only contain letters";
    } else {
      flag = true;
    }
    // setState(() {});
    return errorMessage;
  }

  String validateUsername(String username) {
    bool flag = false;
    String errore = "";
    if (username.isEmpty) {
      errore = "Empty Username field!";
    } else if (username[0].contains(RegExp('[0123456789]'))) {
      errore = "Username cannot begin with a number!";
    } else if (username.contains(' ')) {
      errore = "Username cannot have spaces!";
    } else if (username.contains(RegExp('[!@#\$\\/.,{`}?<>:;"\'+%^&*()+~]'))) {
      errore =
          "Username may only have alphanumeric characters and underscores!";
    } else if (username.length < 5) {
      errore = "Username too short! [5-10]";
    } else if (username.length > 10) {
      errore = "Username too long! [5-10]";
    } else {
      flag = true;
    }
    return errore;
  }

  String validateEmail(String email) {
    String error = "";
    if (email.isEmpty) {
      error = "Empty E-mail field!";
    }
    // setState(() {});
    return error;
  }

  String validatePasssword(String password) {
    bool flag = false;
    String error = "";
    if (password.isEmpty) {
      error = "Empty Password field!";
    } else if (password.length < 8) {
      error = "Password too short!";
    } else {
      flag = true;
    }
    return error;
  }

  String validateRePassword(String password, String rePassword) {
    bool flag = false;
    String error = "";
    if (rePassword.isEmpty) {
      error = "Empty Confirm Password field!";
    } else if (password != rePassword) {
      error = "Passwords do not match!";
    } else {
      flag = true;
    }
    return error;
  }
}
