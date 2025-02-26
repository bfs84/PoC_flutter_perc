import 'package:json_annotation/json_annotation.dart';
import 'base_model.dart';
import 'user.dart';

part 'acquisition_asset.g.dart';

@JsonSerializable()
class AcquisitionAsset extends BaseModel {
  final int acquisitionId;
  final String assetCode;
  final String category;
  final String model;
  final double price;
  final String currency;
  final String? purchaseReason;
  final String status; // pending, delivering, arrived
  final int? requestedById;
  final User? requestedBy;
  final DateTime? requestedDate;
  final String? description;
  final int? fiscalYear;
  final String? attachment;
  
  AcquisitionAsset({
    required this.acquisitionId,
    required this.assetCode,
    required this.category,
    required this.model,
    required this.price,
    required this.currency,
    this.purchaseReason,
    required this.status,
    this.requestedById,
    this.requestedBy,
    this.requestedDate,
    this.description,
    this.fiscalYear,
    this.attachment,
    int? id,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super(id: id, createdAt: createdAt, updatedAt: updatedAt);
  
  factory AcquisitionAsset.fromJson(Map<String, dynamic> json) => 
      _$AcquisitionAssetFromJson(json);
  
  @override
  Map<String, dynamic> toJson() => _$AcquisitionAssetToJson(this);
  
  @override
  String getDisplayValue() => '$assetCode - $model';
  
  // ステータスの表示用テキスト
  String get statusText {
    switch (status) {
      case 'pending': return '申請中';
      case 'delivering': return '配送中';
      case 'arrived': return '到着済';
      default: return status;
    }
  }
} 