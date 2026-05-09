import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/meal_model.dart';

class ApiService {
  static const String baseUrl =
      'https://www.themealdb.com/api/json/v1/1';

  // Home awal -> kategori seafood
  static Future<List<Meal>> getMeals() async {
    final response = await http.get(
      Uri.parse('$baseUrl/filter.php?c=Seafood'),
    );

    final data = jsonDecode(response.body);

    return (data['meals'] as List)
        .map((json) => Meal.fromJson(json))
        .toList();
  }

  // Search berdasarkan nama menu
  static Future<List<Meal>> searchMeals(String query) async {
    final response = await http.get(
      Uri.parse('$baseUrl/search.php?s=$query'),
    );

    final data = jsonDecode(response.body);

    if (data['meals'] == null) {
      return [];
    }

    return (data['meals'] as List)
        .map((json) => Meal.fromJson(json))
        .toList();
  }

  // Detail berdasarkan ID
  static Future<Map<String, dynamic>> getMealDetail(String id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/lookup.php?i=$id'),
    );

    final data = jsonDecode(response.body);

    return data['meals'][0];
  }
}