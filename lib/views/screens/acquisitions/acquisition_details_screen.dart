import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../viewmodels/acquisition_viewmodel.dart';
import '../../../models/acquisition_asset.dart';
import '../../../utils/constants.dart';

class AcquisitionDetailsScreen extends StatefulWidget {
  final int acquisitionId;
  
  const AcquisitionDetailsScreen({Key? key, required this.acquisitionId}) : super(key: key);

  @override
  _AcquisitionDetailsScreenState createState() => _AcquisitionDetailsScreenState();
}

class _AcquisitionDetailsScreenState extends State<AcquisitionDetailsScreen> {
  @override
  void initState() {
    super.initState();
    // 詳細画面表示時に指定されたIDの購入検討資産データを取得
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadAcquisitionDetails();
    });
  }
  
  // 購入検討資産詳細データ取得
  Future<void> _loadAcquisitionDetails() async {
    final viewModel = Provider.of<AcquisitionViewModel>(context, listen: false);
    
    // 現在の一覧データから該当購入検討資産を検索
    final items = viewModel.acquisitions;
    final item = items.where((a) => a.acquisitionId == widget.acquisitionId).toList();
    
    // 該当購入検討資産がなければ取得
    if (item.isEmpty) {
      // TODO: 詳細取得APIがある場合は実装
      await viewModel.fetchAcquisitions(); // 全件取得でリフレッシュ (暫定)
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<AcquisitionViewModel>(context);
    
    // 該当購入検討資産を検索
    final acquisition = viewModel.acquisitions
        .where((a) => a.acquisitionId == widget.acquisitionId)
        .toList()
        .firstOrNull;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('購入検討資産詳細'),
        actions: [
          // 編集ボタン
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.pushNamed(
                context,
                AppConstants.acquisitionEditPath.replaceAll(':id', widget.acquisitionId.toString()),
              );
            },
          ),
        ],
      ),
      body: viewModel.isLoading
          ? const Center(child: CircularProgressIndicator())
          : acquisition == null
              ? const Center(child: Text('購入検討資産が見つかりません'))
              : SingleChildScrollView(
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
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      acquisition.getDisplayValue(),
                                      style: Theme.of(context).textTheme.titleLarge,
                                    ),
                                  ),
                                  Chip(
                                    label: Text(
                                      acquisition.statusText,
                                      style: const TextStyle(color: Colors.white),
                                    ),
                                    backgroundColor: _getStatusColor(acquisition.status),
                                  ),
                                ],
                              ),
                              const Divider(),
                              const SizedBox(height: 16),
                              
                              // 購入検討資産データテーブル
                              _buildAcquisitionDataTable(acquisition),
                              
                              const SizedBox(height: 16),
                              
                              // ステータス更新ボタン
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  ElevatedButton(
                                    onPressed: acquisition.status != 'pending'
                                        ? null
                                        : () => _updateStatus(acquisition, 'delivering'),
                                    child: const Text('配送中に更新'),
                                  ),
                                  const SizedBox(width: 8),
                                  ElevatedButton(
                                    onPressed: acquisition.status == 'arrived'
                                        ? null
                                        : () => _updateStatus(acquisition, 'arrived'),
                                    child: const Text('到着済みに更新'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // 追加情報カード
                      if (acquisition.description != null || acquisition.attachment != null)
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '追加情報',
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                                const Divider(),
                                
                                if (acquisition.description != null) ...[
                                  const SizedBox(height: 16),
                                  Text(
                                    '説明',
                                    style: Theme.of(context).textTheme.titleMedium,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(acquisition.description!),
                                ],
                                
                                if (acquisition.attachment != null) ...[
                                  const SizedBox(height: 16),
                                  Text(
                                    '添付ファイル',
                                    style: Theme.of(context).textTheme.titleMedium,
                                  ),
                                  const SizedBox(height: 8),
                                  ListTile(
                                    leading: const Icon(Icons.attach_file),
                                    title: Text(acquisition.attachment!.split('/').last),
                                    onTap: () {
                                      // TODO: 添付ファイルを開く
                                    },
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
    );
  }
  
  // ステータス更新処理
  Future<void> _updateStatus(AcquisitionAsset acquisition, String newStatus) async {
    final viewModel = Provider.of<AcquisitionViewModel>(context, listen: false);
    final success = await viewModel.updateAcquisitionStatus(
      acquisition.acquisitionId, 
      newStatus,
    );
    
    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('ステータスを「${_getStatusText(newStatus)}」に更新しました')),
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(viewModel.error ?? 'ステータス更新に失敗しました'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
  
  // 詳細データテーブルを構築
  Widget _buildAcquisitionDataTable(AcquisitionAsset acquisition) {
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
        _buildTableRow('資産コード', acquisition.assetCode),
        _buildTableRow('モデル', acquisition.model),
        _buildTableRow('カテゴリ', acquisition.category),
        _buildTableRow('価格', '¥${NumberFormat('#,###').format(acquisition.price)}'),
        _buildTableRow('通貨', acquisition.currency),
        if (acquisition.purchaseReason != null)
          _buildTableRow('購入理由', acquisition.purchaseReason!),
        if (acquisition.requestedBy != null)
          _buildTableRow('申請者', acquisition.requestedBy!.displayName),
        if (acquisition.requestedDate != null)
          _buildTableRow('申請日', DateFormat('yyyy年MM月dd日').format(acquisition.requestedDate!)),
        if (acquisition.fiscalYear != null)
          _buildTableRow('会計年度', acquisition.fiscalYear.toString()),
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

// Dart 2.xでのnullableリスト拡張（firstOrNull）
extension ListExtension<T> on List<T> {
  T? get firstOrNull => isEmpty ? null : first;
} 