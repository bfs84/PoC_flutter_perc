import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../viewmodels/asset_viewmodel.dart';
import '../../../models/asset.dart';
import '../../../utils/constants.dart';

class AssetDetailsScreen extends StatefulWidget {
  final int assetId;
  
  const AssetDetailsScreen({Key? key, required this.assetId}) : super(key: key);

  @override
  _AssetDetailsScreenState createState() => _AssetDetailsScreenState();
}

class _AssetDetailsScreenState extends State<AssetDetailsScreen> {
  @override
  void initState() {
    super.initState();
    // 詳細画面表示時に指定されたIDの資産データを取得
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadAssetDetails();
    });
  }
  
  // 資産詳細データ取得
  Future<void> _loadAssetDetails() async {
    final assetViewModel = Provider.of<AssetViewModel>(context, listen: false);
    
    // 現在の一覧データから該当資産を検索
    final assets = assetViewModel.assets;
    final asset = assets.where((a) => a.assetId == widget.assetId).toList();
    
    // 該当資産がなければ取得 (通常はList画面から来るので見つかるはず)
    if (asset.isEmpty) {
      await assetViewModel.fetchAssetById(widget.assetId);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final assetViewModel = Provider.of<AssetViewModel>(context);
    
    // 該当資産を検索
    final asset = assetViewModel.assets
        .where((a) => a.assetId == widget.assetId)
        .toList()
        .firstOrNull;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(asset?.getDisplayValue() ?? '資産詳細'),
        actions: [
          // 編集ボタン
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: asset == null
                ? null
                : () {
                    Navigator.pushNamed(
                      context,
                      AppConstants.assetEditPath.replaceAll(':id', widget.assetId.toString()),
                    );
                  },
          ),
        ],
      ),
      body: assetViewModel.isLoading
          ? const Center(child: CircularProgressIndicator())
          : asset == null
              ? const Center(child: Text('資産が見つかりません'))
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 基本情報カード
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '基本情報',
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                                const Divider(),
                                const SizedBox(height: 16),
                                
                                // 詳細情報テーブル
                                _buildInfoTable(context, asset),
                              ],
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 16),
                        
                        // 詳細説明カード
                        if (asset.description != null)
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '詳細説明',
                                    style: Theme.of(context).textTheme.titleLarge,
                                  ),
                                  const Divider(),
                                  const SizedBox(height: 16),
                                  Text(asset.description!),
                                ],
                              ),
                            ),
                          ),
                          
                        const SizedBox(height: 16),
                        
                        // 作業メモカード
                        if (asset.worknotes != null)
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '作業メモ',
                                    style: Theme.of(context).textTheme.titleLarge,
                                  ),
                                  const Divider(),
                                  const SizedBox(height: 16),
                                  Text(asset.worknotes!),
                                ],
                              ),
                            ),
                          ),
                          
                        // 添付資料やURLへのリンクなど...
                      ],
                    ),
                  ),
                ),
    );
  }
  
  // 詳細情報テーブル
  Widget _buildInfoTable(BuildContext context, Asset asset) {
    return Table(
      columnWidths: const {
        0: FlexColumnWidth(1),
        1: FlexColumnWidth(2),
      },
      border: TableBorder.all(
        color: Colors.grey.shade300,
        width: 1,
      ),
      children: [
        _buildTableRow('資産コード', asset.assetCode),
        _buildTableRow('モデル', asset.model),
        _buildTableRow('カテゴリ', asset.category),
        _buildTableRow('価格', '¥${NumberFormat('#,###').format(asset.price)}'),
        _buildTableRow('所有者', asset.owner?.displayName ?? '-'),
        _buildTableRow('状態', asset.degradationText),
        _buildTableRow('購入日', DateFormat('yyyy年MM月dd日').format(asset.purchaseDate)),
        _buildTableRow('保管場所', asset.storageLocation ?? '-'),
        _buildTableRow('ステータス', asset.status),
        if (asset.lastMaintenanceDate != null)
          _buildTableRow('最終メンテナンス日', 
              DateFormat('yyyy年MM月dd日').format(asset.lastMaintenanceDate!)),
      ],
    );
  }
  
  TableRow _buildTableRow(String label, String value) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(value),
        ),
      ],
    );
  }
}

// Dart 2.xでのnullableリスト拡張（firstOrNull）
extension ListExtension<T> on List<T> {
  T? get firstOrNull => isEmpty ? null : first;
} 