import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextfieldWidget extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String? hintText;
  final bool obscureText;
  final bool isOptional;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final bool displayOnly;
  final bool passwordValidator;

  const CustomTextfieldWidget({
    super.key,
    required this.controller,
    required this.label,
    this.hintText,
    this.obscureText = false,
    this.isOptional = false,
    this.keyboardType,
    this.inputFormatters,
    this.displayOnly = false,
    this.passwordValidator = true,
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

    if (widget.displayOnly) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.label,
              style: Theme.of(
                context,
              ).textTheme.labelLarge?.copyWith(color: colorScheme.onSurface),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.all(12),
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: colorScheme.outline),
                borderRadius: BorderRadius.circular(8),
                color: colorScheme.surfaceContainerHighest.withAlpha(25),
              ),
              child: Text(
                widget.controller.text,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      );
    }

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
          hintText: widget.hintText ?? '',
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

          if (widget.label == 'Password' && widget.passwordValidator == true) {
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

          if (widget.label == 'Tahun') {
            final year = int.tryParse(value);
            final now = DateTime.now().year;
            if (year == null || year < 1900 || year > now) {
              setState(() => _hasError = true);
              return 'Tahun harus valid antara 1900–$now';
            }
          }

          if (widget.label == 'Kilometer Sekarang') {
            final km = int.tryParse(value);
            if (km == null || km < 0) {
              setState(() => _hasError = true);
              return 'Kilometer harus berupa angka positif';
            }
          }

          if (widget.label == 'Plat Nomor' &&
              !RegExp(r'^[A-Z]{1,2}[0-9]{1,5}[A-Z]{0,3}$').hasMatch(value)) {
            setState(() => _hasError = true);
            return 'Format plat nomor tidak valid';
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
