import 'package:hive/hive.dart';

class HiveService {
  static final Box box = Hive.box('favorites');

  // tambah favorit
  static void addFavorite(Map<String, dynamic> meal) {
    box.put(meal['idMeal'], meal);
  }

  // hapus favorit
  static void removeFavorite(String id) {
    box.delete(id);
  }

  // cek favorit
  static bool isFavorite(String id) {
    return box.containsKey(id);
  }

  // ambil semua favorit
  static List getFavorites() {
    return box.values.toList();
  }
}