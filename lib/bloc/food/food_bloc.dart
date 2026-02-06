import 'package:flutter_bloc/flutter_bloc.dart';
import 'food_event.dart';
import 'food_state.dart';
import '../../models/food_item.dart';

class FoodBloc extends Bloc<FoodEvent, FoodState> {
  FoodBloc() : super(FoodInitial()) {
    on<LoadFoodItems>(_onLoadFoodItems);
    on<FilterByCategory>(_onFilterByCategory);
    on<SearchFoodItems>(_onSearchFoodItems);
  }

  final List<FoodItem> _allFoodItems = const [
    FoodItem(
      id: '1',
      name: 'Classic Burger',
      description: 'Spicy with mayonnaise',
      price: 77.34,
      rating: 4.8,
      image: 'assets/images/burger.jpg',
      category: 'Burgers',
    ),
    FoodItem(
      id: '2',
      name: 'Margherita Pizza',
      description: 'With extra cheese',
      price: 89.94,
      rating: 4.9,
      image: 'assets/images/marg_pizza.jpg',
      category: 'Pizza',
    ),
    FoodItem(
      id: '3',
      name: 'Sushi Platter',
      description: 'Assorted fresh sushi with...',
      price: 95.50,
      rating: 4.8,
      image: 'assets/images/sushi.jpg',
      category: 'Asian',
    ),
    FoodItem(
      id: '4',
      name: 'Pasta Carbonara',
      description: 'Creamy Italian pasta',
      price: 65.00,
      rating: 4.6,
      image: 'assets/images/pasta.jpg',
      category: 'Pizza',
    ),
    FoodItem(
      id: '5',
      name: 'Cheese Burger',
      description: 'Double cheese delight',
      price: 82.00,
      rating: 4.7,
      image: 'assets/images/che_bur.jpg',
      category: 'Burgers',
    ),
    FoodItem(
      id: '6',
      name: 'Ramen Bowl',
      description: 'Traditional Japanese ramen',
      price: 72.50,
      rating: 4.9,
      image: 'assets/images/ramen.jpg',
      category: 'Asian',
    ),
  ];

  Future<void> _onLoadFoodItems(
    LoadFoodItems event,
    Emitter<FoodState> emit,
  ) async {
    emit(FoodLoading());

    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 500));

    emit(
      FoodLoaded(
        allItems: _allFoodItems,
        filteredItems: _allFoodItems,
        selectedCategory: 'All',
        searchQuery: '',
      ),
    );
  }

  List<FoodItem> _applyFilters(
    List<FoodItem> items,
    String category,
    String query,
  ) {
    final normalizedQuery = query.trim().toLowerCase();

    return items.where((item) {
      final matchesCategory = category == 'All' || item.category == category;
      if (!matchesCategory) {
        return false;
      }

      if (normalizedQuery.isEmpty) {
        return true;
      }

      final haystack =
          '${item.name} ${item.description} ${item.category}'.toLowerCase();
      return haystack.contains(normalizedQuery);
    }).toList();
  }

  Future<void> _onFilterByCategory(
    FilterByCategory event,
    Emitter<FoodState> emit,
  ) async {
    if (state is FoodLoaded) {
      final currentState = state as FoodLoaded;

      final filteredItems = _applyFilters(
        currentState.allItems,
        event.category,
        currentState.searchQuery,
      );

      emit(
        FoodLoaded(
          allItems: currentState.allItems,
          filteredItems: filteredItems,
          selectedCategory: event.category,
          searchQuery: currentState.searchQuery,
        ),
      );
    }
  }

  Future<void> _onSearchFoodItems(
    SearchFoodItems event,
    Emitter<FoodState> emit,
  ) async {
    if (state is FoodLoaded) {
      final currentState = state as FoodLoaded;

      final filteredItems = _applyFilters(
        currentState.allItems,
        currentState.selectedCategory,
        event.query,
      );

      emit(
        FoodLoaded(
          allItems: currentState.allItems,
          filteredItems: filteredItems,
          selectedCategory: currentState.selectedCategory,
          searchQuery: event.query,
        ),
      );
    }
  }
}
