import 'package:flutter/material.dart';
import '../widgets/auth_button.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign In')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AuthButton(
                text: 'Sign In',
                onPressed: () {
                  // Handle sign in
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
