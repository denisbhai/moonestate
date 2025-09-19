// To parse this JSON data, do
//
//     final review = reviewFromJson(jsonString);

import 'dart:convert';

Review reviewFromJson(String str) => Review.fromJson(json.decode(str));

String reviewToJson(Review data) => json.encode(data.toJson());

class Review {
  bool error;
  Data data;
  var message;

  Review({
    required this.error,
    required this.data,
    required this.message,
  });

  factory Review.fromJson(Map<String, dynamic> json) => Review(
    error: json["error"],
    data: Data.fromJson(json["data"]),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "error": error,
    "data": data.toJson(),
    "message": message,
  };
}

class Data {
  List<ReviewElement> reviews;

  Data({
    required this.reviews,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    reviews: List<ReviewElement>.from(json["reviews"].map((x) => ReviewElement.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "reviews": List<dynamic>.from(reviews.map((x) => x.toJson())),
  };
}

class ReviewElement {
  int id;
  int star;
  var comment;
  var user;
  var createdAt;

  ReviewElement({
    required this.id,
    required this.star,
    required this.comment,
    required this.user,
    required this.createdAt,
  });

  factory ReviewElement.fromJson(Map<String, dynamic> json) => ReviewElement(
    id: json["id"],
    star: json["star"],
    comment: json["comment"],
    user: json["user"],
    createdAt: json["created_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "star": star,
    "comment": comment,
    "user": user,
    "created_at": createdAt,
  };
}
