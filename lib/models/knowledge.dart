import 'package:json_annotation/json_annotation.dart';
import 'base_model.dart';
import 'user.dart';

part 'knowledge.g.dart';

@JsonSerializable()
class Knowledge extends BaseModel {
  final int knowledgeId;
  final String title;
  final String content;
  final String? category;
  final String publishStatus; // 'draft' または 'published'
  final List<String>? tags;
  final User? author;
  final int? authorId;
  final int? views;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<KnowledgeAttachment>? attachments;

  Knowledge({
    required this.knowledgeId,
    required this.title,
    required this.content,
    this.category,
    required this.publishStatus,
    this.tags,
    this.author,
    this.authorId,
    this.views,
    this.createdAt,
    this.updatedAt,
    this.attachments,
    int? id,
  }) : super(id: id);

  factory Knowledge.fromJson(Map<String, dynamic> json) => _$KnowledgeFromJson(json);
  
  @override
  Map<String, dynamic> toJson() => _$KnowledgeToJson(this);
  
  // copyWithメソッドの追加
  Knowledge copyWith({
    int? knowledgeId,
    String? title,
    String? content,
    String? category,
    String? publishStatus,
    List<String>? tags,
    User? author,
    int? authorId,
    int? views,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<KnowledgeAttachment>? attachments,
    int? id,
  }) {
    return Knowledge(
      knowledgeId: knowledgeId ?? this.knowledgeId,
      title: title ?? this.title,
      content: content ?? this.content,
      category: category ?? this.category,
      publishStatus: publishStatus ?? this.publishStatus,
      tags: tags ?? this.tags,
      author: author ?? this.author,
      authorId: authorId ?? this.authorId,
      views: views ?? this.views,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      attachments: attachments ?? this.attachments,
      id: id ?? this.id,
    );
  }

  @override
  String getDisplayValue() => title;
}

@JsonSerializable()
class KnowledgeAttachment {
  final int id;
  final String filename;
  final String url;
  final int? size;
  final String? contentType;
  
  KnowledgeAttachment({
    required this.id,
    required this.filename,
    required this.url,
    this.size,
    this.contentType,
  });
  
  factory KnowledgeAttachment.fromJson(Map<String, dynamic> json) => 
      _$KnowledgeAttachmentFromJson(json);
  
  Map<String, dynamic> toJson() => _$KnowledgeAttachmentToJson(this);
} 