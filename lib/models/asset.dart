import 'package:json_annotation/json_annotation.dart';
import 'base_model.dart';
import 'user.dart';

part 'asset.g.dart';

@JsonSerializable()
class Asset extends BaseModel {
  final int assetId;
  final String assetCode;
  final String category;
  final String model;
  final double price;
  final int? ownerId;
  final User? owner;
  final String? shortDescription;
  final String? description;
  final DateTime purchaseDate;
  final int degradation;  // 1:重大〜5:なし
  final String? storageLocation;
  final String status;
  final DateTime? lastMaintenanceDate;
  final String? attachment;
  final String? relatedUrl;
  final String? worknotes;
  
  Asset({
    required this.assetId,
    required this.assetCode,
    required this.category,
    required this.model,
    required this.price,
    this.ownerId,
    this.owner,
    this.shortDescription,
    this.description,
    required this.purchaseDate,
    required this.degradation,
    this.storageLocation,
    required this.status,
    this.lastMaintenanceDate,
    this.attachment,
    this.relatedUrl,
    this.worknotes,
    int? id,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super(id: id, createdAt: createdAt, updatedAt: updatedAt);
  
  factory Asset.fromJson(Map<String, dynamic> json) => _$AssetFromJson(json);
  
  @override
  Map<String, dynamic> toJson() => _$AssetToJson(this);
  
  @override
  String getDisplayValue() => '$assetCode - $model';
  
  // 損耗度をテキスト表現で取得
  String get degradationText {
    switch (degradation) {
      case 1: return '重大';
      case 2: return '高';
      case 3: return '中';
      case 4: return '小';
      case 5: return 'なし';
      default: return '不明';
    }
  }
} 