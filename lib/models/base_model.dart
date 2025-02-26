import 'package:json_annotation/json_annotation.dart';

/// 全モデルの基底クラス
abstract class BaseModel {
  final int? id;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  
  BaseModel({this.id, this.createdAt, this.updatedAt});
  
  Map<String, dynamic> toJson();
  
  // ServiceNowライクなディスプレイ値を取得するメソッド
  String getDisplayValue();
} 