// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import '../../data/services/auth_service.dart';
import '../../core/utils/storage_helper.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';
import 'home_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();

  bool loading = false;

  void handleRegister() async {

    setState(() => loading = true);

    final response = await AuthService.register(
      nameController.text,
      emailController.text,
      passwordController.text,
      confirmController.text,
    );

    setState(() => loading = false);

    if (response['success'] == true) {

      await StorageHelper.saveToken(response['token']);

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
        (route) => false,
      );

    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response['message'] ?? 'Register gagal'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Register"),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [

              const Text(
                "Create Account 🚀",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 30),

              CustomTextField(
                label: "Name",
                controller: nameController,
              ),

              const SizedBox(height: 20),

              CustomTextField(
                label: "Email",
                controller: emailController,
              ),

              const SizedBox(height: 20),

              CustomTextField(
                label: "Password",
                obscure: true,
                controller: passwordController,
              ),

              const SizedBox(height: 20),

              CustomTextField(
                label: "Confirm Password",
                obscure: true,
                controller: confirmController,
              ),

              const SizedBox(height: 30),

              CustomButton(
                text: "Register",
                loading: loading,
                onPressed: handleRegister,
              ),

              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Sudah punya akun? "),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Login",
                      style: TextStyle(
                        color: Color(0xFF6C63FF),
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
    );
  }
}
