// To parse this JSON data, do
//
//     final property = propertyFromJson(jsonString);

import 'dart:convert';

Property propertyFromJson(String str) => Property.fromJson(json.decode(str));

String propertyToJson(Property data) => json.encode(data.toJson());

class Property {
  bool error;
  Data data;
  String message;

  Property({
    required this.error,
    required this.data,
    required this.message,
  });

  factory Property.fromJson(Map<String, dynamic> json) => Property(
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
  List<PropertyElement> properties;
  Meta meta;

  Data({
    required this.properties,
    required this.meta,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    properties: List<PropertyElement>.from(json["properties"].map((x) => PropertyElement.fromJson(x))),
    meta: Meta.fromJson(json["meta"]),
  );

  Map<String, dynamic> toJson() => {
    "properties": List<dynamic>.from(properties.map((x) => x.toJson())),
    "meta": meta.toJson(),
  };
}

class Meta {
  int from;
  int to;
  int total;
  int perPage;
  int currentPage;
  int lastPage;

  Meta({
    required this.from,
    required this.to,
    required this.total,
    required this.perPage,
    required this.currentPage,
    required this.lastPage,
  });

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
    from: json["from"],
    to: json["to"],
    total: json["total"],
    perPage: json["per_page"],
    currentPage: json["current_page"],
    lastPage: json["last_page"],
  );

  Map<String, dynamic> toJson() => {
    "from": from,
    "to": to,
    "total": total,
    "per_page": perPage,
    "current_page": currentPage,
    "last_page": lastPage,
  };
}

class PropertyElement {
  int id;
  String name;
  String price;
  String location;
  String? country;
  String? state;
  String city;
  int? numberBedroom;
  int? numberBathroom;
  int? square;
  Type type;
  dynamic typeId;
  String? latitude;
  String? longitude;
  int totalReviewsCount;
  double averageRating;
  int wishlist;
  String image;
  Agent agent;

  PropertyElement({
    required this.id,
    required this.name,
    required this.price,
    required this.location,
    required this.country,
    required this.state,
    required this.city,
    required this.numberBedroom,
    required this.numberBathroom,
    required this.square,
    required this.type,
    required this.typeId,
    required this.latitude,
    required this.longitude,
    required this.totalReviewsCount,
    required this.averageRating,
    required this.wishlist,
    required this.image,
    required this.agent,
  });

  factory PropertyElement.fromJson(Map<String, dynamic> json) => PropertyElement(
    id: json["id"],
    name: json["name"],
    price: json["price"],
    location: json["location"],
    country: json["country"],
    state: json["state"],
    city: json["city"],
    numberBedroom: json["number_bedroom"],
    numberBathroom: json["number_bathroom"],
    square: json["square"],
    type: typeValues.map[json["type"]]!,
    typeId: json["type_id"],
    latitude: json["latitude"],
    longitude: json["longitude"],
    totalReviewsCount: json["totalReviewsCount"],
    averageRating: json["average_rating"]?.toDouble(),
    wishlist: json["wishlist"],
    image: json["image"],
    agent: Agent.fromJson(json["agent"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "price": price,
    "location": location,
    "country": country,
    "state": state,
    "city": city,
    "number_bedroom": numberBedroom,
    "number_bathroom": numberBathroom,
    "square": square,
    "type": typeValues.reverse[type],
    "type_id": typeId,
    "latitude": latitude,
    "longitude": longitude,
    "totalReviewsCount": totalReviewsCount,
    "average_rating": averageRating,
    "wishlist": wishlist,
    "image": image,
    "agent": agent.toJson(),
  };
}

class Agent {
  dynamic id;
  String name;
  dynamic email;
  dynamic phone;
  dynamic profileImage;

  Agent({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.profileImage,
  });

  factory Agent.fromJson(Map<String, dynamic> json) => Agent(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    phone: json["phone"],
    profileImage: json["profile_image"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "phone": phone,
    "profile_image": profileImage,
  };
}

enum Type {
  RENT,
  SALE
}

final typeValues = EnumValues({
  "rent": Type.RENT,
  "sale": Type.SALE
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
