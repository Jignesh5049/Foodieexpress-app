import 'package:equatable/equatable.dart';
import '../../models/food_item.dart';

class FavoritesState extends Equatable {
  final List<FoodItem> items;

  const FavoritesState({this.items = const []});

  FavoritesState copyWith({List<FoodItem>? items}) {
    return FavoritesState(items: items ?? this.items);
  }

  bool isFavorite(String foodItemId) {
    return items.any((item) => item.id == foodItemId);
  }

  @override
  List<Object?> get props => [items];
}
