import 'package:equatable/equatable.dart';

class ProductCategory extends Equatable {
  const ProductCategory({
    required this.id,
    this.name,
    this.colour,
    this.image,
  });

  const ProductCategory.empty() : this(id: "Test String");

  const ProductCategory.all() : this(id: '', name: 'All');

  final String id;
  final String? name;
  final String? colour;
  final String? image;

  @override
  List<dynamic> get props => [
        id,
        name,
        colour,
      ];
}
