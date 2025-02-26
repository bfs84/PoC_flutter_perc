import 'package:json_annotation/json_annotation.dart';
import 'base_model.dart';

part 'user.g.dart';

@JsonSerializable()
class User extends BaseModel {
  final int userId;
  final String username;
  final String email;
  final String displayName;
  final String? phoneNumber;
  final String? department;
  final String role; // admin, manager, user など
  final bool isActive;
  final String? profileImage;
  
  User({
    required this.userId,
    required this.username,
    required this.email,
    required this.displayName,
    this.phoneNumber,
    this.department,
    required this.role,
    required this.isActive,
    this.profileImage,
    int? id,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super(id: id, createdAt: createdAt, updatedAt: updatedAt);
  
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  
  @override
  Map<String, dynamic> toJson() => _$UserToJson(this);
  
  @override
  String getDisplayValue() => displayName;
} 