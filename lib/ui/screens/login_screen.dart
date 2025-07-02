import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vehicle_service_book_app/ui/services/api_service.dart';
import 'package:vehicle_service_book_app/ui/widgets/custom_button_widget.dart';
import 'package:vehicle_service_book_app/ui/widgets/custom_textfield_widget.dart';
import 'package:vehicle_service_book_app/ui/widgets/logo_widget.dart';

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
        await prefs.setString('userName', user['name']);
        await prefs.setString('userEmail', user['email']);
        await prefs.setString('userPhoto', user['photo'] ?? '');

        if (!mounted) return;
        Navigator.pushReplacementNamed(context, '/dashboard');
      } else {
        final error = jsonDecode(response.body);
        _showError(error['message'] ?? 'Login gagal.');
      }
    } catch (e) {
      _showError('Terjadi kesalahan: $e');
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  void _showError(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Login Gagal'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
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
                        CustomTextfieldWidget(
                          controller: emailController,
                          label: 'Email',
                          hintText: 'Masukkan email',
                        ),
                        const SizedBox(height: 16),
                        CustomTextfieldWidget(
                          controller: passwordController,
                          label: 'Password',
                          hintText: 'Masukkan password',
                          obscureText: true,
                        ),
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: SizedBox(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: isLoading
                                  ? const CircularProgressIndicator()
                                  : CustomButtonWidget(
                                text: 'Login',
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    _loginUser();
                                  }
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const Positioned(top: 0, right: 0, child: LogoWidget()),
            ],
          ),
        ),
      ),
    );
  }
}
