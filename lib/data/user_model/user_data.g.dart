// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserDataAdapter extends TypeAdapter<UserData> {
  @override
  final int typeId = 1;

  @override
  UserData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserData(
      wallet: fields[1] as Wallet?,
      id: fields[3] as String?,
      name: fields[5] as String?,
      email: fields[7] as String?,
      profilePicture: fields[9] as String?,
      firebaseUid: fields[11] as String?,
      phoneNumber: fields[13] as String?,
      kycVerified: fields[15] as bool?,
      kycDocuments: (fields[17] as List?)?.cast<KycDocument>(),
      bankDetails: (fields[19] as List?)?.cast<BankDetail>(),
      referredUsers: (fields[21] as List?)?.cast<String>(),
      role: fields[23] as String?,
      isActive: fields[25] as bool?,
      savedPlans: (fields[27] as List?)?.cast<SavedPlan>(),
      createdAt: fields[29] as DateTime?,
      updatedAt: fields[31] as DateTime?,
      referralCode: fields[33] as String?,
      referredByCode: fields[35] as String?,
      isAgree: fields[37] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, UserData obj) {
    writer
      ..writeByte(19)
      ..writeByte(1)
      ..write(obj.wallet)
      ..writeByte(3)
      ..write(obj.id)
      ..writeByte(5)
      ..write(obj.name)
      ..writeByte(7)
      ..write(obj.email)
      ..writeByte(9)
      ..write(obj.profilePicture)
      ..writeByte(11)
      ..write(obj.firebaseUid)
      ..writeByte(13)
      ..write(obj.phoneNumber)
      ..writeByte(15)
      ..write(obj.kycVerified)
      ..writeByte(17)
      ..write(obj.kycDocuments)
      ..writeByte(19)
      ..write(obj.bankDetails)
      ..writeByte(21)
      ..write(obj.referredUsers)
      ..writeByte(23)
      ..write(obj.role)
      ..writeByte(25)
      ..write(obj.isActive)
      ..writeByte(27)
      ..write(obj.savedPlans)
      ..writeByte(29)
      ..write(obj.createdAt)
      ..writeByte(31)
      ..write(obj.updatedAt)
      ..writeByte(33)
      ..write(obj.referralCode)
      ..writeByte(35)
      ..write(obj.referredByCode)
      ..writeByte(37)
      ..write(obj.isAgree);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class BankDetailAdapter extends TypeAdapter<BankDetail> {
  @override
  final int typeId = 2;

  @override
  BankDetail read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BankDetail(
      accountNumber: fields[1] as String?,
      ifscCode: fields[3] as String?,
      accountHolderName: fields[5] as String?,
      bankName: fields[7] as String?,
      branchName: fields[9] as String?,
      upiId: fields[11] as String?,
      isDefault: fields[13] as bool?,
      isVerified: fields[15] as bool?,
      createdAt: fields[17] as DateTime?,
      updatedAt: fields[19] as DateTime?,
      id: fields[21] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, BankDetail obj) {
    writer
      ..writeByte(11)
      ..writeByte(1)
      ..write(obj.accountNumber)
      ..writeByte(3)
      ..write(obj.ifscCode)
      ..writeByte(5)
      ..write(obj.accountHolderName)
      ..writeByte(7)
      ..write(obj.bankName)
      ..writeByte(9)
      ..write(obj.branchName)
      ..writeByte(11)
      ..write(obj.upiId)
      ..writeByte(13)
      ..write(obj.isDefault)
      ..writeByte(15)
      ..write(obj.isVerified)
      ..writeByte(17)
      ..write(obj.createdAt)
      ..writeByte(19)
      ..write(obj.updatedAt)
      ..writeByte(21)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BankDetailAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class KycDocumentAdapter extends TypeAdapter<KycDocument> {
  @override
  final int typeId = 3;

  @override
  KycDocument read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return KycDocument(
      docType: fields[1] as String?,
      docUrl: fields[3] as String?,
      status: fields[5] as String?,
      verifiedAt: fields[7] as DateTime?,
      createdAt: fields[9] as DateTime?,
      updatedAt: fields[11] as DateTime?,
      id: fields[13] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, KycDocument obj) {
    writer
      ..writeByte(7)
      ..writeByte(1)
      ..write(obj.docType)
      ..writeByte(3)
      ..write(obj.docUrl)
      ..writeByte(5)
      ..write(obj.status)
      ..writeByte(7)
      ..write(obj.verifiedAt)
      ..writeByte(9)
      ..write(obj.createdAt)
      ..writeByte(11)
      ..write(obj.updatedAt)
      ..writeByte(13)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is KycDocumentAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SavedPlanAdapter extends TypeAdapter<SavedPlan> {
  @override
  final int typeId = 4;

  @override
  SavedPlan read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SavedPlan(
      product: fields[1] as String?,
      targetAmount: fields[3] as int?,
      savedAmount: fields[5] as int?,
      dailySavingAmount: fields[7] as int?,
      startDate: fields[9] as DateTime?,
      endDate: fields[11] as DateTime?,
      status: fields[13] as String?,
      id: fields[15] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, SavedPlan obj) {
    writer
      ..writeByte(8)
      ..writeByte(1)
      ..write(obj.product)
      ..writeByte(3)
      ..write(obj.targetAmount)
      ..writeByte(5)
      ..write(obj.savedAmount)
      ..writeByte(7)
      ..write(obj.dailySavingAmount)
      ..writeByte(9)
      ..write(obj.startDate)
      ..writeByte(11)
      ..write(obj.endDate)
      ..writeByte(13)
      ..write(obj.status)
      ..writeByte(15)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SavedPlanAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class WalletAdapter extends TypeAdapter<Wallet> {
  @override
  final int typeId = 5;

  @override
  Wallet read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Wallet(
      balance: fields[1] as int?,
      transactions: (fields[3] as List?)?.cast<dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, Wallet obj) {
    writer
      ..writeByte(2)
      ..writeByte(1)
      ..write(obj.balance)
      ..writeByte(3)
      ..write(obj.transactions);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WalletAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserData _$UserDataFromJson(Map<String, dynamic> json) => UserData(
      wallet: json['wallet'] == null
          ? null
          : Wallet.fromJson(json['wallet'] as Map<String, dynamic>),
      id: json['_id'] as String?,
      name: json['name'] as String?,
      email: json['email'] as String?,
      profilePicture: json['profilePicture'] as String?,
      firebaseUid: json['firebaseUid'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      kycVerified: json['kycVerified'] as bool?,
      kycDocuments: (json['kycDocuments'] as List<dynamic>?)
          ?.map((e) => KycDocument.fromJson(e as Map<String, dynamic>))
          .toList(),
      bankDetails: (json['bankDetails'] as List<dynamic>?)
          ?.map((e) => BankDetail.fromJson(e as Map<String, dynamic>))
          .toList(),
      referredUsers: (json['referredUsers'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      role: json['role'] as String?,
      isActive: json['isActive'] as bool?,
      savedPlans: (json['savedPlans'] as List<dynamic>?)
          ?.map((e) => SavedPlan.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      referralCode: json['referralCode'] as String?,
      referredByCode: json['referredByCode'] as String?,
      isAgree: json['isAgree'] as bool?,
    );

Map<String, dynamic> _$UserDataToJson(UserData instance) => <String, dynamic>{
      'wallet': instance.wallet,
      '_id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'profilePicture': instance.profilePicture,
      'firebaseUid': instance.firebaseUid,
      'phoneNumber': instance.phoneNumber,
      'kycVerified': instance.kycVerified,
      'kycDocuments': instance.kycDocuments,
      'bankDetails': instance.bankDetails,
      'referredUsers': instance.referredUsers,
      'role': instance.role,
      'isActive': instance.isActive,
      'savedPlans': instance.savedPlans,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'referralCode': instance.referralCode,
      'referredByCode': instance.referredByCode,
      'isAgree': instance.isAgree,
    };

BankDetail _$BankDetailFromJson(Map<String, dynamic> json) => BankDetail(
      accountNumber: json['accountNumber'] as String?,
      ifscCode: json['ifscCode'] as String?,
      accountHolderName: json['accountHolderName'] as String?,
      bankName: json['bankName'] as String?,
      branchName: json['branchName'] as String?,
      upiId: json['upiId'] as String?,
      isDefault: json['isDefault'] as bool?,
      isVerified: json['isVerified'] as bool?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      id: json['_id'] as String?,
    );

Map<String, dynamic> _$BankDetailToJson(BankDetail instance) =>
    <String, dynamic>{
      'accountNumber': instance.accountNumber,
      'ifscCode': instance.ifscCode,
      'accountHolderName': instance.accountHolderName,
      'bankName': instance.bankName,
      'branchName': instance.branchName,
      'upiId': instance.upiId,
      'isDefault': instance.isDefault,
      'isVerified': instance.isVerified,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      '_id': instance.id,
    };

KycDocument _$KycDocumentFromJson(Map<String, dynamic> json) => KycDocument(
      docType: json['docType'] as String?,
      docUrl: json['docUrl'] as String?,
      status: json['status'] as String?,
      verifiedAt: json['verifiedAt'] == null
          ? null
          : DateTime.parse(json['verifiedAt'] as String),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      id: json['_id'] as String?,
    );

Map<String, dynamic> _$KycDocumentToJson(KycDocument instance) =>
    <String, dynamic>{
      'docType': instance.docType,
      'docUrl': instance.docUrl,
      'status': instance.status,
      'verifiedAt': instance.verifiedAt?.toIso8601String(),
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      '_id': instance.id,
    };

SavedPlan _$SavedPlanFromJson(Map<String, dynamic> json) => SavedPlan(
      product: json['product'] as String?,
      targetAmount: (json['targetAmount'] as num?)?.toInt(),
      savedAmount: (json['savedAmount'] as num?)?.toInt(),
      dailySavingAmount: (json['dailySavingAmount'] as num?)?.toInt(),
      startDate: json['startDate'] == null
          ? null
          : DateTime.parse(json['startDate'] as String),
      endDate: json['endDate'] == null
          ? null
          : DateTime.parse(json['endDate'] as String),
      status: json['status'] as String?,
      id: json['_id'] as String?,
    );

Map<String, dynamic> _$SavedPlanToJson(SavedPlan instance) => <String, dynamic>{
      'product': instance.product,
      'targetAmount': instance.targetAmount,
      'savedAmount': instance.savedAmount,
      'dailySavingAmount': instance.dailySavingAmount,
      'startDate': instance.startDate?.toIso8601String(),
      'endDate': instance.endDate?.toIso8601String(),
      'status': instance.status,
      '_id': instance.id,
    };

Wallet _$WalletFromJson(Map<String, dynamic> json) => Wallet(
      balance: (json['balance'] as num?)?.toInt(),
      transactions: json['transactions'] as List<dynamic>?,
    );

Map<String, dynamic> _$WalletToJson(Wallet instance) => <String, dynamic>{
      'balance': instance.balance,
      'transactions': instance.transactions,
    };
