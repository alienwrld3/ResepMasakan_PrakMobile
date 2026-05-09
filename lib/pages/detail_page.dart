import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../locals/hive_service.dart';

class DetailPage extends StatefulWidget {
  final String id;

  const DetailPage({
    super.key,
    required this.id,
  });

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  Future<Map<String, dynamic>> getDetail() async {
    return await ApiService.getMealDetail(widget.id);
  }

  List<String> getIngredients(Map<String, dynamic> meal) {
    List<String> ingredients = [];

    for (int i = 1; i <= 20; i++) {
      final ingredient = meal['strIngredient$i'];
      final measure = meal['strMeasure$i'];

      if (ingredient != null &&
          ingredient.toString().trim().isNotEmpty) {
        ingredients.add('$ingredient - $measure');
      }
    }

    return ingredients;
  }

  void toggleFavorite(Map<String, dynamic> meal) {
    final isFav = HiveService.isFavorite(meal['idMeal']);

    if (isFav) {
      HiveService.removeFavorite(meal['idMeal']);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Resep dihapus dari favorit'),
        ),
      );
    } else {
      HiveService.addFavorite({
        'idMeal': meal['idMeal'],
        'strMeal': meal['strMeal'],
        'strMealThumb': meal['strMealThumb'],
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Resep ditambahkan ke favorit'),
        ),
      );
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Recipe'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: getDetail(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text('Gagal mengambil detail resep'),
            );
          }

          if (!snapshot.hasData) {
            return const Center(
              child: Text('Data tidak ditemukan'),
            );
          }

          final meal = snapshot.data!;
          final ingredients = getIngredients(meal);
          final isFav = HiveService.isFavorite(meal['idMeal']);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    meal['strMealThumb'],
                    width: double.infinity,
                    height: 250,
                    fit: BoxFit.cover,
                  ),
                ),

                const SizedBox(height: 16),

                Text(
                  meal['strMeal'],
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                Text('Kategori: ${meal['strCategory'] ?? '-'}'),
                Text('Asal Negara: ${meal['strArea'] ?? '-'}'),

                const SizedBox(height: 16),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => toggleFavorite(meal),
                    icon: Icon(
                      isFav
                          ? Icons.favorite
                          : Icons.favorite_border,
                    ),
                    label: Text(
                      isFav
                          ? 'Hapus dari Favorit'
                          : 'Tambah ke Favorit',
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                const Text(
                  'Bahan-bahan',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                ...ingredients.map(
                  (item) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Text('• $item'),
                  ),
                ),

                const SizedBox(height: 20),

                const Text(
                  'Instruksi Memasak',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  meal['strInstructions'] ?? '-',
                  textAlign: TextAlign.justify,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}