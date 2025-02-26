import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:intl/intl.dart';
import '../../../viewmodels/knowledge_viewmodel.dart';
import '../../../models/knowledge.dart';
import '../../../utils/constants.dart';

class KnowledgeDetailsScreen extends StatefulWidget {
  final int knowledgeId;
  
  const KnowledgeDetailsScreen({Key? key, required this.knowledgeId}) : super(key: key);

  @override
  _KnowledgeDetailsScreenState createState() => _KnowledgeDetailsScreenState();
}

class _KnowledgeDetailsScreenState extends State<KnowledgeDetailsScreen> {
  @override
  void initState() {
    super.initState();
    // 詳細画面表示時に指定されたIDのナレッジデータを取得
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadKnowledgeDetails();
    });
  }
  
  // ナレッジ詳細データ取得
  Future<void> _loadKnowledgeDetails() async {
    final viewModel = Provider.of<KnowledgeViewModel>(context, listen: false);
    
    // 現在の一覧データから該当ナレッジを検索
    final items = viewModel.knowledgeItems;
    final item = items.where((k) => k.knowledgeId == widget.knowledgeId).toList();
    
    // 該当ナレッジがなければ取得
    if (item.isEmpty) {
      // TODO: 詳細取得APIがある場合は実装
      await viewModel.fetchKnowledgeItems(); // 全件取得でリフレッシュ (暫定)
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<KnowledgeViewModel>(context);
    
    // 該当ナレッジを検索
    final knowledge = viewModel.knowledgeItems
        .where((k) => k.knowledgeId == widget.knowledgeId)
        .toList()
        .firstOrNull;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('ナレッジ詳細'),
        actions: [
          // 編集ボタン
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.pushNamed(
                context,
                AppConstants.knowledgeEditPath.replaceAll(':id', widget.knowledgeId.toString()),
              );
            },
          ),
        ],
      ),
      body: viewModel.isLoading
          ? const Center(child: CircularProgressIndicator())
          : knowledge == null
              ? const Center(child: Text('ナレッジが見つかりません'))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // タイトルカード
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                knowledge.title,
                                style: Theme.of(context).textTheme.headlineSmall,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '${knowledge.author?.displayName ?? '不明'} - ' +
                                (knowledge.updatedAt != null 
                                    ? DateFormat('yyyy年MM月dd日').format(knowledge.updatedAt!) 
                                    : '日付なし'),
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Chip(
                                    label: Text(knowledge.category ?? 'カテゴリなし'),
                                    backgroundColor: Colors.blue.shade100,
                                  ),
                                  const SizedBox(width: 8),
                                  if (knowledge.publishStatus == 'draft')
                                    Chip(
                                      label: const Text('下書き'),
                                      backgroundColor: Colors.grey.shade300,
                                    ),
                                ],
                              ),
                              if (knowledge.tags != null && knowledge.tags!.isNotEmpty) ...[
                                const SizedBox(height: 8),
                                Wrap(
                                  spacing: 8,
                                  children: knowledge.tags!.map((tag) => Chip(
                                    label: Text(tag),
                                    backgroundColor: Colors.green.shade100,
                                  )).toList(),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // 本文
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              MarkdownBody(
                                data: knowledge.content,
                                selectable: true,
                              ),
                            ],
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // 添付ファイル（存在する場合）
                      if (knowledge.attachments != null && knowledge.attachments!.isNotEmpty)
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '添付ファイル',
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                                const Divider(),
                                ...knowledge.attachments!.map((attachment) => ListTile(
                                  leading: const Icon(Icons.attach_file),
                                  title: Text(attachment.filename),
                                  trailing: const Icon(Icons.download),
                                  onTap: () {
                                    // TODO: 添付ファイルのダウンロード処理
                                  },
                                )).toList(),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
    );
  }
}

// Dart 2.xでのnullableリスト拡張（firstOrNull）
extension ListExtension<T> on List<T> {
  T? get firstOrNull => isEmpty ? null : first;
} 