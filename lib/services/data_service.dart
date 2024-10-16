// lib/services/data_service.dart
import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/region.dart';
import '../models/province.dart';
import '../models/city.dart';
import '../models/barangay.dart';

class DataService {
  // Load Regions
  Future<List<Region>> loadRegions() async {
    try {
      String jsonString = await rootBundle.loadString('assets/region.json');
      final List<dynamic> jsonResponse = json.decode(jsonString);
      return jsonResponse.map((data) => Region.fromJson(data)).toList();
    } catch (e) {
      print('Error loading region.json: $e');
      return [];
    }
  }

  // Load Provinces
  Future<List<Province>> loadProvinces() async {
    try {
      String jsonString = await rootBundle.loadString('assets/province.json');
      final List<dynamic> jsonResponse = json.decode(jsonString);
      return jsonResponse.map((data) => Province.fromJson(data)).toList();
    } catch (e) {
      print('Error loading province.json: $e');
      return [];
    }
  }

  // Load Cities
  Future<List<City>> loadCities() async {
    try {
      String jsonString = await rootBundle.loadString('assets/city.json');
      final List<dynamic> jsonResponse = json.decode(jsonString);
      return jsonResponse.map((data) => City.fromJson(data)).toList();
    } catch (e) {
      print('Error loading city.json: $e');
      return [];
    }
  }

  // Load Barangays
  Future<List<Barangay>> loadBarangays() async {
    try {
      String jsonString = await rootBundle.loadString('assets/barangay.json');
      final List<dynamic> jsonResponse = json.decode(jsonString);
      return jsonResponse.map((data) => Barangay.fromJson(data)).toList();
    } catch (e) {
      print('Error loading barangay.json: $e');
      return [];
    }
  }
}
