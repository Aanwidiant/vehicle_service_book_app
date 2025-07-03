import 'package:flutter/material.dart';

class CustomTextfieldWidget extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String hintText;
  final bool obscureText;
  final bool isOptional; // ✅ Tambahkan ini

  const CustomTextfieldWidget({
    super.key,
    required this.controller,
    required this.label,
    required this.hintText,
    this.obscureText = false,
    this.isOptional = false, // ✅ Default
  });

  @override
  CustomTextfieldWidgetState createState() => CustomTextfieldWidgetState();
}

class CustomTextfieldWidgetState extends State<CustomTextfieldWidget> {
  late bool _obscureText;
  late FocusNode _focusNode;
  late bool _isFocused;
  late bool _hasError;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
    _focusNode = FocusNode();
    _isFocused = false;
    _hasError = false;

    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
      child: TextFormField(
        style: Theme.of(context).textTheme.bodySmall,
        controller: widget.controller,
        obscureText: _obscureText,
        focusNode: _focusNode,
        decoration: InputDecoration(
          labelText: widget.label,
          labelStyle: TextStyle(
            color: _hasError
                ? colorScheme.error
                : (_isFocused ? colorScheme.primary : colorScheme.onSurface),
          ),
          hintText: widget.hintText,
          hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurface.withAlpha(153),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: _hasError
                  ? colorScheme.error
                  : (_isFocused ? colorScheme.primary : colorScheme.outline),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: _hasError ? colorScheme.error : colorScheme.primary,
            ),
          ),
          errorStyle: TextStyle(color: colorScheme.error),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: colorScheme.error),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: colorScheme.error),
          ),
          suffixIcon: widget.label == 'Password'
              ? IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility,
                    color: _hasError
                        ? colorScheme.error
                        : (_isFocused
                              ? colorScheme.primary
                              : colorScheme.onSurface),
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                )
              : null,
        ),
        validator: (value) {
          if ((value == null || value.isEmpty)) {
            if (widget.isOptional) {
              setState(() => _hasError = false);
              return null;
            } else {
              setState(() => _hasError = true);
              return '${widget.label} tidak boleh kosong';
            }
          }

          if (widget.label == 'Email' &&
              !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
            setState(() => _hasError = true);
            return 'Format email tidak valid';
          }

          if (widget.label == 'Password') {
            if (value.length < 8) {
              setState(() => _hasError = true);
              return 'Password harus memiliki minimal 8 karakter.';
            }
            if (!value.contains(RegExp(r'[A-Z]'))) {
              setState(() => _hasError = true);
              return 'Password harus memiliki minimal satu huruf besar.';
            }
            if (!value.contains(RegExp(r'[a-z]'))) {
              setState(() => _hasError = true);
              return 'Password harus memiliki minimal satu huruf kecil.';
            }
            if (!value.contains(RegExp(r'[0-9]'))) {
              setState(() => _hasError = true);
              return 'Password harus memiliki minimal satu angka.';
            }
            if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
              setState(() => _hasError = true);
              return 'Password harus memiliki minimal satu simbol.';
            }
          }

          setState(() => _hasError = false);
          return null;
        },
      ),
    );
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }
}
