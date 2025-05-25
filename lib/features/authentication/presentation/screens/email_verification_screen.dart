import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../auth_manager.dart';
import '../signin_page.dart';
import '../signup_page.dart';
import '../widgets/auth_button.dart';
import '../../../../main.dart'; // For VertexColors

class EmailVerificationScreen extends StatefulWidget {
  final String email;
  final String? displayName; // Add this for re-signup

  const EmailVerificationScreen({
    Key? key,
    required this.email,
    this.displayName,
  }) : super(key: key);

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  bool _isResending = false;
  bool _canResend = true;
  int _resendCooldown = 0;
  Timer? _cooldownTimer;

  @override
  void dispose() {
    _cooldownTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(
                Icons.mark_email_unread_outlined,
                size: 100,
                color: VertexColors.deepSapphire,
              ),
              const SizedBox(height: 32),
              Text(
                'Verify Your Email',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: VertexColors.deepSapphire,
                    ),
              ),
              const SizedBox(height: 16),
              Text(
                'We\'ve sent a verification link to:',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 8),
              Text(
                widget.email,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: VertexColors.ceruleanBlue,
                    ),
              ),
              const SizedBox(height: 24),
              Text(
                'Please check your email and click the verification link. Don\'t forget to check your spam folder!',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 40),

              // Resend button with cooldown

              AuthButton(
                text: _isResending
                    ? 'Resending...'
                    : _canResend
                        ? 'Resend Verification Email'
                        : 'Resend in ${_resendCooldown}s',
                isLoading: _isResending,
                onPressed: _canResend
                    ? () => _resendEmail()
                    : null, // Fixed: Wrap in anonymous function
                backgroundColor: VertexColors.ceruleanBlue,
              ),

              const SizedBox(height: 16),

              // Try different email button
              AuthButton(
                text: 'Use Different Email',
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const SignUpPage()),
                  );
                },
                backgroundColor: VertexColors.deepSapphire,
              ),
              const SizedBox(height: 16),

              // Back to sign in
              AuthButton(
                text: 'Back to Sign In',
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const SignInPage()),
                  );
                },
                backgroundColor: VertexColors.deepSapphire,
              ),

              const SizedBox(height: 24),

              // Help text
              Text(
                'Still not receiving emails? Check your spam folder or contact support.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _resendEmail() async {
    setState(() => _isResending = true);

    final authManager = Provider.of<AuthManager>(context, listen: false);
    final success = await authManager.resendVerificationEmail();

    if (mounted) {
      setState(() => _isResending = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(success
              ? 'Verification email sent successfully!'
              : authManager.error ?? 'Failed to send email'),
          backgroundColor: success ? Colors.green : Colors.red,
        ),
      );
    }
  }

  void _startCooldown() {
    setState(() {
      _canResend = false;
      _resendCooldown = 60; // 60 second cooldown
    });

    _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _resendCooldown--;
          if (_resendCooldown <= 0) {
            _canResend = true;
            timer.cancel();
          }
        });
      } else {
        timer.cancel();
      }
    });
  }
}
