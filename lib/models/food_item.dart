import 'package:equatable/equatable.dart';

class FoodItem extends Equatable {
  final String id;
  final String name;
  final String description;
  final double price;
  final double rating;
  final String image;
  final String category;

  const FoodItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.rating,
    this.image = '🍕',
    required this.category,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    price,
    rating,
    image,
    category,
  ];
}
