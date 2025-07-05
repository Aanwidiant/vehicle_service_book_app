import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vehicle_service_book_app/constants/storage_constant.dart';
import 'package:vehicle_service_book_app/models/vehicle_model.dart';
import 'package:vehicle_service_book_app/ui/widgets/custom_textfield_widget.dart';
import 'package:vehicle_service_book_app/ui/widgets/main_scaffold_widget.dart';

class DetailVehicleScreen extends StatefulWidget {
  const DetailVehicleScreen({super.key});

  @override
  State<DetailVehicleScreen> createState() => _DetailVehicleScreenState();
}

class _DetailVehicleScreenState extends State<DetailVehicleScreen> {
  late TextEditingController _brandController;
  late TextEditingController _modelController;
  late TextEditingController _plateController;
  late TextEditingController _yearController;
  late TextEditingController _kmController;

  VehicleModel? vehicle;

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
      title: 'Detail Kendaraan',
      showBackButton: true,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 24.0),
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
            CustomTextfieldWidget(
              controller: _brandController,
              label: 'Merk Kendaraan',
              displayOnly: true,
            ),
            CustomTextfieldWidget(
              controller: _modelController,
              label: 'Model Kendaraan',
              displayOnly: true,
            ),
            CustomTextfieldWidget(
              controller: _plateController,
              label: 'Plat Nomor',
              displayOnly: true,
            ),
            CustomTextfieldWidget(
              controller: _yearController,
              label: 'Tahun',
              displayOnly: true,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
            CustomTextfieldWidget(
              controller: _kmController,
              label: 'Kilometer Sekarang',
              displayOnly: true,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
          ],
        ),
      ),
    );
  }
}
