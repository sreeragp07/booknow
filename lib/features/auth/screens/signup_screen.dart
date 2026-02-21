import 'package:booknow/widgets/custom_elevated_button.dart';
import 'package:booknow/widgets/custom_text_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  String? fullNameError;
  String? emailError;
  String? passwordError;
  String? confirmPasswordError;
  bool isLoading = false;
  String selectedRole = "user";

  bool validate() {
    String fullName = nameController.text.trim();
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();

    setState(() {
      // Full name
      if (fullName.isEmpty) {
        fullNameError = "Full name is required";
      } else {
        fullNameError = null;
      }

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

      // Confirm password
      if (confirmPassword.isEmpty) {
        confirmPasswordError = "Password is required";
      } else if (confirmPassword != password) {
        confirmPasswordError = "Passwords do not match";
      } else {
        confirmPasswordError = null;
      }
    });

    return fullNameError == null &&
        emailError == null &&
        passwordError == null &&
        confirmPasswordError == null;
  }

  void signUp() async {
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);
    try {
      setState(() {
        isLoading = true;
      });
      final userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
          );

      final user = userCredential.user;

      /// Store user details in users collection
      await FirebaseFirestore.instance.collection('users').doc(user!.uid).set({
        'name': nameController.text.trim(),
        'email': emailController.text.trim(),
        'role': selectedRole,
      });

      /// If user is professional → create professional document
      if (selectedRole == "professional") {
        await FirebaseFirestore.instance
            .collection('professionals')
            .doc(user.uid)
            .set({
              'name': nameController.text.trim(),
              'experience': 0,
              'rating': 0,
              'pricePerHour': 0,
              'availabilityStatus': false,
              'categoryId': '',
              'categoryName': '',
            });
      }

      messenger.showSnackBar(
        const SnackBar(content: Text("Successfully registered")),
      );

      navigator.pop();
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text("Failed to register")));
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFECFDF5),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Register Now",
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
                  controller: nameController,
                  hintText: "Full Name",
                  errorMessage: fullNameError,
                ),
                (fullNameError == null)
                    ? SizedBox(height: 20)
                    : SizedBox(height: 5),
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
                ),
                (passwordError == null)
                    ? SizedBox(height: 20)
                    : SizedBox(height: 5),
                inputfield(
                  controller: confirmPasswordController,
                  hintText: "Confirm Password",
                  errorMessage: confirmPasswordError,
                ),
                SizedBox(height: 20),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Register As",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),

                    Column(
                      children: [
                        SizedBox(height: 5),
                        RadioListTile<String>(
                          dense: true,
                          visualDensity: VisualDensity.compact,

                          contentPadding: EdgeInsets.symmetric(horizontal: 0),
                          title: const Text(
                            "User",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                          value: "user",
                          groupValue: selectedRole,
                          onChanged: (value) {
                            setState(() {
                              selectedRole = value!;
                            });
                          },
                        ),

                        RadioListTile<String>(
                          dense: true,
                          visualDensity: VisualDensity.compact,

                          contentPadding: EdgeInsets.symmetric(horizontal: 0),
                          title: const Text(
                            "Professional",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                          value: "professional",
                          groupValue: selectedRole,
                          onChanged: (value) {
                            setState(() {
                              selectedRole = value!;
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Stack(
            alignment: AlignmentGeometry.center,
            children: [
              customElevatedButton(
                label: "Sign Up",
                onPressed: () {
                  if (!validate()) return;
                  signUp();
                },
              ),
              isLoading
                  ? CircularProgressIndicator(color: Colors.black)
                  : SizedBox.shrink(),
            ],
          ),
          SizedBox(height: 17),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Text(
              "Back to Login",
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: const Color(0xFF059669),
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
