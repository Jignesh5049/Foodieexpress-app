import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../bloc/food/food_bloc.dart';
import '../bloc/food/food_event.dart';
import '../bloc/food/food_state.dart';
import '../bloc/cart/cart_bloc.dart';
import '../bloc/cart/cart_event.dart';
import '../bloc/favorites/favorites_bloc.dart';
import '../bloc/favorites/favorites_event.dart';
import '../bloc/favorites/favorites_state.dart';
import '../models/food_item.dart';
import 'cart_screen.dart';
import 'profile_screen.dart';
import 'favorites_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final TextEditingController _searchController = TextEditingController();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      _buildHomeContent(),
      const CartScreen(),
      const FavoritesScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: const Color(0xFF6366F1),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  Widget _buildHomeContent() {
    return SafeArea(
      child: Column(
        children: [
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: 1),
            duration: const Duration(milliseconds: 600),
            builder: (context, value, child) {
              return Opacity(
                opacity: value,
                child: Transform.translate(
                  offset: Offset(0, 14 * (1 - value)),
                  child: child,
                ),
              );
            },
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF6B5B95), Color(0xFF8A7CD6)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.12),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'FoodieExpress',
                            style: GoogleFonts.playfairDisplay(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Handpicked flavors for your mood',
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFFEDE7F6),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(
                          Icons.shopping_bag,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Material(
                    elevation: 6,
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (value) {
                        context.read<FoodBloc>().add(
                          SearchFoodItems(query: value),
                        );
                      },
                      decoration: InputDecoration(
                        hintText: 'Search dishes, restaurants...',
                        hintStyle: const TextStyle(color: Colors.grey),
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Color(0xFF6B5B95),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),

          // Category Filters
          BlocBuilder<FoodBloc, FoodState>(
            builder: (context, state) {
              if (state is FoodLoaded) {
                return SizedBox(
                  height: 40,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      _buildCategoryChip('All', state.selectedCategory),
                      _buildCategoryChip('Burgers', state.selectedCategory),
                      _buildCategoryChip('Pizza', state.selectedCategory),
                      _buildCategoryChip('Asian', state.selectedCategory),
                    ],
                  ),
                );
              }
              return const SizedBox();
            },
          ),
          const SizedBox(height: 16),

          // Food Items Grid
          Expanded(
            child: BlocBuilder<FoodBloc, FoodState>(
              builder: (context, state) {
                if (state is FoodLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is FoodLoaded) {
                  return LayoutBuilder(
                    builder: (context, constraints) {
                      final width = constraints.maxWidth;
                      final crossAxisCount = width >= 900
                          ? 4
                          : width >= 600
                                ? 3
                                : 2;
                      final childAspectRatio = width < 360
                          ? 0.62
                          : width < 420
                                ? 0.68
                                : 0.72;

                      return GridView.builder(
                        padding: const EdgeInsets.all(16),
                        gridDelegate:
                            SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: crossAxisCount,
                              childAspectRatio: childAspectRatio,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                            ),
                        itemCount: state.filteredItems.length,
                        itemBuilder: (context, index) {
                          return _buildFoodCard(state.filteredItems[index]);
                        },
                      );
                    },
                  );
                } else if (state is FoodError) {
                  return Center(child: Text(state.message));
                }
                return const Center(child: Text('No items available'));
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String label, String selectedCategory) {
    final isSelected = selectedCategory == label;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          context.read<FoodBloc>().add(FilterByCategory(category: label));
        },
        backgroundColor: Colors.grey[200],
        selectedColor: const Color(0xFF6366F1),
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : Colors.black,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildFoodCard(FoodItem item) {
    return BlocBuilder<FavoritesBloc, FavoritesState>(
      builder: (context, favState) {
        final isFavorite = favState.isFavorite(item.id);

        return LayoutBuilder(
          builder: (context, constraints) {
            final isCompact = constraints.maxHeight < 230;
            final imageFlex = isCompact ? 4 : 5;
            final contentFlex = isCompact ? 5 : 4;
            final contentPadding = EdgeInsets.all(isCompact ? 8 : 10);
            final imageSize = isCompact ? 40.0 : 50.0;
            final ratingFont = isCompact ? 10.0 : 11.0;
            final titleFont = isCompact ? 13.0 : 15.0;
            final descFont = isCompact ? 10.0 : 11.0;
            final priceFont = isCompact ? 14.0 : 16.0;
            final iconSize = isCompact ? 16.0 : 18.0;
            final favoriteSize = isCompact ? 18.0 : 20.0;

            return TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.94, end: 1),
              duration: const Duration(milliseconds: 420),
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: Transform.scale(scale: value, child: child),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 14,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: imageFlex,
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(18),
                                topRight: Radius.circular(18),
                              ),
                              child: Container(
                                color: Colors.orange[100],
                                child: _buildFoodImage(
                                  item.image,
                                  imageSize,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: GestureDetector(
                              onTap: () {
                                context.read<FavoritesBloc>().add(
                                  ToggleFavorite(foodItem: item),
                                );

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      isFavorite
                                          ? 'Removed from favorites'
                                          : 'Added to favorites',
                                    ),
                                    duration: const Duration(seconds: 1),
                                  ),
                                );
                              },
                              child: Container(
                                padding: EdgeInsets.all(isCompact ? 5 : 6),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  isFavorite
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  size: favoriteSize,
                                  color: isFavorite ? Colors.red : Colors.grey,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: contentFlex,
                      child: Padding(
                        padding: contentPadding,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: isCompact ? 5 : 6,
                                    vertical: isCompact ? 1 : 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.orange[100],
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.star,
                                        size: 12,
                                        color: Colors.orange,
                                      ),
                                      const SizedBox(width: 2),
                                      Text(
                                        item.rating.toString(),
                                        style: TextStyle(
                                          fontSize: ratingFont,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: isCompact ? 4 : 6),
                            Text(
                              item.name,
                              style: TextStyle(
                                fontSize: titleFont,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: isCompact ? 3 : 4),
                            Text(
                              item.description,
                              style: TextStyle(
                                fontSize: descFont,
                                color: Colors.grey[600],
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const Spacer(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '₹${item.price.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontSize: priceFont,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF6B5B95),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    context.read<CartBloc>().add(
                                      AddToCart(foodItem: item),
                                    );

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          '${item.name} added to cart',
                                        ),
                                        duration: const Duration(seconds: 1),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(isCompact ? 5 : 6),
                                    decoration: const BoxDecoration(
                                      color: Color(0xFF6B5B95),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.add,
                                      size: iconSize,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildFoodImage(String image, double size) {
    if (image.startsWith('assets/')) {
      return Image.asset(
        image,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      );
    }
    return Text(image, style: TextStyle(fontSize: size));
  }
}
