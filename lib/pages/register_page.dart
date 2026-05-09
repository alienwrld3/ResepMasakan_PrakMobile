import 'package:flutter/material.dart';
import '../locals/sharedpref_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() =>
      _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final username = TextEditingController();
  final password = TextEditingController();
  final confirmPassword = TextEditingController();

  bool hidePassword = true;
  bool hideConfirm = true;

  Future<void> handleRegister() async {
    if (username.text.isEmpty ||
        password.text.isEmpty ||
        confirmPassword.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Semua field wajib diisi'),
        ),
      );
      return;
    }

    if (password.text != confirmPassword.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text('Konfirmasi password tidak cocok'),
        ),
      );
      return;
    }

    await SharedPrefService.saveUser(
      username.text.trim(),
      password.text.trim(),
    );

    if (!mounted) return;

    Navigator.pop(context);
  }

  InputDecoration fieldStyle({
    required String hint,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.grey.shade100,
      suffixIcon: suffixIcon,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide.none,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Register"),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            TextField(
              controller: username,
              decoration:
                  fieldStyle(hint: "Username"),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: password,
              obscureText: hidePassword,
              decoration: fieldStyle(
                hint: "Password",
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      hidePassword = !hidePassword;
                    });
                  },
                  icon: Icon(
                    hidePassword
                        ? Icons.visibility_off
                        : Icons.visibility,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: confirmPassword,
              obscureText: hideConfirm,
              decoration: fieldStyle(
                hint: "Confirm Password",
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      hideConfirm = !hideConfirm;
                    });
                  },
                  icon: Icon(
                    hideConfirm
                        ? Icons.visibility_off
                        : Icons.visibility,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: handleRegister,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(18),
                  ),
                ),
                child: const Text("Register"),
              ),
            )
          ],
        ),
      ),
    );
  }
}