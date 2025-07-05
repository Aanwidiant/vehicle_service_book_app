import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:vehicle_service_book_app/models/vehicle_model.dart';
import 'package:vehicle_service_book_app/services/api_service.dart';
import 'package:vehicle_service_book_app/ui/widgets/main_scaffold_widget.dart';
import 'package:vehicle_service_book_app/constants/storage_constant.dart';

class MyVehiclesScreen extends StatefulWidget {
  const MyVehiclesScreen({super.key});

  @override
  State<MyVehiclesScreen> createState() => _MyVehiclesScreenState();
}

class _MyVehiclesScreenState extends State<MyVehiclesScreen> {
  bool isLoading = true;
  List<VehicleModel> vehicles = [];

  @override
  void initState() {
    super.initState();
    fetchVehicles();
  }

  Future<void> fetchVehicles() async {
    setState(() => isLoading = true);
    try {
      final response = await ApiService.get('/vehicle');
      final data = jsonDecode(response.body);

      if (data['success'] == true) {
        setState(() {
          vehicles = (data['data'] as List)
              .map((v) => VehicleModel.fromJson(v))
              .toList();
        });
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'] ?? 'Gagal memuat kendaraan')),
        );
      }
    } catch (e) {
      debugPrint('Error fetching vehicles: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> confirmDelete(int vehicleId) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Yakin ingin menghapus kendaraan?'),
        content: const Text(
          'Tindakan ini tidak dapat dibatalkan. Data kendaraan akan hilang permanen.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context, true);
            },
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.primary,
            ),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (result == true) {
      try {
        final response = await ApiService.delete('/vehicle/$vehicleId');
        final data = jsonDecode(response.body);

        if (response.statusCode == 200 && data['success'] == true) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Kendaraan berhasil dihapus')),
          );
          fetchVehicles();
        } else {
          throw Exception(data['message'] ?? 'Gagal menghapus kendaraan');
        }
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Terjadi kesalahan saat menghapus kendaraan')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MainScaffoldWidget(
      title: 'Kendaraanku',
      showBackButton: true,
      body: Stack(
        children: [
          if (isLoading)
            const Center(child: CircularProgressIndicator())
          else if (vehicles.isEmpty)
            Center(
              child: Padding(
                padding: EdgeInsets.only(top: 100),
                child: Text(
                  'Anda belum mempunyai kendaraan.\nSilakan tambahkan kendaraan.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
            )
          else
            SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 80, 24, 90),
              child: Column(
                children: vehicles.map((v) {
                  final imageUrl = v.photoUrl != null
                      ? getStorageUrl(v.photoUrl!)
                      : null;
                  final title = '${v.brand} ${v.model}';
                  final plate = v.plateNumber;

                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: imageUrl != null
                                ? Image.network(
                                    imageUrl,
                                    width: 70,
                                    height: 70,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, _) =>
                                        const Icon(
                                          Icons.directions_car,
                                          size: 70,
                                        ),
                                  )
                                : const Icon(Icons.directions_car, size: 70),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  title,
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  plate,
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  minimumSize: const Size(40, 40),
                                  padding: const EdgeInsets.all(8),
                                ),
                                onPressed: () {
                                  Navigator.pushNamed(
                                    context,
                                    '/vehicle/detail',
                                    arguments: v,
                                  );
                                },
                                child: const Icon(
                                  Icons.visibility,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 2),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  minimumSize: const Size(40, 40),
                                  padding: const EdgeInsets.all(8),
                                ),
                                onPressed: () async {
                                  final result = await Navigator.pushNamed(
                                    context,
                                    '/vehicle/edit',
                                    arguments: v,
                                  );

                                  if (result == true) {
                                    fetchVehicles();
                                  }
                                },
                                child: const Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 2),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  minimumSize: const Size(40, 40),
                                  padding: const EdgeInsets.all(8),
                                ),
                                onPressed: () => confirmDelete(v.id),
                                child: const Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          Positioned(
            top: 16,
            right: 24,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  '/vehicle/add',
                ).then((_) => fetchVehicles());
              },
              icon: const Icon(Icons.add),
              label: const Text('Kendaraan'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
