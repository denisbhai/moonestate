// To parse this JSON data, do
//
//     final propertyDetails = propertyDetailsFromJson(jsonString);

import 'dart:convert';

PropertyDetails propertyDetailsFromJson(String str) => PropertyDetails.fromJson(json.decode(str));

String propertyDetailsToJson(PropertyDetails data) => json.encode(data.toJson());

class PropertyDetails {
  bool error;
  Data data;
  String message;

  PropertyDetails({
    required this.error,
    required this.data,
    required this.message,
  });

  factory PropertyDetails.fromJson(Map<String, dynamic> json) => PropertyDetails(
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
  Property property;
  Reviews? reviews; // Make reviews optional

  Data({
    required this.property,
    this.reviews,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    property: Property.fromJson(json["property"]),
    reviews: json["reviews"] is Map ? Reviews.fromJson(json["reviews"]) : null,
  );

  Map<String, dynamic> toJson() => {
    "property": property.toJson(),
    "reviews": reviews?.toJson(),
  };
}

class Property {
  var id;
  String name;
  String price;
  String location;
  dynamic country;
  dynamic state;
  String city;
  var numberBedroom;
  var numberBathroom;
  var square;
  String type;
  dynamic typeId;
  dynamic latitude;
  dynamic longitude;
  var totalReviewsCount;
  var averageRating;
  var wishlist;
  dynamic service;
  dynamic valueForMoney;
  dynamic rLocation;
  dynamic cleanliness;
  List<String> images;
  String description;
  var numberFloor;
  String content;
  String slugUrl;
  List<Feature> features;
  List<Facility> facilities;
  Category category;
  dynamic subcategory;
  Agent agent;

  Property({
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
    required this.service,
    required this.valueForMoney,
    required this.rLocation,
    required this.cleanliness,
    required this.images,
    required this.description,
    required this.numberFloor,
    required this.content,
    required this.slugUrl,
    required this.features,
    required this.facilities,
    required this.category,
    required this.subcategory,
    required this.agent,
  });

  factory Property.fromJson(Map<String, dynamic> json) => Property(
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
    type: json["type"],
    typeId: json["type_id"],
    latitude: json["latitude"],
    longitude: json["longitude"],
    totalReviewsCount: json["totalReviewsCount"],
    averageRating: json["average_rating"],
    wishlist: json["wishlist"],
    service: json["service"],
    valueForMoney: json["value_for_money"],
    rLocation: json["r_location"],
    cleanliness: json["cleanliness"],
    images: List<String>.from(json["images"].map((x) => x)),
    description: json["description"],
    numberFloor: json["number_floor"],
    content: json["content"],
    slugUrl: json["slug_url"],
    features: List<Feature>.from(json["features"].map((x) => Feature.fromJson(x))),
    facilities: List<Facility>.from(json["facilities"].map((x) => Facility.fromJson(x))),
    category: Category.fromJson(json["category"]),
    subcategory: json["subcategory"],
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
    "type": type,
    "type_id": typeId,
    "latitude": latitude,
    "longitude": longitude,
    "totalReviewsCount": totalReviewsCount,
    "average_rating": averageRating,
    "wishlist": wishlist,
    "service": service,
    "value_for_money": valueForMoney,
    "r_location": rLocation,
    "cleanliness": cleanliness,
    "images": List<dynamic>.from(images.map((x) => x)),
    "description": description,
    "number_floor": numberFloor,
    "content": content,
    "slug_url": slugUrl,
    "features": List<dynamic>.from(features.map((x) => x.toJson())),
    "facilities": List<dynamic>.from(facilities.map((x) => x.toJson())),
    "category": category.toJson(),
    "subcategory": subcategory,
    "agent": agent.toJson(),
  };
}

class Reviews {
  final List<dynamic> data;
  final Map<String, dynamic> meta;

  Reviews({
    required this.data,
    required this.meta,
  });

  factory Reviews.fromJson(Map<String, dynamic> json) => Reviews(
    data: json["data"] is List ? json["data"] : [],
    meta: json["meta"] is Map ? json["meta"] : {},
  );

  Map<String, dynamic> toJson() => {
    "data": data,
    "meta": meta,
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

class Category {
  var id;
  String name;
  String description;
  Status status;
  var order;
  var isDefault;
  DateTime createdAt;
  DateTime updatedAt;
  var parentId;
  CategoryPivot pivot;

  Category({
    required this.id,
    required this.name,
    required this.description,
    required this.status,
    required this.order,
    required this.isDefault,
    required this.createdAt,
    required this.updatedAt,
    required this.parentId,
    required this.pivot,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    id: json["id"],
    name: json["name"],
    description: json["description"],
    status: Status.fromJson(json["status"]),
    order: json["order"],
    isDefault: json["is_default"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    parentId: json["parent_id"],
    pivot: CategoryPivot.fromJson(json["pivot"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
    "status": status.toJson(),
    "order": order,
    "is_default": isDefault,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "parent_id": parentId,
    "pivot": pivot.toJson(),
  };
}

class CategoryPivot {
  var propertyId;
  var categoryId;

  CategoryPivot({
    required this.propertyId,
    required this.categoryId,
  });

  factory CategoryPivot.fromJson(Map<String, dynamic> json) => CategoryPivot(
    propertyId: json["property_id"],
    categoryId: json["category_id"],
  );

  Map<String, dynamic> toJson() => {
    "property_id": propertyId,
    "category_id": categoryId,
  };
}

class Status {
  String value;
  String label;

  Status({
    required this.value,
    required this.label,
  });

  factory Status.fromJson(Map<String, dynamic> json) => Status(
    value: json["value"],
    label: json["label"],
  );

  Map<String, dynamic> toJson() => {
    "value": value,
    "label": label,
  };
}

class Facility {
  var id;
  String name;
  String icon;
  Status status;
  DateTime createdAt;
  DateTime updatedAt;
  FacilityPivot pivot;

  Facility({
    required this.id,
    required this.name,
    required this.icon,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.pivot,
  });

  factory Facility.fromJson(Map<String, dynamic> json) => Facility(
    id: json["id"],
    name: json["name"],
    icon: json["icon"],
    status: Status.fromJson(json["status"]),
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    pivot: FacilityPivot.fromJson(json["pivot"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "icon": icon,
    "status": status.toJson(),
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "pivot": pivot.toJson(),
  };
}

class FacilityPivot {
  String referenceType;
  var referenceId;
  var facilityId;
  String distance;

  FacilityPivot({
    required this.referenceType,
    required this.referenceId,
    required this.facilityId,
    required this.distance,
  });

  factory FacilityPivot.fromJson(Map<String, dynamic> json) => FacilityPivot(
    referenceType: json["reference_type"],
    referenceId: json["reference_id"],
    facilityId: json["facility_id"],
    distance: json["distance"],
  );

  Map<String, dynamic> toJson() => {
    "reference_type": referenceType,
    "reference_id": referenceId,
    "facility_id": facilityId,
    "distance": distance,
  };
}

class Feature {
  var id;
  String name;
  String icon;
  String status;
  FeaturePivot pivot;

  Feature({
    required this.id,
    required this.name,
    required this.icon,
    required this.status,
    required this.pivot,
  });

  factory Feature.fromJson(Map<String, dynamic> json) => Feature(
    id: json["id"],
    name: json["name"],
    icon: json["icon"],
    status: json["status"],
    pivot: FeaturePivot.fromJson(json["pivot"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "icon": icon,
    "status": status,
    "pivot": pivot.toJson(),
  };
}

class FeaturePivot {
  var propertyId;
  var featureId;

  FeaturePivot({
    required this.propertyId,
    required this.featureId,
  });

  factory FeaturePivot.fromJson(Map<String, dynamic> json) => FeaturePivot(
    propertyId: json["property_id"],
    featureId: json["feature_id"],
  );

  Map<String, dynamic> toJson() => {
    "property_id": propertyId,
    "feature_id": featureId,
  };
}