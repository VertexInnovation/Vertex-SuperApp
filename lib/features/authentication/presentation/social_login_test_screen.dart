import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../auth_manager.dart';

class SocialLoginTestScreen extends StatefulWidget {
  const SocialLoginTestScreen({Key? key}) : super(key: key);

  @override
  _SocialLoginTestScreenState createState() => _SocialLoginTestScreenState();
}

class _SocialLoginTestScreenState extends State<SocialLoginTestScreen> {
  final List<Map<String, dynamic>> _testResults = [];
  bool _isTesting = false;

  Future<void> _testSocialLogin(int provider) async {
    setState(() {
      _isTesting = true;
    });

    try {
      final authManager = context.read<AuthManager>();
      final result = await authManager.testSocialLogin(provider);
      
      setState(() {
        _testResults.add({
          'provider': result['provider'],
          'success': result['success'],
          'data': result,
          'timestamp': DateTime.now(),
        });
      });

      if (result['success'] == true) {
        // Show success message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${result['provider']} login successful!'),
              backgroundColor: Colors.green,
            ),
          );
          
          // Sign out after testing
          await authManager.signOut();
        }
      } else {
        // Show error message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${result['provider']} login failed: ${result['error']}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      setState(() {
        _testResults.add({
          'provider': provider == 1 ? 'Google' : provider == 2 ? 'Facebook' : 'GitHub',
          'success': false,
          'error': e.toString(),
          'timestamp': DateTime.now(),
        });
      });
    } finally {
      if (mounted) {
        setState(() {
          _isTesting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Social Login Testing'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Test Social Logins',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildTestButton(
              'Test Google Sign-In',
              Icons.g_mobiledata,
              () => _testSocialLogin(1),
            ),
            const SizedBox(height: 12),
            _buildTestButton(
              'Test Facebook Login',
              Icons.facebook,
              () => _testSocialLogin(2),
            ),
            const SizedBox(height: 12),
            _buildTestButton(
              'Test GitHub Login',
              Icons.code,
              () => _testSocialLogin(3),
            ),
            const SizedBox(height: 24),
            if (_testResults.isNotEmpty) ...[
              const Text(
                'Test Results:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ..._testResults.reversed.map((result) => _buildTestResult(result)).toList(),
            ],
            if (_isTesting) ...[
              const SizedBox(height: 16),
              const Center(child: CircularProgressIndicator()),
              const SizedBox(height: 8),
              const Text(
                'Testing in progress...',
                textAlign: TextAlign.center,
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTestButton(String text, IconData icon, VoidCallback onPressed) {
    return ElevatedButton.icon(
      onPressed: _isTesting ? null : onPressed,
      icon: Icon(icon),
      label: Text(text),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 12),
      ),
    );
  }

  Widget _buildTestResult(Map<String, dynamic> result) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(
          result['success'] == true ? Icons.check_circle : Icons.error,
          color: result['success'] == true ? Colors.green : Colors.red,
        ),
        title: Text(
          '${result['provider']} - ${result['success'] == true ? 'Success' : 'Failed'}'',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (result['success'] == true) ...[
              if (result['data']?['email'] != null)
                Text('Email: ${result['data']?['email']}'),
              if (result['data']?['name'] != null)
                Text('Name: ${result['data']?['name']}'),
            ] else
              Text('Error: ${result['error']}'),
            Text(
              '${result['timestamp']}',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
