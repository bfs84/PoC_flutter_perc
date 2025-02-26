import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../viewmodels/asset_viewmodel.dart';
import '../../../models/asset.dart';
import '../../widgets/common/app_drawer.dart';
import '../../widgets/common/list_builder.dart';
import '../../../utils/constants.dart';
import 'package:intl/intl.dart';

class AssetListScreen extends StatefulWidget {
  const AssetListScreen({Key? key}) : super(key: key);

  @override
  _AssetListScreenState createState() => _AssetListScreenState();
}

class _AssetListScreenState extends State<AssetListScreen> {
  final _searchController = TextEditingController();
  String? _selectedCategory;
  
  @override
  void initState() {
    super.initState();
    // 画面表示時にデータ取得
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AssetViewModel>(context, listen: false).fetchAssets();
    });
  }
  
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
  
  // 検索実行
  void _handleSearch() {
    Provider.of<AssetViewModel>(context, listen: false).searchAssets(
      keyword: _searchController.text.isNotEmpty ? _searchController.text : null,
      category: _selectedCategory,
    );
  }
  
  @override
  Widget build(BuildContext context) {
    final assetViewModel = Provider.of<AssetViewModel>(context);
    
    // リストに表示するカラム定義
    final columns = [
      AssetManagementListColumn<Asset>(
        label: '資産コード',
        build: (item) => Text(
          item.assetCode,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      AssetManagementListColumn<Asset>(
        label: 'モデル',
        flex: 2,
        build: (item) => Text(item.model),
      ),
      AssetManagementListColumn<Asset>(
        label: 'カテゴリ',
        build: (item) => Text(item.category),
      ),
      AssetManagementListColumn<Asset>(
        label: '状態',
        build: (item) => Text(item.degradationText),
      ),
      AssetManagementListColumn<Asset>(
        label: '購入日',
        build: (item) => Text(
          DateFormat('yyyy/MM/dd').format(item.purchaseDate),
        ),
      ),
      AssetManagementListColumn<Asset>(
        label: '保管場所',
        build: (item) => Text(item.storageLocation ?? '-'),
      ),
    ];
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('資産管理'),
      ),
      drawer: const AppDrawer(),
      body: Column(
        children: [
          // 検索フィルターエリア
          Card(
            margin: const EdgeInsets.all(16.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '検索フィルター',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  
                  // 検索条件
                  Row(
                    children: [
                      // キーワード検索
                      Expanded(
                        flex: 2,
                        child: TextField(
                          controller: _searchController,
                          decoration: const InputDecoration(
                            labelText: 'キーワード',
                            prefixIcon: Icon(Icons.search),
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      
                      const SizedBox(width: 16),
                      
                      // カテゴリフィルター
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _selectedCategory,
                          decoration: const InputDecoration(
                            labelText: 'カテゴリ',
                            border: OutlineInputBorder(),
                          ),
                          items: const [
                            DropdownMenuItem(
                              value: null,
                              child: Text('全て'),
                            ),
                            DropdownMenuItem(
                              value: 'ティンパニ',
                              child: Text('ティンパニ'),
                            ),
                            DropdownMenuItem(
                              value: 'マリンバ',
                              child: Text('マリンバ'),
                            ),
                            DropdownMenuItem(
                              value: 'シロフォン',
                              child: Text('シロフォン'),
                            ),
                            DropdownMenuItem(
                              value: 'ドラム',
                              child: Text('ドラム'),
                            ),
                            DropdownMenuItem(
                              value: 'その他',
                              child: Text('その他'),
                            ),
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
                      ElevatedButton.icon(
                        onPressed: _handleSearch,
                        icon: const Icon(Icons.search),
                        label: const Text('検索'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 24,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          // リスト表示
          Expanded(
            child: AssetManagementListBuilder<Asset>(
              title: '資産一覧',
              items: assetViewModel.assets,
              columns: columns,
              isLoading: assetViewModel.isLoading,
              errorMessage: assetViewModel.error,
              onItemTap: (item) {
                Navigator.pushNamed(
                  context,
                  AppConstants.assetDetailsPath.replaceAll(':id', item.assetId.toString()),
                );
              },
              onItemEdit: (item) {
                Navigator.pushNamed(
                  context,
                  AppConstants.assetEditPath.replaceAll(':id', item.assetId.toString()),
                );
              },
              onItemDelete: (item) {
                // 削除確認ダイアログ
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('削除確認'),
                    content: Text('資産 "${item.getDisplayValue()}" を削除してもよろしいですか？'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('キャンセル'),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          Navigator.pop(context);
                          final success = await assetViewModel.deleteAsset(item.assetId);
                          if (success && mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('資産を削除しました')),
                            );
                          } else if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(assetViewModel.error ?? '削除に失敗しました'),
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
      // 資産追加ボタン
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, AppConstants.assetCreatePath);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
} 