import 'package:booknow/screens/login_screen.dart';
import 'package:booknow/widgets/custom_elevated_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool isLoading = false;

  void signout() async {
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);
    setState(() {
      isLoading = true;
    });
    try {
      await FirebaseAuth.instance.signOut().then((value) {
        messenger.showSnackBar(
          SnackBar(content: Text("Successfully Logged out")),
        );
        navigator.pushReplacement(
          MaterialPageRoute(builder: (_) => LoginScreen()),
        );
      });
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text("Failed to Log out")));
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Hello Buddy!",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Welcome to Dashboard",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w500,
                color: Colors.brown[900],
              ),
            ),
            SizedBox(height: 30),
            Stack(
              alignment: Alignment.center,
              children: [
                customElevatedButton(
                  label: "Log Out",
                  onPressed: () {
                    signout();
                  },
                ),
                isLoading
                    ? CircularProgressIndicator(color: Colors.black)
                    : SizedBox.shrink(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
