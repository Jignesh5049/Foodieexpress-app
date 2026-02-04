import 'package:equatable/equatable.dart';
import '../../models/food_item.dart';

abstract class FavoritesEvent extends Equatable {
  const FavoritesEvent();

  @override
  List<Object?> get props => [];
}

class ToggleFavorite extends FavoritesEvent {
  final FoodItem foodItem;

  const ToggleFavorite({required this.foodItem});

  @override
  List<Object?> get props => [foodItem];
}

class LoadFavorites extends FavoritesEvent {}
