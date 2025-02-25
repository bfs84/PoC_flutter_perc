class Knowledge {
  final int knowledgeId;
  final String title;
  final String content;
  final String category;
  final int author; // UserID
  final int version;
  final bool isPublished;
  final DateTime createdAt;
  final DateTime updatedAt;

  Knowledge({
    required this.knowledgeId,
    required this.title,
    required this.content,
    required this.category,
    required this.author,
    required this.version,
    required this.isPublished,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Knowledge.fromJson(Map<String, dynamic> json) {
    return Knowledge(
      knowledgeId: json['knowledge_id'],
      title: json['title'],
      content: json['content'],
      category: json['category'],
      author: json['author'],
      version: json['version'],
      isPublished: json['is_published'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() => {
        'knowledge_id': knowledgeId,
        'title': title,
        'content': content,
        'category': category,
        'author': author,
        'version': version,
        'is_published': isPublished,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
      };
} 