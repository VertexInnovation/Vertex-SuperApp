import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/main.dart';
import 'package:vertex_app/features/authentication/auth_manager.dart';
import 'package:vertex_app/features/authentication/presentation/signup_page.dart';

// class Emailverify extends StatelessWidget {
//   const Emailverify({super.key});

//   sendVerifyEmail()async{
//     final user = AuthManager().userObject!;
//     await user.sendEmailVerification().then((onValue)=>{
//       Get.snackbar()
//     })
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: [
//           const Text("email verification link is sent to your mail"),
//           TextButton(onPressed: () {

//           }, child: const Text("Continue"))
//         ],
//       ),
//     );
//   }
// }

class Emailverify extends StatefulWidget {
  const Emailverify({super.key});

  @override
  State<Emailverify> createState() => _EmailverifyState();
}

class _EmailverifyState extends State<Emailverify> {
  sendVerifyEmail() async {
    final user = FirebaseAuth.instance.currentUser;
    await user!.sendEmailVerification();

    if (!mounted) return;

    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Email link sent")));
  }

  relode() async {
    await FirebaseAuth.instance.currentUser!.reload().then((onValue) {
      if (FirebaseAuth.instance.currentUser!.emailVerified) {
        // Navigator.push(context,MaterialPageRoute(builder: (context)=> main());
        Navigator.pop(context);
        Navigator.pop(context);
        return;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Email verification failed")));
      }
    });
  }

  @override
  void initState() {
    super.initState();
    sendVerifyEmail();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Text("email verification link is sent to your mail"),
          TextButton(
              onPressed: () {
                relode();
              },
              child: const Text("Continue")),
          TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SignUpPage(),
                    ));
              },
              child: const Text("signup"))
        ],
      ),
    );
  }
}
