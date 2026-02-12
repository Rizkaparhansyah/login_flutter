import 'dart:async';
import 'package:flutter/material.dart';
import '../../data/services/auth_service.dart';
import '../widgets/custom_button.dart';
import 'reset_password_screen.dart';

class VerifyCodeScreen extends StatefulWidget {
  final String email;

  const VerifyCodeScreen({super.key, required this.email});

  @override
  State<VerifyCodeScreen> createState() => _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends State<VerifyCodeScreen> {

  final List<TextEditingController> controllers =
      List.generate(6, (_) => TextEditingController());

  final List<FocusNode> focusNodes =
      List.generate(6, (_) => FocusNode());

  bool loading = false;

  // TIMER
  int secondsRemaining = 60;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    secondsRemaining = 60;

    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (secondsRemaining > 0) {
        setState(() => secondsRemaining--);
      } else {
        t.cancel();
      }
    });
  }

  String get otpCode =>
      controllers.map((c) => c.text).join();

  void handleVerify() async {

    if (otpCode.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Masukkan 6 digit OTP")),
      );
      return;
    }

    setState(() => loading = true);

    final response =
        await AuthService.verifyCode(widget.email, otpCode);

    setState(() => loading = false);

    if (response['success'] == true) {

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) =>
              ResetPasswordScreen(email: widget.email),
        ),
      );

    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response['message'] ?? 'OTP salah')),
      );
    }
  }

  void resendOtp() async {
    await AuthService.forgotPassword(widget.email);
    startTimer();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("OTP dikirim ulang")),
    );
  }

  Widget buildOtpBox(int index) {

    return SizedBox(
      width: 48,
      child: TextField(
        controller: controllers[index],
        focusNode: focusNodes[index],
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        decoration: InputDecoration(
          counterText: "",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: Colors.deepPurple,
              width: 2,
            ),
          ),
        ),
        onChanged: (value) {

          // AUTO PASTE 6 DIGIT
          if (value.length > 1) {
            for (int i = 0; i < 6; i++) {
              if (i < value.length) {
                controllers[i].text = value[i];
              }
            }
            focusNodes[5].unfocus();
            return;
          }

          // PINDAH KE DEPAN
          if (value.isNotEmpty && index < 5) {
            focusNodes[index + 1].requestFocus();
          }

          // BACKSPACE KE BELAKANG
          if (value.isEmpty && index > 0) {
            focusNodes[index - 1].requestFocus();
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    for (var c in controllers) {
      c.dispose();
    }
    for (var f in focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: const Text("Verifikasi OTP")),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [

            const SizedBox(height: 30),

            Text(
              "Kode dikirim ke\n${widget.email}",
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 15),
            ),

            const SizedBox(height: 40),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(6, buildOtpBox),
            ),

            const SizedBox(height: 30),

            secondsRemaining > 0
                ? Text(
                    "Kirim ulang dalam $secondsRemaining detik",
                    style: const TextStyle(color: Colors.grey),
                  )
                : TextButton(
                    onPressed: resendOtp,
                    child: const Text(
                      "Kirim ulang OTP",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                  ),

            const SizedBox(height: 40),

            CustomButton(
              text: "Verifikasi",
              loading: loading,
              onPressed: handleVerify,
            ),
          ],
        ),
      ),
    );
  }
}
