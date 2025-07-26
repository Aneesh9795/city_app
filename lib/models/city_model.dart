class CityModel {
  final String id;
  final String address;

  CityModel({required this.id, required this.address});

  factory CityModel.fromJson(Map<String, dynamic> json) {
    return CityModel(
      id: json['id'].toString(),
      address: json['address'] ?? '',
    );
  }
}
