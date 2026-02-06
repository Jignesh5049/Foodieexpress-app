import 'package:equatable/equatable.dart';
import '../../models/food_item.dart';

abstract class FoodState extends Equatable {
  const FoodState();

  @override
  List<Object?> get props => [];
}

class FoodInitial extends FoodState {}

class FoodLoading extends FoodState {}

class FoodLoaded extends FoodState {
  final List<FoodItem> allItems;
  final List<FoodItem> filteredItems;
  final String selectedCategory;
  final String searchQuery;

  const FoodLoaded({
    required this.allItems,
    required this.filteredItems,
    required this.selectedCategory,
    required this.searchQuery,
  });

  @override
  List<Object?> get props => [
        allItems,
        filteredItems,
        selectedCategory,
        searchQuery,
      ];
}

class FoodError extends FoodState {
  final String message;

  const FoodError({required this.message});

  @override
  List<Object?> get props => [message];
}
