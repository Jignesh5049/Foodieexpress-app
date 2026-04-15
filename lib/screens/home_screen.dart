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
import '../theme/app_theme.dart';

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
      extendBody: true,
      body: screens[_selectedIndex],
      bottomNavigationBar: Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        decoration: BoxDecoration(
          color: AppTheme.card,
          borderRadius: BorderRadius.circular(24),
          boxShadow: AppTheme.softShadow,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
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
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHomeContent() {
    return Stack(
      children: [
        Positioned.fill(
          child: Container(
            decoration: const BoxDecoration(
              gradient: AppTheme.warmBackgroundGradient,
            ),
          ),
        ),
        Positioned(top: -80, right: -40, child: _decorativeOrb(170)),
        Positioned(bottom: 130, left: -55, child: _decorativeOrb(130)),
        SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 98),
                  child: TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: 1),
                    duration: const Duration(milliseconds: 650),
                    builder: (context, value, child) {
                      return Opacity(
                        opacity: value,
                        child: Transform.translate(
                          offset: Offset(0, 18 * (1 - value)),
                          child: child,
                        ),
                      );
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            gradient: AppTheme.heroGradient,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: AppTheme.softShadow,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(999),
                                    ),
                                    child: const Row(
                                      children: [
                                        Icon(
                                          Icons.location_on,
                                          size: 14,
                                          color: Colors.white,
                                        ),
                                        SizedBox(width: 4),
                                        Text(
                                          'Deliver to Home',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Spacer(),
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.local_mall,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 18),
                              Text(
                                'Craving\nsomething bold?',
                                style: GoogleFonts.playfairDisplay(
                                  fontSize: 32,
                                  height: 1.05,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Freshly curated plates. Fast delivery. No compromise.',
                                style: TextStyle(
                                  color: Color(0xFFD8F4E6),
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  _buildMetricPill('32 min', Icons.timer_outlined),
                                  const SizedBox(width: 8),
                                  _buildMetricPill('4.8 rating', Icons.star_border),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            Expanded(
                              child: Material(
                                elevation: 6,
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                child: TextField(
                                  controller: _searchController,
                                  onChanged: (value) {
                                    context.read<FoodBloc>().add(
                                      SearchFoodItems(query: value),
                                    );
                                  },
                                  decoration: InputDecoration(
                                    hintText: 'Search dishes or cuisines',
                                    prefixIcon: const Icon(
                                      Icons.search,
                                      color: AppTheme.primary,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Container(
                              width: 52,
                              height: 52,
                              decoration: BoxDecoration(
                                color: AppTheme.accent,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: AppTheme.softShadow,
                              ),
                              child: const Icon(
                                Icons.tune,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),
                        const Text(
                          'Popular Categories',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 10),
                        BlocBuilder<FoodBloc, FoodState>(
                          builder: (context, state) {
                            if (state is FoodLoaded) {
                              return SizedBox(
                                height: 44,
                                child: ListView(
                                  scrollDirection: Axis.horizontal,
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
                        BlocBuilder<FoodBloc, FoodState>(
                          builder: (context, state) {
                            if (state is FoodLoading) {
                              return const Padding(
                                padding: EdgeInsets.only(top: 80),
                                child: Center(child: CircularProgressIndicator()),
                              );
                            } else if (state is FoodLoaded) {
                              return LayoutBuilder(
                                builder: (context, constraints) {
                                  final width = constraints.maxWidth;
                                  final crossAxisCount = width >= 950
                                      ? 4
                                      : width >= 620
                                            ? 3
                                            : 2;
                                  final childAspectRatio = width < 360
                                      ? 0.7
                                      : width < 420
                                            ? 0.76
                                            : 0.82;

                                  return GridView.builder(
                                    itemCount: state.filteredItems.length,
                                    physics: const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: crossAxisCount,
                                          childAspectRatio: childAspectRatio,
                                          crossAxisSpacing: 14,
                                          mainAxisSpacing: 14,
                                        ),
                                    itemBuilder: (context, index) {
                                      return _buildFoodCard(
                                        state.filteredItems[index],
                                      );
                                    },
                                  );
                                },
                              );
                            } else if (state is FoodError) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 80),
                                child: Center(child: Text(state.message)),
                              );
                            }
                            return const Padding(
                              padding: EdgeInsets.only(top: 80),
                              child: Center(child: Text('No items available')),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMetricPill(String text, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 14),
          const SizedBox(width: 4),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _decorativeOrb(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppTheme.primary.withOpacity(0.08),
      ),
    );
  }

  Widget _buildCategoryChip(String label, String selectedCategory) {
    final isSelected = selectedCategory == label;
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        child: ChoiceChip(
          label: Text(label),
          selected: isSelected,
          onSelected: (selected) {
            context.read<FoodBloc>().add(FilterByCategory(category: label));
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: isSelected ? AppTheme.primary : const Color(0xFFD5DDD8),
            ),
          ),
          backgroundColor: Colors.white,
          selectedColor: AppTheme.primary,
          labelStyle: TextStyle(
            color: isSelected ? Colors.white : AppTheme.textPrimary,
            fontWeight: FontWeight.w600,
          ),
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
            final isCompact = constraints.maxWidth < 170;
            final imageHeight = isCompact ? 92.0 : 108.0;
            final titleFont = isCompact ? 13.0 : 14.0;
            final descFont = isCompact ? 10.0 : 11.0;
            final priceFont = isCompact ? 14.0 : 15.0;
            final favoriteSize = isCompact ? 17.0 : 19.0;

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
                  color: AppTheme.card,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: AppTheme.softShadow,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        Container(
                          height: imageHeight,
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                            gradient: LinearGradient(
                              colors: [Color(0xFFFFE7D4), Color(0xFFFFF2E6)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                            child: _buildFoodImage(item.image, 46),
                          ),
                        ),
                        Positioned(
                          top: 8,
                          left: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 7,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.star,
                                  size: 12,
                                  color: AppTheme.accent,
                                ),
                                const SizedBox(width: 3),
                                Text(
                                  item.rating.toString(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
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
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.9),
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
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 10, 10, 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.name,
                              style: TextStyle(
                                fontSize: titleFont,
                                fontWeight: FontWeight.w700,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item.description,
                              style: TextStyle(
                                fontSize: descFont,
                                color: Colors.grey[600],
                                height: 1.2,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const Spacer(),
                            Row(
                              children: [
                                Text(
                                  '₹${item.price.toStringAsFixed(0)}',
                                  style: TextStyle(
                                    fontSize: priceFont,
                                    fontWeight: FontWeight.w800,
                                    color: AppTheme.primary,
                                  ),
                                ),
                                const Spacer(),
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
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 7,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppTheme.primary,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Row(
                                      children: [
                                        Icon(
                                          Icons.add,
                                          size: 15,
                                          color: Colors.white,
                                        ),
                                        SizedBox(width: 3),
                                        Text(
                                          'Add',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 11,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
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
