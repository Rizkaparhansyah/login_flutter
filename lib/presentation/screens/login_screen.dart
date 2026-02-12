import 'package:flutter/material.dart';
import '../../data/services/auth_service.dart';
import '../../core/utils/storage_helper.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';
import 'register_screen.dart';
import 'forgot_password_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool loading = false;

  void handleLogin() async {
    setState(() => loading = true);

    final response = await AuthService.login(
      emailController.text,
      passwordController.text,
    );

    setState(() => loading = false);

    if (response['success'] == true) {
      await StorageHelper.saveToken(response['token']);
      // ignore: use_build_context_synchronously
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response['message'] ?? 'Login gagal')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [

              const Text(
                "Welcome Back 👋",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 40),

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

              CustomButton(
                text: "Login",
                loading: loading,
                onPressed: handleLogin,
              ),

              const SizedBox(height: 10),
              Align(
              alignment: Alignment.center,
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ForgotPasswordScreen(),
                    ),
                  );
                },
                child: const Text("Lupa Password?",
                      style: TextStyle(
                        color: Color(0xFF6C63FF),
                        fontWeight: FontWeight.bold,
                      ),),
                
              ),
            ),

              const SizedBox(height: 10),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Belum punya akun? "),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const RegisterScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      "Daftar",
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
