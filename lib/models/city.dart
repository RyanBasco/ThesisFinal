// lib/models/city.dart
class City {
  final String cityCode;
  final String cityName;
  final String provinceCode;

  City({
    required this.cityCode,
    required this.cityName,
    required this.provinceCode,
  });

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      cityCode: json['city_code'],
      cityName: json['city_name'],
      provinceCode: json['province_code'],
    );
  }
}
