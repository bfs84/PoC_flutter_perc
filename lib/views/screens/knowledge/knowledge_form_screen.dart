import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../viewmodels/knowledge_viewmodel.dart';
import '../../../viewmodels/user_viewmodel.dart';
import '../../../models/knowledge.dart';
import '../../widgets/common/form_builder.dart';
import '../../../utils/constants.dart';

class KnowledgeFormScreen extends StatefulWidget {
  final int? knowledgeId;
  
  const KnowledgeFormScreen({Key? key, this.knowledgeId}) : super(key: key);

  @override
  _KnowledgeFormScreenState createState() => _KnowledgeFormScreenState();
}

class _KnowledgeFormScreenState extends State<KnowledgeFormScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // フォームコントローラー
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  
  // ドロップダウン用の状態変数
  String _selectedCategory = 'メンテナンス';
  String _selectedPublishStatus = 'published';
  final List<String> _selectedTags = [];
  
  bool _isEditing = false;
  Knowledge? _originalKnowledge;
  
  @override
  void initState() {
    super.initState();
    _isEditing = widget.knowledgeId != null;
    
    if (_isEditing) {
      // 編集モードの場合、既存データを取得
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _loadKnowledgeForEditing();
      });
    }
  }
  
  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }
  
  // 編集対象のナレッジデータを取得
  Future<void> _loadKnowledgeForEditing() async {
    final viewModel = Provider.of<KnowledgeViewModel>(context, listen: false);
    
    if (widget.knowledgeId != null) {
      // 一覧データから検索
      Knowledge? knowledgeNullable = viewModel.knowledgeItems
          .where((k) => k.knowledgeId == widget.knowledgeId)
          .toList()
          .firstOrNull;
      
      // 見つからない場合は取得
      if (knowledgeNullable == null) {
        // TODO: 詳細取得APIの実装後修正
        await viewModel.fetchKnowledgeItems(); // 全件取得でリフレッシュ (暫定)
        knowledgeNullable = viewModel.knowledgeItems
          .where((k) => k.knowledgeId == widget.knowledgeId)
          .toList()
          .firstOrNull;
      }
      
      if (knowledgeNullable != null) {
        // nullでない変数を作成
        final knowledge = knowledgeNullable;
        setState(() {
          _originalKnowledge = knowledge;
          
          // フォームに値をセット - null安全な方法で
          _titleController.text = knowledge.title;
          _contentController.text = knowledge.content;
          _selectedCategory = knowledge.category ?? 'メンテナンス';
          _selectedPublishStatus = knowledge.publishStatus ?? 'draft';
          
          if (knowledge.tags != null && knowledge.tags!.isNotEmpty) {
            _selectedTags.clear();
            _selectedTags.addAll(knowledge.tags!);
          }
        });
      }
    }
  }
  
  // 保存処理
  Future<void> _handleSave() async {
    if (_formKey.currentState?.validate() ?? false) {
      final viewModel = Provider.of<KnowledgeViewModel>(context, listen: false);
      
      final knowledge = Knowledge(
        knowledgeId: _isEditing ? _originalKnowledge!.knowledgeId : 0,
        title: _titleController.text,
        content: _contentController.text,
        category: _selectedCategory,
        publishStatus: _selectedPublishStatus,
        tags: _selectedTags.isNotEmpty ? _selectedTags : null,
        authorId: Provider.of<UserViewModel>(context, listen: false).currentUser?.userId,
        updatedAt: DateTime.now(),
        createdAt: _isEditing ? _originalKnowledge!.createdAt : DateTime.now(),
        id: _isEditing && _originalKnowledge?.id != null 
            ? _originalKnowledge!.id 
            : null,
      );
      
      bool success;
      if (_isEditing) {
        success = await viewModel.updateKnowledge(knowledge);
      } else {
        success = await viewModel.addKnowledge(knowledge);
      }
      
      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_isEditing ? 'ナレッジを更新しました' : '新しいナレッジを作成しました')),
        );
        Navigator.pop(context);
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(viewModel.error ?? '保存に失敗しました'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final knowledgeViewModel = Provider.of<KnowledgeViewModel>(context);
    
    // 利用可能なタグ一覧
    final availableTags = [
      'ティンパニ', 'マリンバ', 'ビブラフォン', 'シロフォン', 'ドラム', 'シンバル', 
      'メンテナンス', '初心者向け', '上級者向け', 'チューニング'
    ];
    
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'ナレッジ編集' : 'ナレッジ作成'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: AssetManagementFormBuilder(
            title: _isEditing ? 'ナレッジの編集' : '新規ナレッジ作成',
            isLoading: knowledgeViewModel.isLoading,
            onSave: _handleSave,
            onCancel: () => Navigator.pop(context),
            saveButtonLabel: _isEditing ? '更新' : '作成',
            children: [
              // タイトル
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'タイトル',
                  hintText: 'ナレッジのタイトルを入力...',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'タイトルは必須です';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 16),
              
              // カテゴリ
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'カテゴリ',
                ),
                items: [
                  'メンテナンス', '演奏技法', '購入ガイド', 'トラブルシューティング', 'その他'
                ].map((c) => DropdownMenuItem(
                      value: c,
                      child: Text(c),
                    )).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value!;
                  });
                },
              ),
              
              const SizedBox(height: 16),
              
              // 公開ステータス
              DropdownButtonFormField<String>(
                value: _selectedPublishStatus,
                decoration: const InputDecoration(
                  labelText: '公開ステータス',
                ),
                items: [
                  DropdownMenuItem(
                    value: 'published',
                    child: Row(
                      children: [
                        Icon(Icons.public, color: Colors.green),
                        SizedBox(width: 8),
                        Text('公開'),
                      ],
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'draft',
                    child: Row(
                      children: [
                        Icon(Icons.edit_note, color: Colors.grey),
                        SizedBox(width: 8),
                        Text('下書き'),
                      ],
                    ),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedPublishStatus = value!;
                  });
                },
              ),
              
              const SizedBox(height: 16),
              
              // タグ選択
              Text(
                'タグを選択:',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: availableTags.map((tag) => FilterChip(
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
                  },
                )).toList(),
              ),
              
              const SizedBox(height: 32),
              
              // 本文
              Text(
                '本文',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _contentController,
                decoration: const InputDecoration(
                  hintText: 'Markdownで本文を記述...',
                  border: OutlineInputBorder(),
                ),
                maxLines: 20,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '本文は必須です';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 16),
              
              // 添付ファイル
              // TODO: ファイルアップロード実装
              OutlinedButton.icon(
                onPressed: () {
                  // ファイル選択ダイアログを表示
                },
                icon: const Icon(Icons.attach_file),
                label: const Text('ファイルを添付'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Dart 2.xでのnullableリスト拡張（firstOrNull）
extension ListExtension<T> on List<T> {
  T? get firstOrNull => isEmpty ? null : first;
} 