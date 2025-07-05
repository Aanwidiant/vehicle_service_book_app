import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vehicle_service_book_app/services/api_service.dart';
import 'package:vehicle_service_book_app/ui/widgets/custom_textfield_widget.dart';
import 'package:vehicle_service_book_app/ui/widgets/main_scaffold_widget.dart';

class AddVehicleScreen extends StatefulWidget {
  const AddVehicleScreen({super.key});

  @override
  State<AddVehicleScreen> createState() => _AddVehicleScreenState();
}

class _AddVehicleScreenState extends State<AddVehicleScreen> {
  final _formKey = GlobalKey<FormState>();
  final _brandController = TextEditingController();
  final _modelController = TextEditingController();
  final _plateController = TextEditingController();
  final _yearController = TextEditingController();
  final _kmController = TextEditingController();

  bool isSubmitting = false;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isSubmitting = true);

    final data = {
      "brand": _brandController.text.trim(),
      "model": _modelController.text.trim(),
      "plateNumber": _plateController.text.trim(),
      "year": int.tryParse(_yearController.text.trim()) ?? 0,
      "currentKm": int.tryParse(_kmController.text.trim()) ?? 0,
    };

    try {
      final response = await ApiService.post('/vehicle', data);
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (!mounted) return;
        Navigator.pop(context, true);
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Gagal menambah kendaraan.')));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Terjadi kesalahan: $e')));
    } finally {
      setState(() => isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MainScaffoldWidget(
      title: 'Tambah kendaraan',
      showBackButton: true,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 24.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CustomTextfieldWidget(
                controller: _brandController,
                label: 'Merk Kendaraan',
                hintText: 'Contoh: Honda',
              ),
              CustomTextfieldWidget(
                controller: _modelController,
                label: 'Model Kendaraan',
                hintText: 'Contoh: Beat',
              ),
              CustomTextfieldWidget(
                controller: _plateController,
                label: 'Plat Nomor',
                hintText: 'Contoh: AB1234CD',
              ),
              CustomTextfieldWidget(
                controller: _yearController,
                label: 'Tahun',
                hintText: 'Contoh: 2020',
                keyboardType: TextInputType.numberWithOptions(signed: false, decimal: false),
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
              CustomTextfieldWidget(
                controller: _kmController,
                label: 'Kilometer Sekarang',
                hintText: 'Contoh: 25000',
                keyboardType: TextInputType.numberWithOptions(signed: false, decimal: false),
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: isSubmitting ? null : _submit,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 14,
                  ),
                ),
                child: isSubmitting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Simpan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
