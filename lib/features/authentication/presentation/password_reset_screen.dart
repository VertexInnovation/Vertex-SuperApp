import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../auth_manager.dart';

class PasswordResetScreen extends StatefulWidget {
  const PasswordResetScreen({Key? key}) : super(key: key);

  @override
  _PasswordResetScreenState createState() => _PasswordResetScreenState();
}

class _PasswordResetScreenState extends State<PasswordResetScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;
  bool _isEmailSent = false;
  String? _error;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _sendResetEmail() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final authManager = context.read<AuthManager>();
      final success = await authManager.sendPasswordResetEmail(_emailController.text.trim());
      
      if (mounted) {
        if (success) {
          setState(() {
            _isEmailSent = true;
          });
        } else {
          setState(() {
            _error = 'Failed to send password reset email';
          });
        }
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reset Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),
              const Icon(
                Icons.lock_reset,
                size: 80,
                color: Colors.blue,
              ),
              const SizedBox(height: 24),
              Text(
                'Reset Your Password',
                style: Theme.of(context).textTheme.headline5,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              if (_isEmailSent) ...[
                const Text(
                  'We\'ve sent a password reset link to your email. Please check your inbox and follow the instructions to reset your password.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Return to Login'),
                ),
              ] else ...[
                const Text(
                  'Enter your email address and we\'ll send you a link to reset your password.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!value.contains('@')) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                if (_error != null) ...[
                  const SizedBox(height: 16),
                  Text(
                    _error!,
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                ],
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _isLoading ? null : _sendResetEmail,
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Send Reset Link'),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Back to Login'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
