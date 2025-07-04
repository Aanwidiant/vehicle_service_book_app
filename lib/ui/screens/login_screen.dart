import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vehicle_service_book_app/providers/user_provider.dart';
import 'package:vehicle_service_book_app/services/api_service.dart';
import 'package:vehicle_service_book_app/ui/widgets/custom_textfield_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;

  Future<void> _loginUser() async {
    setState(() => isLoading = true);

    final data = {
      "email": emailController.text,
      "password": passwordController.text,
    };

    try {
      final response = await ApiService.postNoAuth('/user/login', data);

      if (!mounted) return;

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        final token = result['data']['token'];
        final user = result['data']['user'];

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);

        if (!mounted) return;
        context.read<UserProvider>().setUser(
          id: user['id'],
          name: user['name'],
          email: user['email'],
          photo: user['photo'] ?? '',
        );

        _showSnackbar('Login berhasil.');
        Navigator.pushReplacementNamed(context, '/dashboard');
      } else {
        final error = jsonDecode(response.body);
        _showSnackbar(error['message'] ?? 'Login gagal.');
      }
    } catch (e) {
      _showSnackbar('Terjadi kesalahan: $e');
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Container(
          color: colorScheme.surface,
          child: Stack(
            children: [
              Center(
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Selamat datang kembali!',
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.primary,
                                ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Text(
                            'Silakan masuk untuk melanjutkan ke dashboard Anda.',
                            style: Theme.of(context).textTheme.bodyMedium,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 32),
                        CustomTextfieldWidget(
                          controller: emailController,
                          label: 'Email',
                          hintText: 'Masukkan email',
                          isOptional: true,
                        ),
                        const SizedBox(height: 16),
                        CustomTextfieldWidget(
                          controller: passwordController,
                          label: 'Password',
                          hintText: 'Masukkan password',
                          obscureText: true,
                          isOptional: true,
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: isLoading
                              ? null
                              : () {
                                  if (_formKey.currentState!.validate()) {
                                    _loginUser();
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 16,
                            ),
                          ),
                          child: isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                )
                              : const Text('Masuk'),
                        ),
                        const SizedBox(height: 16),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/register');
                          },
                          child: const Text("Belum punya akun? Daftar"),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
