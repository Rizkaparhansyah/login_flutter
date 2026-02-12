import 'package:flutter/material.dart';
import '../../core/utils/storage_helper.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        actions: [
          IconButton(
            onPressed: () async {
              await StorageHelper.logout();
              // ignore: use_build_context_synchronously
              Navigator.pushReplacementNamed(context, '/');
            },
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      body: const Center(
        child: Text("Login Success 🎉"),
      ),
    );
  }
}
