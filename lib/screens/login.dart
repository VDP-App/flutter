import 'package:flutter/material.dart';
import 'package:vdp/main.dart';
import 'package:vdp/providers/apis/auth.dart';
import 'package:provider/provider.dart';
import 'package:vdp/utils/typography.dart';

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
        child: const T2('Login'),
        onPressed: () {
          auth.login(
            email: emailController.text.trim(),
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
          email: emailController.text.trim(),
        );
      },
      child: const P3('Forgot Password'),
    );
  }

  Widget passwordField(TextEditingController passwordController) {
    return Password(passwordController: passwordController);
  }

  Widget emailField(TextEditingController emailController) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: TextField(
        controller: emailController,
        style: TextStyle(fontSize: fontSizeOf.t2),
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
      child: const P3(
        'Log in',
        color: Colors.deepPurple,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}

class Password extends StatefulWidget {
  const Password({Key? key, required this.passwordController})
      : super(key: key);
  final TextEditingController passwordController;
  @override
  State<Password> createState() => _PasswordState();
}

class _PasswordState extends State<Password> {
  var showPassword = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
      child: TextField(
        obscureText: !showPassword,
        controller: widget.passwordController,
        style: TextStyle(fontSize: fontSizeOf.t2),
        decoration: InputDecoration(
          suffixIcon: TextButton(
            onPressed: () {
              setState(() {
                showPassword = !showPassword;
              });
            },
            child: IconT2(
              showPassword
                  ? Icons.remove_red_eye_outlined
                  : Icons.remove_red_eye,
              color: Colors.black,
            ),
          ),
          border: const OutlineInputBorder(),
          labelText: 'Password',
        ),
      ),
    );
  }
}
