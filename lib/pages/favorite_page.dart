import 'package:flutter/material.dart';
import '../locals/hive_service.dart';
import 'detail_page.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  @override
  Widget build(BuildContext context) {
    final favorites = HiveService.getFavorites();

    return favorites.isEmpty
        ? const Center(
            child: Text('Belum ada resep favorit'),
          )
        : ListView.builder(
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              final meal = favorites[index];

              return Card(
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  leading: Image.network(
                    meal['strMealThumb'],
                    width: 60,
                    fit: BoxFit.cover,
                  ),
                  title: Text(meal['strMeal']),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      HiveService.removeFavorite(
                        meal['idMeal'],
                      );

                      setState(() {});
                    },
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DetailPage(
                          id: meal['idMeal'],
                        ),
                      ),
                    ).then((_) {
                      setState(() {});
                    });
                  },
                ),
              );
            },
          );
  }
}