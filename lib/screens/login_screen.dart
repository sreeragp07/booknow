import 'package:booknow/screens/dashboard_screen.dart';
import 'package:booknow/screens/signup_screen.dart';
import 'package:booknow/widgets/custom_elevated_button.dart';
import 'package:booknow/widgets/custom_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String? emailError;
  String? passwordError;
  bool isLoading = false;
  bool isVisible = false;

  void login() async {
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);
    setState(() {
      isLoading = true;
    });
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
          )
          .then((value) {
            messenger.showSnackBar(
              SnackBar(content: Text("Successfully Logged In")),
            );
            navigator.pushReplacement(
              MaterialPageRoute(builder: (_) => DashboardScreen()),
            );
          });
    } on FirebaseAuthException catch (e) {
      debugPrint("------------$e------------");
      if (e.code == "invalid-credential") {
        messenger.showSnackBar(SnackBar(content: Text("Invalid credentials")));
      } else {
        messenger.showSnackBar(SnackBar(content: Text("Login Failed")));
      }
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text("Login Failed")));
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  bool validate() {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    setState(() {
      // Email
      if (email.isEmpty) {
        emailError = "Email is required";
      } else if (!RegExp(
        r'^[\w\.\-]+@[\w\-]+\.[a-zA-Z]{2,4}$',
      ).hasMatch(email)) {
        emailError = "Invalid email address";
      } else {
        emailError = null;
      }

      // Password
      if (password.isEmpty) {
        passwordError = "Password is required";
      } else if (password.length < 6) {
        passwordError = "Password must be at least 6 characters";
      } else {
        passwordError = null;
      }
    });

    return emailError == null && passwordError == null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFECFDF5),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Welcome Back!",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF111827),
            ),
          ),
          SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                inputfield(
                  controller: emailController,
                  hintText: "Email",
                  errorMessage: emailError,
                  keyboardType: TextInputType.emailAddress,
                ),
                (emailError == null)
                    ? SizedBox(height: 20)
                    : SizedBox(height: 5),
                inputfield(
                  controller: passwordController,
                  hintText: "Password",
                  errorMessage: passwordError,
                  obscureText: !isVisible,
                  onPressed: () {
                    setState(() {
                      isVisible = !isVisible;
                    });
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: 30),
          Stack(
            alignment: Alignment.center,
            children: [
              customElevatedButton(
                label: "Login",
                onPressed: () {
                  if (!validate()) return;
                  login();
                },
              ),
              isLoading
                  ? CircularProgressIndicator(color: Colors.black)
                  : SizedBox.shrink(),
            ],
          ),
          SizedBox(height: 20),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'Not registered yet? ',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
                TextSpan(
                  text: 'Sign Up',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF059669),
                    fontSize: 16,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => SignupScreen()),
                      );
                    },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
