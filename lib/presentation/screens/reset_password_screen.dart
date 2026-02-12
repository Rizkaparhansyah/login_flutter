import 'package:flutter/material.dart';
import '../../data/services/auth_service.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';
import 'login_screen.dart';

class ResetPasswordScreen extends StatefulWidget {

  final String email;

  const ResetPasswordScreen({super.key, required this.email});

  @override
  State<ResetPasswordScreen> createState() =>
      _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {

  final passwordController = TextEditingController();
  final confirmController = TextEditingController();

  bool loading = false;

  void handleReset() async {

    setState(() => loading = true);

    final response = await AuthService.resetPassword(
      widget.email,
      passwordController.text,
      confirmController.text,
    );

    setState(() => loading = false);

    if (response['success'] == true) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password berhasil direset")),
      );

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );

    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response['message'] ?? 'Gagal reset')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: const Text("Reset Password")),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            CustomTextField(
              label: "Password Baru",
              obscure: true,
              controller: passwordController,
            ),
            const SizedBox(height: 20),
            CustomTextField(
              label: "Konfirmasi Password",
              obscure: true,
              controller: confirmController,
            ),
            const SizedBox(height: 30),
            CustomButton(
              text: "Reset Password",
              loading: loading,
              onPressed: handleReset,
            ),
          ],
        ),
      ),
    );
  }
}
