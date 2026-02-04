import 'package:flutter_bloc/flutter_bloc.dart';
import 'cart_event.dart';
import 'cart_state.dart';
import '../../models/cart_item.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(const CartState()) {
    on<AddToCart>(_onAddToCart);
    on<RemoveFromCart>(_onRemoveFromCart);
    on<UpdateCartItemQuantity>(_onUpdateCartItemQuantity);
    on<ClearCart>(_onClearCart);
  }

  void _onAddToCart(AddToCart event, Emitter<CartState> emit) {
    final items = List<CartItem>.from(state.items);

    final existingIndex = items.indexWhere(
      (item) => item.foodItem.id == event.foodItem.id,
    );

    if (existingIndex >= 0) {
      items[existingIndex] = items[existingIndex].copyWith(
        quantity: items[existingIndex].quantity + 1,
      );
    } else {
      items.add(CartItem(foodItem: event.foodItem, quantity: 1));
    }

    final total = _calculateTotal(items);
    emit(state.copyWith(items: items, totalAmount: total));
  }

  void _onRemoveFromCart(RemoveFromCart event, Emitter<CartState> emit) {
    final items = state.items
        .where((item) => item.foodItem.id != event.foodItemId)
        .toList();

    final total = _calculateTotal(items);
    emit(state.copyWith(items: items, totalAmount: total));
  }

  void _onUpdateCartItemQuantity(
    UpdateCartItemQuantity event,
    Emitter<CartState> emit,
  ) {
    if (event.quantity <= 0) {
      add(RemoveFromCart(foodItemId: event.foodItemId));
      return;
    }

    final items = state.items.map((item) {
      if (item.foodItem.id == event.foodItemId) {
        return item.copyWith(quantity: event.quantity);
      }
      return item;
    }).toList();

    final total = _calculateTotal(items);
    emit(state.copyWith(items: items, totalAmount: total));
  }

  void _onClearCart(ClearCart event, Emitter<CartState> emit) {
    emit(const CartState());
  }

  double _calculateTotal(List<CartItem> items) {
    return items.fold(
      0.0,
      (sum, item) => sum + (item.foodItem.price * item.quantity),
    );
  }
}
