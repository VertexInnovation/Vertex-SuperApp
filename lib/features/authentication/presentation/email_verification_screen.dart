import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../auth_manager.dart';

class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({Key? key}) : super(key: key);

  @override
  _EmailVerificationScreenState createState() => _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  bool _isLoading = false;
  String? _error;
  bool _isVerified = false;

  @override
  void initState() {
    super.initState();
    _checkEmailVerification();
  }

  Future<void> _checkEmailVerification() async {
    final authManager = context.read<AuthManager>();
    final isVerified = await authManager.checkEmailVerification();
    
    if (mounted) {
      setState(() {
        _isVerified = isVerified;
      });
      
      if (isVerified) {
        // Navigate to home or dashboard
        Navigator.of(context).pushReplacementNamed('/home');
      }
    }
  }

  Future<void> _resendVerificationEmail() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final authManager = context.read<AuthManager>();
      final success = await authManager.sendVerificationEmail();
      
      if (mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Verification email sent successfully!')),
          );
        } else {
          setState(() {
            _error = 'Failed to send verification email';
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
        title: const Text('Verify Your Email'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.email_outlined,
              size: 80,
              color: Colors.blue,
            ),
            const SizedBox(height: 24),
            Text(
              'Verify Your Email Address',
              style: Theme.of(context).textTheme.headline5,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              _isVerified
                  ? 'Your email has been verified successfully!'
                  : 'We\'ve sent a verification link to your email. Please check your inbox and click the link to verify your account.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyText1,
            ),
            if (_error != null) ...[
              const SizedBox(height: 16),
              Text(
                _error!,
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
            ],
            const SizedBox(height: 32),
            if (!_isVerified) ...[
              ElevatedButton(
                onPressed: _isLoading ? null : _resendVerificationEmail,
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Resend Verification Email'),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: _checkEmailVerification,
                child: const Text('I\'ve verified my email'),
              ),
            ] else ...[
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed('/home');
                },
                child: const Text('Continue to App'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
