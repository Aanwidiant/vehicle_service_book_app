import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vehicle_service_book_app/constants/storage_constant.dart';
import 'package:vehicle_service_book_app/models/vehicle_model.dart';
import 'package:vehicle_service_book_app/services/api_service.dart';
import 'package:vehicle_service_book_app/ui/widgets/custom_textfield_widget.dart';
import 'package:vehicle_service_book_app/ui/widgets/main_scaffold_widget.dart';

class EditVehicleScreen extends StatefulWidget {
  const EditVehicleScreen({super.key});

  @override
  State<EditVehicleScreen> createState() => _EditVehicleScreenState();
}

class _EditVehicleScreenState extends State<EditVehicleScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _brandController;
  late TextEditingController _modelController;
  late TextEditingController _plateController;
  late TextEditingController _yearController;
  late TextEditingController _kmController;

  VehicleModel? vehicle;
  bool isSubmitting = false;
  bool isUploading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (vehicle == null) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is VehicleModel) {
        vehicle = args;

        _brandController = TextEditingController(text: vehicle!.brand);
        _modelController = TextEditingController(text: vehicle!.model);
        _plateController = TextEditingController(text: vehicle!.plateNumber);
        _yearController = TextEditingController(text: vehicle!.year.toString());
        _kmController = TextEditingController(
          text: vehicle!.currentKm.toString(),
        );
      } else {
        Navigator.pop(context);
      }
    }
  }

  @override
  void dispose() {
    _brandController.dispose();
    _modelController.dispose();
    _plateController.dispose();
    _yearController.dispose();
    _kmController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isSubmitting = true);

    final body = {
      "brand": _brandController.text.trim(),
      "model": _modelController.text.trim(),
      "plateNumber": _plateController.text.trim(),
      "year": int.tryParse(_yearController.text.trim()) ?? 0,
      "currentKm": int.tryParse(_kmController.text.trim()) ?? 0,
    };

    try {
      final response = await ApiService.patch(
        '/vehicle/${vehicle!.id}',
        body: body,
      );
      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data Kendaraan berhasil diperbarui')),
        );
        Navigator.pop(context, true);
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              data['message'] ?? 'Gagal memperbarui data kendaraan.',
            ),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Terjadi kesalahan. Silakan coba lagi nanti.'),
        ),
      );
    } finally {
      if (mounted) setState(() => isSubmitting = false);
    }
  }

  Future<void> _uploadVehicleImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) return;

    setState(() => isUploading = true);

    try {
      final response = await ApiService.uploadImage(
        File(pickedFile.path),
        path: '/vehicle/image/${vehicle!.id}',
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['success'] == true) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Foto kendaraan berhasil diunggah')),
        );
        Navigator.pop(context, true);
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              data['message'] ?? 'Gagal memperbarui data kendaraan.',
            ),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Terjadi kesalahan. Silakan coba lagi nanti.'),
        ),
      );
    } finally {
      if (mounted) setState(() => isUploading = false);
    }
  }

  Widget _fallbackImage() {
    return Container(
      height: 180,
      width: double.infinity,
      color: Colors.grey[300],
      alignment: Alignment.center,
      child: const Icon(
        Icons.directions_car_filled,
        size: 64,
        color: Colors.grey,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vehicle = ModalRoute.of(context)?.settings.arguments as VehicleModel?;
    final imageUrl = vehicle?.photoUrl != null
        ? getStorageUrl(vehicle!.photoUrl!)
        : null;

    return MainScaffoldWidget(
      title: 'Edit Kendaraan',
      showBackButton: true,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 24.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: imageUrl != null
                      ? Image.network(
                          imageUrl,
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              _fallbackImage(),
                        )
                      : _fallbackImage(),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: isUploading ? null : _uploadVehicleImage,
                icon: isUploading
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.image),
                label: const Text('Upload Foto Kendaraan'),
              ),
              const SizedBox(height: 16),
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
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
              CustomTextfieldWidget(
                controller: _kmController,
                label: 'Kilometer Sekarang',
                hintText: 'Contoh: 25000',
                keyboardType: TextInputType.number,
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
                    : const Text('Simpan Perubahan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
