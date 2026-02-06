import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/favorites/favorites_bloc.dart';
import '../bloc/favorites/favorites_state.dart';
import '../bloc/favorites/favorites_event.dart';
import '../bloc/cart/cart_bloc.dart';
import '../bloc/cart/cart_event.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Favorites',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                BlocBuilder<FavoritesBloc, FavoritesState>(
                  builder: (context, state) {
                    return Text(
                      '${state.items.length} items',
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    );
                  },
                ),
              ],
            ),
          ),

          // Favorites List
          Expanded(
            child: BlocBuilder<FavoritesBloc, FavoritesState>(
              builder: (context, state) {
                if (state.items.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.favorite_border,
                          size: 80,
                          color: Colors.grey[300],
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'No favorites yet',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Start adding your favorite items',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                }

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
                      itemCount: state.items.length,
                      itemBuilder: (context, index) {
                        final item = state.items[index];
                        return LayoutBuilder(
                          builder: (context, cardConstraints) {
                            final isCompact = cardConstraints.maxHeight < 230;
                            final imageFlex = isCompact ? 4 : 5;
                            final contentFlex = isCompact ? 5 : 4;
                            final contentPadding =
                                EdgeInsets.all(isCompact ? 8 : 10);
                            final imageSize = isCompact ? 40.0 : 50.0;
                            final ratingFont = isCompact ? 10.0 : 11.0;
                            final titleFont = isCompact ? 13.0 : 15.0;
                            final descFont = isCompact ? 10.0 : 11.0;
                            final priceFont = isCompact ? 14.0 : 16.0;
                            final iconSize = isCompact ? 16.0 : 18.0;
                            final favoriteSize = isCompact ? 18.0 : 20.0;

                            return Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: const Offset(0, 3),
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
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.orange[100],
                                              borderRadius:
                                                  const BorderRadius.only(
                                                topLeft: Radius.circular(16),
                                                topRight: Radius.circular(16),
                                              ),
                                            ),
                                            child: Center(
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
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                    'Removed from favorites',
                                                  ),
                                                  duration: Duration(
                                                    seconds: 1,
                                                  ),
                                                ),
                                              );
                                            },
                                            child: Container(
                                              padding: EdgeInsets.all(
                                                isCompact ? 5 : 6,
                                              ),
                                              decoration: const BoxDecoration(
                                                color: Colors.white,
                                                shape: BoxShape.circle,
                                              ),
                                              child: Icon(
                                                Icons.favorite,
                                                size: favoriteSize,
                                                color: Colors.red,
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal:
                                                      isCompact ? 5 : 6,
                                                  vertical: isCompact ? 1 : 2,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: Colors.orange[100],
                                                  borderRadius:
                                                      BorderRadius.circular(4),
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
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: isCompact ? 4 : 6,
                                          ),
                                          Text(
                                            item.name,
                                            style: TextStyle(
                                              fontSize: titleFont,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          SizedBox(
                                            height: isCompact ? 3 : 4,
                                          ),
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
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                '₹${item.price.toStringAsFixed(2)}',
                                                style: TextStyle(
                                                  fontSize: priceFont,
                                                  fontWeight: FontWeight.bold,
                                                  color:
                                                      const Color(0xFF6366F1),
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  context.read<CartBloc>().add(
                                                    AddToCart(foodItem: item),
                                                  );
                                                  ScaffoldMessenger.of(
                                                    context,
                                                  ).showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                        '${item.name} added to cart',
                                                      ),
                                                      duration: const Duration(
                                                        seconds: 1,
                                                      ),
                                                    ),
                                                  );
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.all(
                                                    isCompact ? 5 : 6,
                                                  ),
                                                  decoration: const BoxDecoration(
                                                    color: Color(0xFF6366F1),
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
                            );
                          },
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
