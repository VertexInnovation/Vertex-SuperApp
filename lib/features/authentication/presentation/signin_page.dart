import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vertex_app/features/authentication/presentation/screens/forgot_password.dart';
import '../auth_manager.dart';
import 'signup_page.dart';
import 'widgets/auth_button.dart';
import 'widgets/auth_text_field.dart';
import '../../../main.dart'; // Import for VertexColors

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<AuthManager>(
        builder: (context, authManager, _) {
          return SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Logo container with gradient background
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: const BoxDecoration(
                          gradient: RadialGradient(
                            colors: [
                              VertexColors.honeyedAmberLight,
                              VertexColors.honeyedAmber
                            ],
                            radius: 0.8,
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.school,
                          size: 80,
                          color: VertexColors.deepSapphire,
                        ),
                      ),
                      const SizedBox(height: 24),

                      Text(
                        'Welcome Back',
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                              color: VertexColors.deepSapphire,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 8),

                      Text(
                        'Sign in to continue',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Colors.black54,
                            ),
                      ),
                      const SizedBox(height: 32),

                      // Error message if any
                      if (authManager.error != null) ...[
                        Container(
                          padding: const EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                            color: Colors.red.shade50,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.red.shade200),
                          ),
                          child: Text(
                            authManager.error!,
                            style: TextStyle(color: Colors.red.shade700),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],

                      // Email field with updated style
                      AuthTextField(
                        controller: _emailController,
                        label: 'Email',
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon: Icons.email_outlined,
                        fillColor: VertexColors.lightAmethyst.withOpacity(0.1),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Email is required';
                          }
                          if (!value.contains('@') || !value.contains('.')) {
                            return 'Enter a valid email address';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Password field with updated style
                      AuthTextField(
                        controller: _passwordController,
                        label: 'Password',
                        obscureText: _obscurePassword,
                        prefixIcon: Icons.lock_outline,
                        fillColor: VertexColors.lightAmethyst.withOpacity(0.1),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: VertexColors.ceruleanBlue,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Password is required';
                          }
                          return null;
                        },
                      ),

                      // Forgot password
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            // Implement forgot password
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const ForgotPassword()),
                            );
                          },
                          child: const Text(
                            'Forgot Password?',
                            style: TextStyle(
                              color: VertexColors.ceruleanBlue,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Sign in button with updated style
                      AuthButton(
                        text: 'Sign In',
                        isLoading: authManager.loading,
                        onPressed: _signIn,
                        backgroundColor: VertexColors.deepSapphire,
                      ),
                      const SizedBox(height: 24),

                      // Or divider with updated style
                      Row(
                        children: [
                          Expanded(
                            child: Divider(
                              color: Colors.grey.shade300,
                              thickness: 1,
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text(
                              'OR',
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              color: Colors.grey.shade300,
                              thickness: 1,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Social sign in buttons with updated style
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildSocialButton(
                            icon: "assets/icons/google-icon.png",
                            color: VertexColors.deepSapphire,
                            onPressed: _signInWithGoogle,
                            size: 10.0,
                          ),
                          const SizedBox(width: 16),
                          _buildSocialButton(
                            icon: "assets/icons/facebook-icon.png",
                            color: VertexColors.ceruleanBlue,
                            size: 8,
                            onPressed: _signInWithFacebook,
                          ),
                          const SizedBox(width: 16),
                          _buildSocialButton(
                            icon: "assets/icons/github-icon.png",
                            color: Colors.black,
                            size: 13,
                            onPressed: _signInWithGithub,
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),

                      // Sign up link with updated style
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account? ",
                            style: TextStyle(color: Colors.grey.shade700),
                          ),
                          TextButton(
                            onPressed: () {
                              Provider.of<AuthManager>(context, listen: false)
                                  .clearError();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SignUpPage(),
                                ),
                              );
                            },
                            child: const Text(
                              'Sign Up',
                              style: TextStyle(
                                color: VertexColors.ceruleanBlue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSocialButton({
    required String icon,
    required Color color,
    required double size,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 60,
        height: 60,
        padding: EdgeInsets.all(size),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          border: Border.all(color: color.withOpacity(0.3)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Image.asset(
          icon,
        ),
      ),
    );
  }

  //Loader when social button is clicked
  void showLoaderDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Future<void> _signIn() async {
    if (_formKey.currentState?.validate() ?? false) {
      final authManager = Provider.of<AuthManager>(context, listen: false);
      final success = await authManager.signIn(
        authCase: 0,
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      if (!mounted) return;
      // Error feedback is handled by the auth manager via notifyListeners
    }
  }

  Future<void> _signInWithGoogle() async {
    final authManager = Provider.of<AuthManager>(context, listen: false);
    showLoaderDialog(context); //Loader after click
    final success = await authManager.signIn(
      authCase: 1,
    );
    if (!mounted) return;
    // Error feedback is handled by the auth manager via notifyListeners
    Navigator.of(context).pop(); // Hide loader
  }

  Future<void> _signInWithFacebook() async {
    final authManager = Provider.of<AuthManager>(context, listen: false);
    showLoaderDialog(context); //Invoke Loader
    final success = await authManager.signIn(
      authCase: 2,
    );

    if (!mounted) return;
    // Error feedback is handled by the auth manager via notifyListeners
    Navigator.of(context).pop(); //Hide loader
  }

  Future<void> _signInWithGithub() async {
    final authManager = Provider.of<AuthManager>(context, listen: false);
    showLoaderDialog(context); //Invoke Loader
    final success = await authManager.signIn(
      authCase: 3,
    );
    Navigator.of(context).pop(); //Hide loader
    if (!mounted) return;
    // Error feedback is handled by the auth manager via notifyListeners
  }
}
