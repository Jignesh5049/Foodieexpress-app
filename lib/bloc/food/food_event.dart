import 'package:equatable/equatable.dart';

abstract class FoodEvent extends Equatable {
  const FoodEvent();

  @override
  List<Object?> get props => [];
}

class LoadFoodItems extends FoodEvent {}

class FilterByCategory extends FoodEvent {
  final String category;

  const FilterByCategory({required this.category});

  @override
  List<Object?> get props => [category];
}

class SearchFoodItems extends FoodEvent {
  final String query;

  const SearchFoodItems({required this.query});

  @override
  List<Object?> get props => [query];
}
