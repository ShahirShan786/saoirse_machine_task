// To parse this JSON data, do
//
//     final productByIdResponseModel = productByIdResponseModelFromJson(jsonString);

import 'dart:convert';

ProductByIdResponseModel productByIdResponseModelFromJson(String str) =>
    ProductByIdResponseModel.fromJson(json.decode(str));

String productByIdResponseModelToJson(ProductByIdResponseModel data) =>
    json.encode(data.toJson());

class ProductByIdResponseModel {
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

  ProductByIdResponseModel({
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

  factory ProductByIdResponseModel.fromJson(Map<String, dynamic> json) =>
      ProductByIdResponseModel(
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
  int? equivalentMonthlyAmount;
  EquivalentTime? equivalentTime;
  PaymentSchedule? paymentSchedule;
  bool? isSelected;

  InstallmentOption(
      {this.amount,
      this.period,
      this.periodUnit,
      this.totalAmount,
      this.lastPaymentAmount,
      this.startDate,
      this.endDate,
      this.isRecommended,
      this.id,
      this.equivalentMonthlyAmount,
      this.equivalentTime,
      this.paymentSchedule,
      this.isSelected});

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
        equivalentMonthlyAmount: json["equivalentMonthlyAmount"],
        equivalentTime: json["equivalentTime"] == null
            ? null
            : EquivalentTime.fromJson(json["equivalentTime"]),
        paymentSchedule: json["paymentSchedule"] == null
            ? null
            : PaymentSchedule.fromJson(json["paymentSchedule"]),
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
        "equivalentMonthlyAmount": equivalentMonthlyAmount,
        "equivalentTime": equivalentTime?.toJson(),
        "paymentSchedule": paymentSchedule?.toJson(),
      };
}

class EquivalentTime {
  int? days;

  EquivalentTime({
    this.days,
  });

  factory EquivalentTime.fromJson(Map<String, dynamic> json) => EquivalentTime(
        days: json["days"],
      );

  Map<String, dynamic> toJson() => {
        "days": days,
      };
}

class PaymentSchedule {
  RegularPayments? regularPayments;
  FinalPayment? finalPayment;
  String? summary;

  PaymentSchedule({
    this.regularPayments,
    this.finalPayment,
    this.summary,
  });

  factory PaymentSchedule.fromJson(Map<String, dynamic> json) =>
      PaymentSchedule(
        regularPayments: json["regularPayments"] == null
            ? null
            : RegularPayments.fromJson(json["regularPayments"]),
        finalPayment: json["finalPayment"] == null
            ? null
            : FinalPayment.fromJson(json["finalPayment"]),
        summary: json["summary"],
      );

  Map<String, dynamic> toJson() => {
        "regularPayments": regularPayments?.toJson(),
        "finalPayment": finalPayment?.toJson(),
        "summary": summary,
      };
}

class FinalPayment {
  int? amount;
  DateTime? date;

  FinalPayment({
    this.amount,
    this.date,
  });

  factory FinalPayment.fromJson(Map<String, dynamic> json) => FinalPayment(
        amount: json["amount"],
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
      );

  Map<String, dynamic> toJson() => {
        "amount": amount,
        "date": date?.toIso8601String(),
      };
}

class RegularPayments {
  int? amount;
  int? count;

  RegularPayments({
    this.amount,
    this.count,
  });

  factory RegularPayments.fromJson(Map<String, dynamic> json) =>
      RegularPayments(
        amount: json["amount"],
        count: json["count"],
      );

  Map<String, dynamic> toJson() => {
        "amount": amount,
        "count": count,
      };
}

class Specifications {
  Specifications();

  factory Specifications.fromJson(Map<String, dynamic> json) =>
      Specifications();

  Map<String, dynamic> toJson() => {};
}
