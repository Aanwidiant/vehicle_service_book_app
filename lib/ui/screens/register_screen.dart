import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:vehicle_service_book_app/ui/services/api_service.dart';
import 'package:vehicle_service_book_app/ui/widgets/custom_button_widget.dart';
import 'package:vehicle_service_book_app/ui/widgets/custom_textfield_widget.dart';
import 'package:vehicle_service_book_app/ui/widgets/logo_widget.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isLoading = false;

  Future<void> _registerUser() async {
    setState(() => isLoading = true);

    try {
      final response = await ApiService.postNoAuth('/user', {
        "name": usernameController.text,
        "email": emailController.text,
        "password": passwordController.text,
      });

      if (!mounted) return;

      if (response.statusCode == 201) {
        await showDialog(
          context: context,
          builder: (BuildContext dialogContext) {
            return AlertDialog(
              title: const Text('Registrasi Berhasil'),
              content: const Text('Silakan login menggunakan akun Anda.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );

        if (!mounted) return;
        Navigator.pushReplacementNamed(context, '/login');
      } else {
        final error = jsonDecode(response.body);
        _showError(error['message'] ?? 'Registrasi gagal.');
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
        title: const Text('Registrasi Gagal'),
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
                          controller: usernameController,
                          label: 'Username',
                          hintText: 'Masukkan username',
                        ),
                        const SizedBox(height: 16),
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
                        const SizedBox(height: 24),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: isLoading
                                ? const CircularProgressIndicator()
                                : CustomButtonWidget(
                                    text: 'Register',
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        _registerUser();
                                      }
                                    },
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
