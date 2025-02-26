// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'asset.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Asset _$AssetFromJson(Map<String, dynamic> json) => Asset(
      assetId: (json['assetId'] as num).toInt(),
      assetCode: json['assetCode'] as String,
      category: json['category'] as String,
      model: json['model'] as String,
      price: (json['price'] as num).toDouble(),
      ownerId: (json['ownerId'] as num?)?.toInt(),
      owner: json['owner'] == null
          ? null
          : User.fromJson(json['owner'] as Map<String, dynamic>),
      shortDescription: json['shortDescription'] as String?,
      description: json['description'] as String?,
      purchaseDate: DateTime.parse(json['purchaseDate'] as String),
      degradation: (json['degradation'] as num).toInt(),
      storageLocation: json['storageLocation'] as String?,
      status: json['status'] as String,
      lastMaintenanceDate: json['lastMaintenanceDate'] == null
          ? null
          : DateTime.parse(json['lastMaintenanceDate'] as String),
      attachment: json['attachment'] as String?,
      relatedUrl: json['relatedUrl'] as String?,
      worknotes: json['worknotes'] as String?,
      id: (json['id'] as num?)?.toInt(),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$AssetToJson(Asset instance) => <String, dynamic>{
      'id': instance.id,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'assetId': instance.assetId,
      'assetCode': instance.assetCode,
      'category': instance.category,
      'model': instance.model,
      'price': instance.price,
      'ownerId': instance.ownerId,
      'owner': instance.owner,
      'shortDescription': instance.shortDescription,
      'description': instance.description,
      'purchaseDate': instance.purchaseDate.toIso8601String(),
      'degradation': instance.degradation,
      'storageLocation': instance.storageLocation,
      'status': instance.status,
      'lastMaintenanceDate': instance.lastMaintenanceDate?.toIso8601String(),
      'attachment': instance.attachment,
      'relatedUrl': instance.relatedUrl,
      'worknotes': instance.worknotes,
    };
