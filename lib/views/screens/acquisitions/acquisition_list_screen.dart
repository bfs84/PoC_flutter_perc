import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../viewmodels/acquisition_viewmodel.dart';
import '../../../models/acquisition_asset.dart';
import '../../widgets/common/app_drawer.dart';
import '../../widgets/common/list_builder.dart';
import '../../../utils/constants.dart';
import 'package:intl/intl.dart';

class AcquisitionListScreen extends StatefulWidget {
  const AcquisitionListScreen({Key? key}) : super(key: key);

  @override
  _AcquisitionListScreenState createState() => _AcquisitionListScreenState();
}

class _AcquisitionListScreenState extends State<AcquisitionListScreen> {
  final _searchController = TextEditingController();
  String? _selectedCategory;
  String? _selectedStatus;
  
  @override
  void initState() {
    super.initState();
    // 画面表示時にデータ取得
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AcquisitionViewModel>(context, listen: false).fetchAcquisitions();
    });
  }
  
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
  
  // 検索実行
  void _handleSearch() {
    Provider.of<AcquisitionViewModel>(context, listen: false).searchAcquisitions(
      keyword: _searchController.text.isNotEmpty ? _searchController.text : null,
      category: _selectedCategory,
      status: _selectedStatus,
    );
  }
  
  @override
  Widget build(BuildContext context) {
    final acquisitionViewModel = Provider.of<AcquisitionViewModel>(context);
    
    // リストに表示するカラム定義
    final columns = [
      AssetManagementListColumn<AcquisitionAsset>(
        label: '資産コード', 
        build: (item) => Text(
          item.assetCode,
        ),
        flex: 1,
      ),
      AssetManagementListColumn<AcquisitionAsset>(
        label: 'モデル名', 
        build: (item) => Text(item.model),
        flex: 2,
      ),
      AssetManagementListColumn<AcquisitionAsset>(
        label: 'カテゴリ', 
        build: (item) => Text(item.category),
        flex: 1,
      ),
      AssetManagementListColumn<AcquisitionAsset>(
        label: '価格', 
        build: (item) => Text(
          '¥${NumberFormat('#,###').format(item.price)}',
        ),
        flex: 1,
      ),
      AssetManagementListColumn<AcquisitionAsset>(
        label: 'ステータス', 
        build: (item) => Chip(
          label: Text(
            item.statusText,
            style: const TextStyle(fontSize: 12, color: Colors.white),
          ),
          backgroundColor: _getStatusColor(item.status),
          padding: EdgeInsets.zero,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        flex: 1,
      ),
    ];
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('購入検討資産'),
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
                            hintText: 'モデル名や資産コードで検索',
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
                            ...['ティンパニ', 'マリンバ', 'ビブラフォン', 'シロフォン', 'ドラム', 'シンバル', 'その他']
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
                      
                      // ステータス選択
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _selectedStatus,
                          decoration: const InputDecoration(
                            labelText: 'ステータス',
                          ),
                          items: [
                            const DropdownMenuItem(
                              value: null,
                              child: Text('すべて'),
                            ),
                            ...['pending', 'delivering', 'arrived']
                                .map((s) => DropdownMenuItem(
                                      value: s,
                                      child: Text(_getStatusText(s)),
                                    ))
                                .toList(),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _selectedStatus = value;
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
                ],
              ),
            ),
          ),
          
          // 一覧表示
          Expanded(
            child: AssetManagementListBuilder<AcquisitionAsset>(
              title: '購入検討資産一覧',
              items: acquisitionViewModel.acquisitions,
              columns: columns,
              isLoading: acquisitionViewModel.isLoading,
              errorMessage: acquisitionViewModel.error,
              onItemTap: (item) {
                Navigator.pushNamed(
                  context,
                  AppConstants.acquisitionDetailsPath.replaceAll(':id', item.acquisitionId.toString()),
                );
              },
              onItemEdit: (item) {
                Navigator.pushNamed(
                  context,
                  AppConstants.acquisitionEditPath.replaceAll(':id', item.acquisitionId.toString()),
                );
              },
              onItemDelete: (item) {
                // 削除確認
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('削除確認'),
                    content: Text('購入検討資産 "${item.getDisplayValue()}" を削除してもよろしいですか？'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('キャンセル'),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          Navigator.pop(context);
                          final success = await acquisitionViewModel.deleteAcquisition(item.acquisitionId);
                          if (success && mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('購入検討資産を削除しました')),
                            );
                          } else if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(acquisitionViewModel.error ?? '削除に失敗しました'),
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
      // 購入検討資産追加ボタン
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, AppConstants.acquisitionCreatePath);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
  
  // ステータスの表示名を取得
  String _getStatusText(String status) {
    switch (status) {
      case 'pending': return '申請中';
      case 'delivering': return '配送中';
      case 'arrived': return '到着済';
      default: return status;
    }
  }
  
  // ステータスの色を取得
  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending': return Colors.orange;
      case 'delivering': return Colors.blue;
      case 'arrived': return Colors.green;
      default: return Colors.grey;
    }
  }
} 