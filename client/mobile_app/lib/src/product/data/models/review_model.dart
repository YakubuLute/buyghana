import 'dart:convert';

import 'package:ecomly/core/utils/typedefs.dart';
import 'package:ecomly/src/product/domain/entities/review.dart';

class ReviewModel extends Review {
  const ReviewModel({
    required super.id,
    required super.userId,
    required super.userName,
    required super.comment,
    required super.rating,
    required super.date,
  });

  ReviewModel.empty([DateTime? date])
      : this(
          id: "Test String",
          userId: "Test String",
          userName: "Test String",
          comment: "Test String",
          rating: 1,
          date: date ?? DateTime.now(),
        );

  factory ReviewModel.fromJson(String source) =>
      ReviewModel.fromMap(jsonDecode(source) as DataMap);

  ReviewModel.fromMap(DataMap map)
      : this(
          id: map['id'] as String? ?? map['_id'] as String,
          userId: map['user'] as String,
          userName: map['userName'] as String,
          comment: map['comment'] as String,
          rating: (map['rating'] as num).toDouble(),
          date: DateTime.parse(map['date'] as String),
        );

  ReviewModel copyWith({
    String? id,
    String? userId,
    String? userName,
    String? comment,
    double? rating,
    DateTime? date,
  }) {
    return ReviewModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      comment: comment ?? this.comment,
      rating: rating ?? this.rating,
      date: date ?? this.date,
    );
  }

  DataMap toMap() {
    return <String, dynamic>{
      'id': id,
      'user': userId,
      'userName': userName,
      'comment': comment,
      'rating': rating,
      'date': date.toIso8601String(),
    };
  }

  String toJson() => jsonEncode(toMap());
}
