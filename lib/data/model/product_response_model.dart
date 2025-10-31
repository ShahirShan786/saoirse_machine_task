// To parse this JSON data, do
//
//     final productResponseModel = productResponseModelFromJson(jsonString);

import 'dart:convert';

ProductResponseModel productResponseModelFromJson(String str) =>
    ProductResponseModel.fromJson(json.decode(str));

String productResponseModelToJson(ProductResponseModel data) =>
    json.encode(data.toJson());

class ProductResponseModel {
  int? total;
  int? page;
  int? limit;
  int? totalPages;
  List<Product>? products;

  ProductResponseModel({
    this.total,
    this.page,
    this.limit,
    this.totalPages,
    this.products,
  });

  factory ProductResponseModel.fromJson(Map<String, dynamic> json) =>
      ProductResponseModel(
        total: json["total"],
        page: json["page"],
        limit: json["limit"],
        totalPages: json["totalPages"],
        products: json["products"] == null
            ? []
            : List<Product>.from(
                json["products"]!.map((x) => Product.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "total": total,
        "page": page,
        "limit": limit,
        "totalPages": totalPages,
        "products": products == null
            ? []
            : List<dynamic>.from(products!.map((x) => x.toJson())),
      };
}

class Product {
  String? id;
  String? name;
  String? description;
  int? price;
  int? originalPrice;
  String? brand;
  String? model;
  List<String>? features;
  Specifications? specifications;
  num? rating;
  int? reviewCount;
  int? likePercentage;
  List<String>? images;
  String? category;
  bool? isCombo;
  bool? isSpecialPrice;
  List<dynamic>? comboProducts;
  int? stock;
  int? minimumSavingDays;
  List<InstallmentOption>? installmentOptions;
  bool? isActive;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? suggestedDailySavingAmount;
  int? v;
  bool? isWishlisted;

  Product({
    this.id,
    this.name,
    this.description,
    this.price,
    this.originalPrice,
    this.brand,
    this.model,
    this.features,
    this.specifications,
    this.rating,
    this.reviewCount,
    this.likePercentage,
    this.images,
    this.category,
    this.isCombo,
    this.isSpecialPrice,
    this.comboProducts,
    this.stock,
    this.minimumSavingDays,
    this.installmentOptions,
    this.isActive,
    this.createdAt,
    this.updatedAt,
    this.suggestedDailySavingAmount,
    this.v,
    this.isWishlisted,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["_id"],
        name: json["name"],
        description: json["description"],
        price: json["price"],
        originalPrice: json["originalPrice"],
        brand: json["brand"],
        model: json["model"],
        features: json["features"] == null
            ? []
            : List<String>.from(json["features"]!.map((x) => x)),
        specifications: json["specifications"] == null
            ? null
            : Specifications.fromJson(json["specifications"]),
        rating: json["rating"],
        reviewCount: json["reviewCount"],
        likePercentage: json["likePercentage"],
        images: json["images"] == null
            ? []
            : List<String>.from(json["images"]!.map((x) => x)),
        category: json["category"],
        isCombo: json["isCombo"],
        isSpecialPrice: json["isSpecialPrice"],
        comboProducts: json["comboProducts"] == null
            ? []
            : List<dynamic>.from(json["comboProducts"]!.map((x) => x)),
        stock: json["stock"],
        minimumSavingDays: json["minimumSavingDays"],
        installmentOptions: json["installmentOptions"] == null
            ? []
            : List<InstallmentOption>.from(json["installmentOptions"]!
                .map((x) => InstallmentOption.fromJson(x))),
        isActive: json["isActive"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        suggestedDailySavingAmount: json["suggestedDailySavingAmount"],
        v: json["__v"],
        isWishlisted: json["isWishlisted"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "description": description,
        "price": price,
        "originalPrice": originalPrice,
        "brand": brand,
        "model": model,
        "features":
            features == null ? [] : List<dynamic>.from(features!.map((x) => x)),
        "specifications": specifications?.toJson(),
        "rating": rating,
        "reviewCount": reviewCount,
        "likePercentage": likePercentage,
        "images":
            images == null ? [] : List<dynamic>.from(images!.map((x) => x)),
        "category": category,
        "isCombo": isCombo,
        "isSpecialPrice": isSpecialPrice,
        "comboProducts": comboProducts == null
            ? []
            : List<dynamic>.from(comboProducts!.map((x) => x)),
        "stock": stock,
        "minimumSavingDays": minimumSavingDays,
        "installmentOptions": installmentOptions == null
            ? []
            : List<dynamic>.from(installmentOptions!.map((x) => x.toJson())),
        "isActive": isActive,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "suggestedDailySavingAmount": suggestedDailySavingAmount,
        "__v": v,
        "isWishlisted": isWishlisted,
      };
}

class InstallmentOption {
  int? amount;
  String? period;
  String? periodUnit;
  int? totalAmount;
  int? lastPaymentAmount;
  DateTime? startDate;
  DateTime? endDate;
  bool? isRecommended;
  String? id;

  InstallmentOption({
    this.amount,
    this.period,
    this.periodUnit,
    this.totalAmount,
    this.lastPaymentAmount,
    this.startDate,
    this.endDate,
    this.isRecommended,
    this.id,
  });

  factory InstallmentOption.fromJson(Map<String, dynamic> json) =>
      InstallmentOption(
        amount: json["amount"],
        period: json["period"],
        periodUnit: json["periodUnit"],
        totalAmount: json["totalAmount"],
        lastPaymentAmount: json["lastPaymentAmount"],
        startDate: json["startDate"] == null
            ? null
            : DateTime.parse(json["startDate"]),
        endDate:
            json["endDate"] == null ? null : DateTime.parse(json["endDate"]),
        isRecommended: json["isRecommended"],
        id: json["_id"],
      );

  Map<String, dynamic> toJson() => {
        "amount": amount,
        "period": period,
        "periodUnit": periodUnit,
        "totalAmount": totalAmount,
        "lastPaymentAmount": lastPaymentAmount,
        "startDate": startDate?.toIso8601String(),
        "endDate": endDate?.toIso8601String(),
        "isRecommended": isRecommended,
        "_id": id,
      };
}

class Specifications {
  Specifications();

  factory Specifications.fromJson(Map<String, dynamic> json) =>
      Specifications();

  Map<String, dynamic> toJson() => {};
}
