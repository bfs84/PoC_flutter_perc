// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'knowledge.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Knowledge _$KnowledgeFromJson(Map<String, dynamic> json) => Knowledge(
      knowledgeId: (json['knowledgeId'] as num).toInt(),
      title: json['title'] as String,
      content: json['content'] as String,
      category: json['category'] as String?,
      publishStatus: json['publishStatus'] as String,
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
      author: json['author'] == null
          ? null
          : User.fromJson(json['author'] as Map<String, dynamic>),
      authorId: (json['authorId'] as num?)?.toInt(),
      views: (json['views'] as num?)?.toInt(),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      attachments: (json['attachments'] as List<dynamic>?)
          ?.map((e) => KnowledgeAttachment.fromJson(e as Map<String, dynamic>))
          .toList(),
      id: json['id'] == null ? null : int.parse(json['id'].toString()),
    );

Map<String, dynamic> _$KnowledgeToJson(Knowledge instance) => <String, dynamic>{
      'id': instance.id,
      'knowledgeId': instance.knowledgeId,
      'title': instance.title,
      'content': instance.content,
      'category': instance.category,
      'publishStatus': instance.publishStatus,
      'tags': instance.tags,
      'author': instance.author,
      'authorId': instance.authorId,
      'views': instance.views,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'attachments': instance.attachments,
    };

KnowledgeAttachment _$KnowledgeAttachmentFromJson(Map<String, dynamic> json) =>
    KnowledgeAttachment(
      id: (json['id'] as num).toInt(),
      filename: json['filename'] as String,
      url: json['url'] as String,
      size: (json['size'] as num?)?.toInt(),
      contentType: json['contentType'] as String?,
    );

Map<String, dynamic> _$KnowledgeAttachmentToJson(
        KnowledgeAttachment instance) =>
    <String, dynamic>{
      'id': instance.id,
      'filename': instance.filename,
      'url': instance.url,
      'size': instance.size,
      'contentType': instance.contentType,
    };
