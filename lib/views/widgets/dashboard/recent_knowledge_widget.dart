import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../viewmodels/knowledge_viewmodel.dart';
import '../../../models/knowledge.dart';
import '../../../utils/constants.dart';

class RecentKnowledgeWidget extends StatelessWidget {
  const RecentKnowledgeWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final knowledgeViewModel = Provider.of<KnowledgeViewModel>(context);
    
    // 公開済みのナレッジを取得して日付順に並べ替え
    final knowledgeItems = knowledgeViewModel.knowledgeItems
        .where((item) => item.publishStatus == 'published')
        .toList()
      ..sort((a, b) {
        if (a.updatedAt == null) return 1;
        if (b.updatedAt == null) return -1;
        return b.updatedAt!.compareTo(a.updatedAt!);
      });
    
    // 最新の5件を表示
    final recentItems = knowledgeItems.take(5).toList();
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ヘッダー
            InkWell(
              onTap: () {
                Navigator.pushNamed(context, AppConstants.knowledgePath);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '最新ナレッジ',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  TextButton.icon(
                    icon: const Icon(Icons.arrow_forward),
                    label: const Text('すべて表示'),
                    onPressed: () {
                      Navigator.pushNamed(context, AppConstants.knowledgePath);
                    },
                  ),
                ],
              ),
            ),
            const Divider(),
            
            // 最近のナレッジリスト
            if (recentItems.isEmpty)
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(child: Text('ナレッジがありません')),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: recentItems.length,
                itemBuilder: (context, index) {
                  final knowledge = recentItems[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16.0),
                      title: Text(
                        knowledge.title,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(
                                _getCategoryIcon(knowledge.category ?? 'その他'),
                                size: 16,
                                color: Colors.grey,
                              ),
                              const SizedBox(width: 4),
                              Text(knowledge.category ?? '不明'),
                              const SizedBox(width: 16),
                              const Icon(
                                Icons.person,
                                size: 16,
                                color: Colors.grey,
                              ),
                              const SizedBox(width: 4),
                              Text(knowledge.author?.displayName ?? '不明'),
                              const SizedBox(width: 16),
                              const Icon(
                                Icons.calendar_today,
                                size: 16,
                                color: Colors.grey,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                knowledge.updatedAt != null 
                                    ? DateFormat('yyyy/MM/dd').format(knowledge.updatedAt!) 
                                    : '日付なし'
                              ),
                            ],
                          ),
                          if (knowledge.tags != null && knowledge.tags!.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 4,
                              children: knowledge.tags!.map((tag) => Chip(
                                label: Text(
                                  tag,
                                  style: const TextStyle(fontSize: 10),
                                ),
                                padding: EdgeInsets.zero,
                                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                backgroundColor: Colors.green.shade50,
                              )).toList(),
                            ),
                          ],
                        ],
                      ),
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          AppConstants.knowledgeDetailsPath.replaceAll(
                            ':id',
                            knowledge.knowledgeId.toString(),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
              
            const SizedBox(height: 16),
            
            // 新規ナレッジボタン
            Center(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.add),
                label: const Text('新しいナレッジを作成'),
                onPressed: () {
                  Navigator.pushNamed(context, AppConstants.knowledgeCreatePath);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  // カテゴリによってアイコンを変更
  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'メンテナンス':
        return Icons.build;
      case '演奏技法':
        return Icons.music_note;
      case '購入ガイド':
        return Icons.shopping_cart;
      case 'トラブルシューティング':
        return Icons.warning;
      default:
        return Icons.article;
    }
  }
} 