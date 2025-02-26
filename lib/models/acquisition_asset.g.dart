// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'acquisition_asset.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AcquisitionAsset _$AcquisitionAssetFromJson(Map<String, dynamic> json) =>
    AcquisitionAsset(
      acquisitionId: (json['acquisitionId'] as num).toInt(),
      assetCode: json['assetCode'] as String,
      category: json['category'] as String,
      model: json['model'] as String,
      price: (json['price'] as num).toDouble(),
      currency: json['currency'] as String,
      purchaseReason: json['purchaseReason'] as String?,
      status: json['status'] as String,
      requestedById: (json['requestedById'] as num?)?.toInt(),
      requestedBy: json['requestedBy'] == null
          ? null
          : User.fromJson(json['requestedBy'] as Map<String, dynamic>),
      requestedDate: json['requestedDate'] == null
          ? null
          : DateTime.parse(json['requestedDate'] as String),
      description: json['description'] as String?,
      fiscalYear: (json['fiscalYear'] as num?)?.toInt(),
      attachment: json['attachment'] as String?,
      id: (json['id'] as num?)?.toInt(),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$AcquisitionAssetToJson(AcquisitionAsset instance) =>
    <String, dynamic>{
      'id': instance.id,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'acquisitionId': instance.acquisitionId,
      'assetCode': instance.assetCode,
      'category': instance.category,
      'model': instance.model,
      'price': instance.price,
      'currency': instance.currency,
      'purchaseReason': instance.purchaseReason,
      'status': instance.status,
      'requestedById': instance.requestedById,
      'requestedBy': instance.requestedBy,
      'requestedDate': instance.requestedDate?.toIso8601String(),
      'description': instance.description,
      'fiscalYear': instance.fiscalYear,
      'attachment': instance.attachment,
    };
