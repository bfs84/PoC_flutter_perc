import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../viewmodels/knowledge_viewmodel.dart';
import '../../../models/knowledge.dart';
import '../../widgets/common/app_drawer.dart';
import '../../widgets/common/list_builder.dart';
import '../../../utils/constants.dart';

class KnowledgeListScreen extends StatefulWidget {
  const KnowledgeListScreen({Key? key}) : super(key: key);

  @override
  _KnowledgeListScreenState createState() => _KnowledgeListScreenState();
}

class _KnowledgeListScreenState extends State<KnowledgeListScreen> {
  final _searchController = TextEditingController();
  String? _selectedCategory;
  List<String> _selectedTags = [];
  
  @override
  void initState() {
    super.initState();
    // 画面表示時にデータ取得
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<KnowledgeViewModel>(context, listen: false).fetchKnowledgeItems();
    });
  }
  
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
  
  // 検索実行
  void _handleSearch() {
    Provider.of<KnowledgeViewModel>(context, listen: false).searchKnowledge(
      keyword: _searchController.text.isNotEmpty ? _searchController.text : null,
      category: _selectedCategory,
      tags: _selectedTags.isNotEmpty ? _selectedTags : null,
    );
  }
  
  @override
  Widget build(BuildContext context) {
    final knowledgeViewModel = Provider.of<KnowledgeViewModel>(context);
    
    // 公開中のナレッジアイテムのみを表示
    final knowledgeItems = knowledgeViewModel.knowledgeItems
        .where((item) => item.publishStatus == 'published')
        .toList();
    
    // リストに表示するカラム定義
    final columns = [
      AssetManagementListColumn<Knowledge>(
        label: 'タイトル', 
        build: (item) => Text(
          item.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        flex: 2,
      ),
      AssetManagementListColumn<Knowledge>(
        label: 'カテゴリ', 
        build: (item) => Text(item.category ?? '-'),
        flex: 1,
      ),
      AssetManagementListColumn<Knowledge>(
        label: '作成者', 
        build: (item) => Text(item.author?.displayName ?? '-'),
        flex: 2,
      ),
      AssetManagementListColumn<Knowledge>(
        label: '更新日', 
        build: (item) => Text(DateFormat('yyyy/MM/dd').format(item.updatedAt ?? DateTime.now())),
        flex: 1,
      ),
      AssetManagementListColumn<Knowledge>(
        label: 'タグ', 
        build: (item) => item.tags != null && item.tags!.isNotEmpty
            ? Wrap(
                spacing: 4,
                children: item.tags!.map((tag) => Chip(
                  label: Text(
                    tag,
                    style: const TextStyle(fontSize: 10),
                  ),
                  padding: EdgeInsets.zero,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                )).toList(),
              )
            : const Text('-'),
        flex: 2,
      ),
    ];
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('ナレッジベース'),
      ),
      drawer: const AppDrawer(),
      body: Column(
        children: [
          // 検索エリア
          Card(
            margin: const EdgeInsets.all(16.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '検索条件',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const Divider(),
                  Row(
                    children: [
                      // キーワード検索
                      Expanded(
                        flex: 2,
                        child: TextField(
                          controller: _searchController,
                          decoration: const InputDecoration(
                            labelText: 'キーワード',
                            hintText: 'タイトルや本文で検索',
                            prefixIcon: Icon(Icons.search),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      
                      // カテゴリ選択
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _selectedCategory,
                          decoration: const InputDecoration(
                            labelText: 'カテゴリ',
                          ),
                          items: [
                            const DropdownMenuItem(
                              value: null,
                              child: Text('すべて'),
                            ),
                            ...['メンテナンス', '演奏技法', '購入ガイド', 'トラブルシューティング', 'その他']
                                .map((c) => DropdownMenuItem(
                                      value: c,
                                      child: Text(c),
                                    ))
                                .toList(),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _selectedCategory = value;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      
                      // 検索ボタン
                      ElevatedButton(
                        onPressed: _handleSearch,
                        child: const Text('検索'),
                      ),
                    ],
                  ),
                  
                  // タグ選択（チップ）
                  const SizedBox(height: 16),
                  Text(
                    'タグで絞り込み:',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: [
                      'ティンパニ', 'マリンバ', 'ビブラフォン', 'シロフォン', 'ドラム', 'シンバル', 
                      'メンテナンス', '初心者向け', '上級者向け', 'チューニング'
                    ].map((tag) => FilterChip(
                      label: Text(tag),
                      selected: _selectedTags.contains(tag),
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            _selectedTags.add(tag);
                          } else {
                            _selectedTags.remove(tag);
                          }
                        });
                        _handleSearch(); // タグ選択時に即時検索
                      },
                    )).toList(),
                  ),
                ],
              ),
            ),
          ),
          
          // 一覧表示
          Expanded(
            child: AssetManagementListBuilder<Knowledge>(
              title: 'ナレッジ一覧',
              items: knowledgeItems,
              columns: columns,
              isLoading: knowledgeViewModel.isLoading,
              errorMessage: knowledgeViewModel.error,
              onItemTap: (item) {
                Navigator.pushNamed(
                  context,
                  AppConstants.knowledgeDetailsPath.replaceAll(':id', item.knowledgeId.toString()),
                );
              },
              onItemEdit: (item) {
                Navigator.pushNamed(
                  context,
                  AppConstants.knowledgeEditPath.replaceAll(':id', item.knowledgeId.toString()),
                );
              },
              onItemDelete: (item) {
                // 削除確認
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('削除確認'),
                    content: Text('ナレッジ記事 "${item.title}" を削除してもよろしいですか？'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('キャンセル'),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          Navigator.pop(context);
                          final success = await knowledgeViewModel.deleteKnowledge(item.knowledgeId);
                          if (success && mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('ナレッジを削除しました')),
                            );
                          } else if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(knowledgeViewModel.error ?? '削除に失敗しました'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: const Text('削除'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      // ナレッジ追加ボタン
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, AppConstants.knowledgeCreatePath);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
} 