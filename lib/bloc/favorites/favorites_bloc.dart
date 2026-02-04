import 'package:flutter_bloc/flutter_bloc.dart';
import 'favorites_event.dart';
import 'favorites_state.dart';
import '../../models/food_item.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  FavoritesBloc() : super(const FavoritesState()) {
    on<ToggleFavorite>(_onToggleFavorite);
    on<LoadFavorites>(_onLoadFavorites);
  }

  void _onToggleFavorite(ToggleFavorite event, Emitter<FavoritesState> emit) {
    final items = List<FoodItem>.from(state.items);
    final existingIndex = items.indexWhere(
      (item) => item.id == event.foodItem.id,
    );

    if (existingIndex >= 0) {
      items.removeAt(existingIndex);
    } else {
      items.add(event.foodItem);
    }

    emit(state.copyWith(items: items));
  }

  void _onLoadFavorites(LoadFavorites event, Emitter<FavoritesState> emit) {
    // Load favorites from storage if needed
    emit(state);
  }
}
