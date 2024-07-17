import 'package:flutter/material.dart';
import 'package:pedia_predict/auth/signup_page.dart';
import 'package:pedia_predict/gradient_scaffold.dart';
import 'package:pedia_predict/utils/database_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgotPasswordPage extends StatelessWidget {
  final DatabaseHelper dbHelper;

  const ForgotPasswordPage({super.key, required this.dbHelper});

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();

    Future<void> resetPassword() async {
      try {
        await FirebaseAuth.instance.sendPasswordResetEmail(
          email: emailController.text,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Password reset email sent')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to reset password: ${e.toString()}')),
        );
      }
    }

    return GradientScaffold(
      appBarText: "Pedia Predict",
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 50),
              const Text(
                "Oh, no !\nI forgot",
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Enter your email, phone, or username and we'll send you a link to change a new password",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
              const SizedBox(height: 30),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: "Username, Email or Phone Number",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: resetPassword,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                  ),
                  child: const Text("Forgot Password"),
                ),
              ),
              const Spacer(),
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SignUpPage(dbHelper: dbHelper),
                      ),
                    );
                  },
                  child: const Text(
                    "Don't have an account ? Sign Up",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
