class VehicleModel {
  final int id;
  final String brand;
  final String model;
  final String plateNumber;
  final int year;
  final int currentKm;
  final String? photoUrl;

  VehicleModel({
    required this.id,
    required this.brand,
    required this.model,
    required this.plateNumber,
    required this.year,
    required this.currentKm,
    this.photoUrl,
  });

  factory VehicleModel.fromJson(Map<String, dynamic> json) {
    return VehicleModel(
      id: json['id'],
      brand: json['brand'],
      model: json['model'],
      plateNumber: json['plateNumber'],
      year: json['year'],
      currentKm: json['currentKm'],
      photoUrl: json['photo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'brand': brand,
      'model': model,
      'plateNumber': plateNumber,
      'year': year,
      'currentKm': currentKm,
    };
  }
}
