import 'package:flutter/material.dart';

import '../../services/api_service.dart';


class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}


class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isLoading = false;


  Future<void> resetPassword() async {

    if (emailController.text.isEmpty ||
        passwordController.text.isEmpty) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill all fields"),
        ),
      );

      return;
    }


    setState(() {
      isLoading = true;
    });


    final result = await ApiService.forgotPassword(
      email: emailController.text.trim(),
      newPassword: passwordController.text.trim(),
    );


    if (!mounted) return;


    setState(() {
      isLoading = false;
    });


    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(result["message"]),
      ),
    );


    if (result["success"] == true) {

      Navigator.pop(context);

    }

  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text(
          "Forgot Password",
        ),
        centerTitle: true,
      ),


      body: Padding(

        padding: const EdgeInsets.all(20),

        child: Column(

          children: [

            const SizedBox(height: 30),


            TextField(

              controller: emailController,

              decoration: const InputDecoration(

                labelText: "Email",

                prefixIcon: Icon(
                  Icons.email,
                ),

                border: OutlineInputBorder(),

              ),

            ),


            const SizedBox(height: 20),


            TextField(

              controller: passwordController,

              obscureText: true,

              decoration: const InputDecoration(

                labelText: "New Password",

                prefixIcon: Icon(
                  Icons.lock,
                ),

                border: OutlineInputBorder(),

              ),

            ),


            const SizedBox(height: 30),


            SizedBox(

              width: double.infinity,

              height: 50,

              child: ElevatedButton(

                onPressed: isLoading
                    ? null
                    : resetPassword,


                child: isLoading

                    ? const CircularProgressIndicator()

                    : const Text(
                        "Reset Password",
                      ),

              ),

            ),

          ],

        ),

      ),

    );

  }
}