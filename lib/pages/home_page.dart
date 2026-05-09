import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../models/meal_model.dart';
import '../services/api_service.dart';
import '../locals/sharedpref_service.dart';
import 'detail_page.dart';
import 'favorite_page.dart';
import 'login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;

  final TextEditingController searchController =
      TextEditingController();

  late Future<List<Meal>> mealFuture;

  final ScrollController scrollController =
      ScrollController();

  bool showSearchBar = true;

  @override
  void initState() {
    super.initState();

    mealFuture = ApiService.getMeals();

    scrollController.addListener(() {
      if (scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (showSearchBar) {
          setState(() {
            showSearchBar = false;
          });
        }
      }

      if (scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (!showSearchBar) {
          setState(() {
            showSearchBar = true;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    searchController.dispose();
    super.dispose();
  }

  Future<void> handleLogout(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Konfirmasi Logout'),
          content: const Text(
            'Apakah kamu yakin ingin logout?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );

    if (confirm != true) return;

    await SharedPrefService.logout();

    if (!context.mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => const LoginPage(),
      ),
      (route) => false,
    );
  }

  void handleSearch() {
    final query = searchController.text.trim();

    setState(() {
      if (query.isEmpty) {
        mealFuture = ApiService.getMeals();
      } else {
        mealFuture = ApiService.searchMeals(query);
      }
    });
  }

  Widget buildHomeContent() {
    return Column(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          height: showSearchBar ? 80 : 0,
          child: showSearchBar
              ? Padding(
                  padding: const EdgeInsets.all(12),
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: 'Cari menu...',
                      suffixIcon: IconButton(
                        onPressed: handleSearch,
                        icon: const Icon(Icons.search),
                      ),
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                    ),
                  ),
                )
              : const SizedBox(),
        ),
        Expanded(
          child: FutureBuilder<List<Meal>>(
            future: mealFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState ==
                  ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (snapshot.hasError) {
                return const Center(
                  child: Text(
                    'Gagal mengambil data resep',
                  ),
                );
              }

              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              final meals = snapshot.data!;

              if (meals.isEmpty) {
                return const Center(
                  child: Text(
                    'Menu tidak ditemukan',
                  ),
                );
              }

              return GridView.builder(
                controller: scrollController,
                padding: const EdgeInsets.all(12),
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.72,
                ),
                itemCount: meals.length,
                itemBuilder: (context, index) {
                  final meal = meals[index];

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DetailPage(
                            id: meal.id,
                          ),
                        ),
                      );
                    },
                    child: Card(
                      elevation: 4,
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
                            Expanded(
                              child: Image.network(
                                meal.image,
                                width: double.infinity,
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
                            Padding(
                              padding:
                                  const EdgeInsets.all(12),
                              child: Text(
                                meal.name,
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
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      buildHomeContent(),
      const FavoritePage(),
    ];

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          currentIndex == 0
              ? 'Home'
              : 'Favorite',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => handleLogout(context),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorite',
          ),
        ],
      ),
    );
  }
}