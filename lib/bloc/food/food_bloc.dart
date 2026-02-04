import 'package:flutter_bloc/flutter_bloc.dart';
import 'food_event.dart';
import 'food_state.dart';
import '../../models/food_item.dart';

class FoodBloc extends Bloc<FoodEvent, FoodState> {
  FoodBloc() : super(FoodInitial()) {
    on<LoadFoodItems>(_onLoadFoodItems);
    on<FilterByCategory>(_onFilterByCategory);
  }

  final List<FoodItem> _allFoodItems = const [
    FoodItem(
      id: '1',
      name: 'Classic Burger',
      description: 'Spicy with mayonnaise',
      price: 77.34,
      rating: 4.8,
      image: '🍔',
      category: 'Burgers',
    ),
    FoodItem(
      id: '2',
      name: 'Margherita Pizza',
      description: 'With extra cheese',
      price: 89.94,
      rating: 4.9,
      image: '🍕',
      category: 'Pizza',
    ),
    FoodItem(
      id: '3',
      name: 'Sushi Platter',
      description: 'Assorted fresh sushi with...',
      price: 95.50,
      rating: 4.8,
      image: '🍣',
      category: 'Asian',
    ),
    FoodItem(
      id: '4',
      name: 'Pasta Carbonara',
      description: 'Creamy Italian pasta',
      price: 65.00,
      rating: 4.6,
      image: '🍝',
      category: 'Pizza',
    ),
    FoodItem(
      id: '5',
      name: 'Cheese Burger',
      description: 'Double cheese delight',
      price: 82.00,
      rating: 4.7,
      image: '🍔',
      category: 'Burgers',
    ),
    FoodItem(
      id: '6',
      name: 'Ramen Bowl',
      description: 'Traditional Japanese ramen',
      price: 72.50,
      rating: 4.9,
      image: '🍜',
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
      ),
    );
  }

  Future<void> _onFilterByCategory(
    FilterByCategory event,
    Emitter<FoodState> emit,
  ) async {
    if (state is FoodLoaded) {
      final currentState = state as FoodLoaded;

      final filteredItems = event.category == 'All'
          ? currentState.allItems
          : currentState.allItems
                .where((item) => item.category == event.category)
                .toList();

      emit(
        FoodLoaded(
          allItems: currentState.allItems,
          filteredItems: filteredItems,
          selectedCategory: event.category,
        ),
      );
    }
  }
}
