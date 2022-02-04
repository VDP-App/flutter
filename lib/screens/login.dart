import 'package:flutter/material.dart';
import 'package:vdp/providers/apis/auth.dart';
import 'package:provider/provider.dart';

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context, listen: false);
    final passwordController = TextEditingController();
    final emailController = TextEditingController();
    return Padding(
      padding: const EdgeInsets.all(10),
      child: ListView(
        children: [
          title,
          const SizedBox(height: 50),
          emailField(emailController),
          const SizedBox(height: 30),
          passwordField(passwordController),
          const SizedBox(height: 50),
          forgotPasswordButton(auth, emailController),
          loginButton(auth, emailController, passwordController),
        ],
      ),
    );
  }

  Widget loginButton(
    Auth auth,
    TextEditingController emailController,
    TextEditingController passwordController,
  ) {
    return Container(
      height: 70,
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(),
        child: const Text(
          'Login',
          style: TextStyle(fontSize: 40),
        ),
        onPressed: () {
          auth.login(
            email: emailController.text,
            password: passwordController.text,
          );
        },
      ),
    );
  }

  Widget forgotPasswordButton(
    Auth auth,
    TextEditingController emailController,
  ) {
    return TextButton(
      onPressed: () {
        auth.forgotPassword(
          email: emailController.text,
        );
      },
      child: const Text(
        'Forgot Password',
        style: TextStyle(fontSize: 30),
      ),
    );
  }

  Widget passwordField(TextEditingController passwordController) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
      child: TextField(
        obscureText: true,
        controller: passwordController,
        style: const TextStyle(fontSize: 40),
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Password',
        ),
      ),
    );
  }

  Widget emailField(TextEditingController emailController) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: TextField(
        controller: emailController,
        style: const TextStyle(fontSize: 40),
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Email Address',
        ),
      ),
    );
  }

  Widget get title {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(10),
      child: const Text(
        'Log in',
        style: TextStyle(
          color: Colors.deepPurple,
          fontWeight: FontWeight.w500,
          fontSize: 30,
        ),
      ),
    );
  }
}
