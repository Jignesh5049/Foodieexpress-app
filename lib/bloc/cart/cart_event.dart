import 'package:equatable/equatable.dart';
import '../../models/food_item.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object?> get props => [];
}

class AddToCart extends CartEvent {
  final FoodItem foodItem;

  const AddToCart({required this.foodItem});

  @override
  List<Object?> get props => [foodItem];
}

class RemoveFromCart extends CartEvent {
  final String foodItemId;

  const RemoveFromCart({required this.foodItemId});

  @override
  List<Object?> get props => [foodItemId];
}

class UpdateCartItemQuantity extends CartEvent {
  final String foodItemId;
  final int quantity;

  const UpdateCartItemQuantity({
    required this.foodItemId,
    required this.quantity,
  });

  @override
  List<Object?> get props => [foodItemId, quantity];
}

class ClearCart extends CartEvent {}
