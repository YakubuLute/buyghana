import 'package:equatable/equatable.dart';

class Address extends Equatable {
  const Address({
    this.street,
    this.apartment,
    this.city,
    this.postalCode,
    this.country,
  });

  const Address.empty()
      : street = "Test String",
        apartment = "Test String",
        city = "Test String",
        postalCode = "Test String",
        country = "Test String";

  final String? street;
  final String? apartment;
  final String? city;
  final String? postalCode;
  final String? country;

  bool get isEmpty =>
      street == null &&
      apartment == null &&
      city == null &&
      postalCode == null &&
      country == null;

  @override
  List<dynamic> get props => [
        street,
        apartment,
        city,
        postalCode,
        country,
      ];
}
