import 'package:equatable/equatable.dart';

class Review extends Equatable {
  const Review({
    required this.id,
    required this.userId,
    required this.userName,
    required this.comment,
    required this.rating,
    required this.date,
  });

  Review.empty()
      : id = "Test String",
        userId = "Test String",
        userName = "Test String",
        comment = "Test String",
        rating = 1,
        date = DateTime.now();

  final String id;
  final String userId;
  final String userName;
  final String comment;
  final double rating;
  final DateTime date;

  @override
  List<dynamic> get props => [
        id,
        userId,
        userName,
        rating,
        date,
      ];
}
