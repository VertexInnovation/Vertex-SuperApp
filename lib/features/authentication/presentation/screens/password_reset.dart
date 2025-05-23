import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../../main.dart';
import '../signin_page.dart';
import '../widgets/auth_button.dart';
class PasswordReset extends StatefulWidget {
  final String email;


  
   PasswordReset({super.key,required this.email});

  @override
  State<PasswordReset> createState() => _PasswordResetState();
}

class _PasswordResetState extends State<PasswordReset> {


  
  Future ResendEmail(String email) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    showDialog(context: context, builder: (context){
      return AlertDialog(content: Text("Resent Email"),);
    });
  }
  @override

  Widget build(BuildContext context) {
    return  Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 50,),
            Image.asset(
              "assets/sammy-line-man-receives-a-mail.png",
              height: 200,
            ),

            SizedBox(height: 40,),
            Text(
              "Password reset mail sent",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: VertexColors.deepSapphire,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 40,),
            Text(
                "Your Account Security is Our Priority! We've Sent You a Secure Link to Safely Change Your Password and Keep Your Account Protected.",

              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 40),
            AuthButton(
              text: 'Sign-in',
              onPressed: () {Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => SignInPage()),
              );},
              backgroundColor: VertexColors.deepSapphire,
            ),
            SizedBox(height: 40,),
            TextButton(onPressed: (){ResendEmail(widget.email);}, child: Text("Resend Email"),)



          ],
        ),
      ),);
  }
}
