import 'package:flutter/material.dart';
import '../models/meal_model.dart';
import '../locals/hive_service.dart';

class MealCard extends StatefulWidget {
  final Meal meal;
  final VoidCallback onTap;

  const MealCard({
    super.key,
    required this.meal,
    required this.onTap,
  });

  @override
  State<MealCard> createState() => _MealCardState();
}

class _MealCardState extends State<MealCard> {
  bool isHovered = false;

  void toggleFavorite() {
    final isFav =
        HiveService.isFavorite(widget.meal.id);

    if (isFav) {
      HiveService.removeFavorite(widget.meal.id);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Resep dihapus dari favorit',
          ),
        ),
      );
    } else {
      HiveService.addFavorite({
        'idMeal': widget.meal.id,
        'strMeal': widget.meal.name,
        'strMealThumb': widget.meal.image,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Resep ditambahkan ke favorit',
          ),
        ),
      );
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final isFav =
        HiveService.isFavorite(widget.meal.id);

    return MouseRegion(
      onEnter: (_) {
        setState(() {
          isHovered = true;
        });
      },
      onExit: (_) {
        setState(() {
          isHovered = false;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        transform: Matrix4.translationValues(
          0,
          isHovered ? -6 : 0,
          0,
        ),
        child: GestureDetector(
          onTap: widget.onTap,
          child: Card(
            elevation: isHovered ? 10 : 4,
            shadowColor: Colors.black12,
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(20),
            ),
            child: ClipRRect(
              borderRadius:
                  BorderRadius.circular(20),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      SizedBox(
                        height: 170,
                        width: double.infinity,
                        child: Image.network(
                          widget.meal.image,
                          fit: BoxFit.cover,
                          errorBuilder:
                              (_, __, ___) {
                            return const Center(
                              child: Text(
                                'Gambar gagal dimuat',
                              ),
                            );
                          },
                        ),
                      ),
                      Positioned(
                        top: 10,
                        right: 10,
                        child: GestureDetector(
                          onTap: toggleFavorite,
                          child: Container(
                            padding:
                                const EdgeInsets.all(
                              8,
                            ),
                            decoration:
                                BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.circular(
                                50,
                              ),
                              boxShadow: const [
                                BoxShadow(
                                  blurRadius: 6,
                                  color:
                                      Colors.black12,
                                ),
                              ],
                            ),
                            child: Icon(
                              isFav
                                  ? Icons.favorite
                                  : Icons
                                      .favorite_border,
                              size: 22,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Padding(
                      padding:
                          const EdgeInsets.all(12),
                      child: Align(
                        alignment:
                            Alignment.topLeft,
                        child: Text(
                          widget.meal.name,
                          maxLines: 2,
                          overflow:
                              TextOverflow.ellipsis,
                          style:
                              const TextStyle(
                            fontSize: 15,
                            fontWeight:
                                FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}