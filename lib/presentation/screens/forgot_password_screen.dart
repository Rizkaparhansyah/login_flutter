import 'package:flutter/material.dart';
import '../../data/services/auth_service.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';
import 'verify_code_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {

  final emailController = TextEditingController();
  bool loading = false;

  void handleSend() async {

    setState(() => loading = true);

    final response =
        await AuthService.forgotPassword(emailController.text);

    setState(() => loading = false);

    if (response['success'] == true) {

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) =>
              VerifyCodeScreen(email: emailController.text),
        ),
      );

    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response['message'] ?? 'Gagal')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Lupa Password")),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Text(
              "Masukkan email untuk reset password",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            CustomTextField(
              label: "Email",
              controller: emailController,
            ),
            const SizedBox(height: 30),
            CustomButton(
              text: "Kirim Kode",
              loading: loading,
              onPressed: handleSend,
            ),
          ],
        ),
      ),
    );
  }
}
