// To parse this JSON data, do
//
//     final userData = userDataFromJson(jsonString);

import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_data.g.dart';

UserData userDataFromJson(String str) => UserData.fromJson(json.decode(str));

String userDataToJson(UserData data) => json.encode(data.toJson());

@HiveType(typeId: 1)
@JsonSerializable()
class UserData {
  @HiveField(1)
  @JsonKey(name: "wallet")
  Wallet? wallet;
  @HiveField(3)
  @JsonKey(name: "_id")
  String? id;
  @HiveField(5)
  @JsonKey(name: "name")
  String? name;
  @HiveField(7)
  @JsonKey(name: "email")
  String? email;
  @HiveField(9)
  @JsonKey(name: "profilePicture")
  String? profilePicture;
  @HiveField(11)
  @JsonKey(name: "firebaseUid")
  String? firebaseUid;
  @HiveField(13)
  @JsonKey(name: "phoneNumber")
  String? phoneNumber;
  @HiveField(15)
  @JsonKey(name: "kycVerified")
  bool? kycVerified;
  @HiveField(17)
  @JsonKey(name: "kycDocuments")
  List<KycDocument>? kycDocuments;
  @HiveField(19)
  @JsonKey(name: "bankDetails")
  List<BankDetail>? bankDetails;
  @HiveField(21)
  @JsonKey(name: "referredUsers")
  List<String>? referredUsers;
  @HiveField(23)
  @JsonKey(name: "role")
  String? role;
  @HiveField(25)
  @JsonKey(name: "isActive")
  bool? isActive;
  @HiveField(27)
  @JsonKey(name: "savedPlans")
  List<SavedPlan>? savedPlans;
  @HiveField(29)
  @JsonKey(name: "createdAt")
  DateTime? createdAt;
  @HiveField(31)
  @JsonKey(name: "updatedAt")
  DateTime? updatedAt;
  @HiveField(33)
  @JsonKey(name: "referralCode")
  String? referralCode;
  @HiveField(35)
  @JsonKey(name: "referredByCode")
  String? referredByCode;
  @HiveField(37)
  @JsonKey(name: "isAgree")
  bool? isAgree;

  UserData({
    this.wallet,
    this.id,
    this.name,
    this.email,
    this.profilePicture,
    this.firebaseUid,
    this.phoneNumber,
    this.kycVerified,
    this.kycDocuments,
    this.bankDetails,
    this.referredUsers,
    this.role,
    this.isActive,
    this.savedPlans,
    this.createdAt,
    this.updatedAt,
    this.referralCode,
    this.referredByCode,
    this.isAgree,
    
  });

  factory UserData.fromJson(Map<String, dynamic> json) =>
      _$UserDataFromJson(json);

  Map<String, dynamic> toJson() => _$UserDataToJson(this);
}

@HiveType(typeId: 2)
@JsonSerializable()
class BankDetail {
  @HiveField(1)
  @JsonKey(name: "accountNumber")
  String? accountNumber;
  @HiveField(3)
  @JsonKey(name: "ifscCode")
  String? ifscCode;
  @HiveField(5)
  @JsonKey(name: "accountHolderName")
  String? accountHolderName;
  @HiveField(7)
  @JsonKey(name: "bankName")
  String? bankName;
  @HiveField(9)
  @JsonKey(name: "branchName")
  String? branchName;
  @HiveField(11)
  @JsonKey(name: "upiId")
  String? upiId;
  @HiveField(13)
  @JsonKey(name: "isDefault")
  bool? isDefault;
  @HiveField(15)
  @JsonKey(name: "isVerified")
  bool? isVerified;
  @HiveField(17)
  @JsonKey(name: "createdAt")
  DateTime? createdAt;
  @HiveField(19)
  @JsonKey(name: "updatedAt")
  DateTime? updatedAt;
  @HiveField(21)
  @JsonKey(name: "_id")
  String? id;
 

  BankDetail({
    this.accountNumber,
    this.ifscCode,
    this.accountHolderName,
    this.bankName,
    this.branchName,
    this.upiId,
    this.isDefault,
    this.isVerified,
    this.createdAt,
    this.updatedAt,
    this.id,
  });

  factory BankDetail.fromJson(Map<String, dynamic> json) =>
      _$BankDetailFromJson(json);

  Map<String, dynamic> toJson() => _$BankDetailToJson(this);
}

@HiveType(typeId: 3)
@JsonSerializable()
class KycDocument {
  @HiveField(1)
  @JsonKey(name: "docType")
  String? docType;
  @HiveField(3)
  @JsonKey(name: "docUrl")
  String? docUrl;
  @HiveField(5)
  @JsonKey(name: "status")
  String? status;
  @HiveField(7)
  @JsonKey(name: "verifiedAt")
  DateTime? verifiedAt;
  @HiveField(9)
  @JsonKey(name: "createdAt")
  DateTime? createdAt;
  @HiveField(11)
  @JsonKey(name: "updatedAt")
  DateTime? updatedAt;
  @HiveField(13)
  @JsonKey(name: "_id")
  String? id;

  KycDocument({
    this.docType,
    this.docUrl,
    this.status,
    this.verifiedAt,
    this.createdAt,
    this.updatedAt,
    this.id,
  });

  factory KycDocument.fromJson(Map<String, dynamic> json) =>
      _$KycDocumentFromJson(json);

  Map<String, dynamic> toJson() => _$KycDocumentToJson(this);
}

@HiveType(typeId: 4)
@JsonSerializable()
class SavedPlan {
  @HiveField(1)
  @JsonKey(name: "product")
  String? product;
  @HiveField(3)
  @JsonKey(name: "targetAmount")
  int? targetAmount;
  @HiveField(5)
  @JsonKey(name: "savedAmount")
  int? savedAmount;
  @HiveField(7)
  @JsonKey(name: "dailySavingAmount")
  int? dailySavingAmount;
  @HiveField(9)
  @JsonKey(name: "startDate")
  DateTime? startDate;
  @HiveField(11)
  @JsonKey(name: "endDate")
  DateTime? endDate;
  @HiveField(13)
  @JsonKey(name: "status")
  String? status;
  @HiveField(15)
  @JsonKey(name: "_id")
  String? id;

  SavedPlan({
    this.product,
    this.targetAmount,
    this.savedAmount,
    this.dailySavingAmount,
    this.startDate,
    this.endDate,
    this.status,
    this.id,
  });

  factory SavedPlan.fromJson(Map<String, dynamic> json) =>
      _$SavedPlanFromJson(json);

  Map<String, dynamic> toJson() => _$SavedPlanToJson(this);
}

@HiveType(typeId: 5)
@JsonSerializable()
class Wallet {
  @HiveField(1)
  @JsonKey(name: "balance")
  int? balance;
  @HiveField(3)
  @JsonKey(name: "transactions")
  List<dynamic>? transactions;

  Wallet({
    this.balance,
    this.transactions,
  });

  factory Wallet.fromJson(Map<String, dynamic> json) => _$WalletFromJson(json);

  Map<String, dynamic> toJson() => _$WalletToJson(this);
}

/*
// To parse this JSON data, do
//
//     final userData = userDataFromMap(jsonString);

import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_data.g.dart';

@HiveType(typeId: 1)
@JsonSerializable()
class UserData {
  @HiveField(1)
  @JsonKey(name: "wallet")
  List<Wallet>? wallet;
  @HiveField(3)
  @JsonKey(name: "kycDocuments")
  List<KycDocuments>? kycDocuments;
  @HiveField(5)
  @JsonKey(name: "bankDetails")
  List<BankDetails>? bankDetails;
  @HiveField(7)
  @JsonKey(name: "_id")
  String? id;
  @HiveField(9)
  @JsonKey(name: "name")
  String? name;
  @HiveField(11)
  @JsonKey(name: "email")
  String? email;
  @HiveField(13)
  @JsonKey(name: "profilePicture")
  String? profilePicture;
  @HiveField(15)
  @JsonKey(name: "firebaseUid")
  String? firebaseUid;
  @HiveField(17)
  @JsonKey(name: "phoneNumber")
  String? phoneNumber;
  @HiveField(19)
  @JsonKey(name: "kycVerified")
  bool? kycVerified;
  @HiveField(21)
  @JsonKey(name: "referredByCode")
  String? referredByCode;
  @HiveField(23)
  @JsonKey(name: "referredUsers")
  List<dynamic>? referredUsers;
  @HiveField(25)
  @JsonKey(name: "role")
  String? role;
  @HiveField(27)
  @JsonKey(name: "isActive")
  bool? isActive;
  @HiveField(29)
  @JsonKey(name: "savedPlans")
  List<dynamic>? savedPlans;
  @HiveField(31)
  @JsonKey(name: "createdAt")
  DateTime? createdAt;
  @HiveField(33)
  @JsonKey(name: "updatedAt")
  DateTime? updatedAt;
  @HiveField(35)
  @JsonKey(name: "referralCode")
  String? referralCode;
  @HiveField(37)
  @JsonKey(name: "__v")
  int? v;

  UserData({
    this.wallet,
    this.kycDocuments,
    this.bankDetails,
    this.id,
    this.name,
    this.email,
    this.profilePicture,
    this.firebaseUid,
    this.phoneNumber,
    this.kycVerified,
    this.referredByCode,
    this.referredUsers,
    this.role,
    this.isActive,
    this.savedPlans,
    this.createdAt,
    this.updatedAt,
    this.referralCode,
    this.v,
  });

  factory UserData.fromJson(Map<String, dynamic> json) =>
      _$UserDataFromJson(json);

  Map<String, dynamic> toJson() => _$UserDataToJson(this);
}

@HiveType(typeId: 2)
@JsonSerializable()
class BankDetails {
  @HiveField(1)
  @JsonKey(name: "accountNumber")
  String? accountNumber;
  @HiveField(3)
  @JsonKey(name: "ifscCode")
  String? ifscCode;
  @HiveField(5)
  @JsonKey(name: "accountHolderName")
  String? accountHolderName;
  @HiveField(7)
  @JsonKey(name: "upiId")
  String? upiId;

  BankDetails({
    required this.accountNumber,
    required this.ifscCode,
    required this.accountHolderName,
    required this.upiId,
  });

  factory BankDetails.fromJson(Map<String, dynamic> json) =>
      _$BankDetailsFromJson(json);

  Map<String, dynamic> toJson() => _$BankDetailsToJson(this);
}

@HiveType(typeId: 3)
@JsonSerializable()
class KycDocuments {
  @HiveField(1)
  @JsonKey(name: "idProof")
  String? idProof;
  @HiveField(3)
  @JsonKey(name: "addressProof")
  String? addressProof;
  @HiveField(5)
  @JsonKey(name: "status")
  String? status;

  KycDocuments({
    this.idProof,
    this.addressProof,
    this.status,
  });

  factory KycDocuments.fromJson(Map<String, dynamic> json) =>
      _$KycDocumentsFromJson(json);

  Map<String, dynamic> toJson() => _$KycDocumentsToJson(this);
}

@HiveType(typeId: 4)
@JsonSerializable()
class Wallet {
  @HiveField(1)
  @JsonKey(name: "balance")
  int? balance;
  @HiveField(3)
  @JsonKey(name: "transactions")
  List<dynamic>? transactions;

  Wallet({
    this.balance,
    this.transactions,
  });

  factory Wallet.fromJson(Map<String, dynamic> json) => _$WalletFromJson(json);

  Map<String, dynamic> toJson() => _$WalletToJson(this);
}
*/
