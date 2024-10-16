// lib/models/region.dart
class Region {
  final int id;
  final String psgcCode;
  final String regionName;
  final String regionCode;

  Region({
    required this.id,
    required this.psgcCode,
    required this.regionName,
    required this.regionCode,
  });

  factory Region.fromJson(Map<String, dynamic> json) {
    return Region(
      id: json['id'],
      psgcCode: json['psgc_code'],
      regionName: json['region_name'],
      regionCode: json['region_code'],
    );
  }
}
