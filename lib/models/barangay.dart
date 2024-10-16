// lib/models/barangay.dart
class Barangay {
  final String barangayCode;
  final String barangayName;
  final String cityCode;

  Barangay({
    required this.barangayCode,
    required this.barangayName,
    required this.cityCode,
  });

  factory Barangay.fromJson(Map<String, dynamic> json) {
    return Barangay(
      barangayCode: json['brgy_code'],
      barangayName: json['brgy_name'],
      cityCode: json['city_code'],
    );
  }
}
