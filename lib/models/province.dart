// lib/models/province.dart
class Province {
  final String provinceCode;
  final String provinceName;
  final String psgcCode;
  final String regionCode;

  Province({
    required this.provinceCode,
    required this.provinceName,
    required this.psgcCode,
    required this.regionCode,
  });

  factory Province.fromJson(Map<String, dynamic> json) {
    return Province(
      provinceCode: json['province_code'],
      provinceName: json['province_name'],
      psgcCode: json['psgc_code'],
      regionCode: json['region_code'],
    );
  }
}
