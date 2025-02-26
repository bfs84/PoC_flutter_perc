import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../viewmodels/acquisition_viewmodel.dart';
import '../../../models/acquisition_asset.dart';
import '../../../utils/constants.dart';

class AcquisitionStatsWidget extends StatelessWidget {
  const AcquisitionStatsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final acquisitionViewModel = Provider.of<AcquisitionViewModel>(context);
    final acquisitions = acquisitionViewModel.acquisitions;
    
    // 最近の購入検討資産（最新5件）
    final recentAcquisitions = acquisitions
        .where((a) => a.status == 'pending')
        .toList()
      ..sort((a, b) {
        final aCreatedAt = a.createdAt;
        final bCreatedAt = b.createdAt;
        if (aCreatedAt == null) return 1;
        if (bCreatedAt == null) return -1;
        return bCreatedAt.compareTo(aCreatedAt);
      });
    
    final pendingCount = acquisitions.where((a) => a.status == 'pending').length;
    final deliveringCount = acquisitions.where((a) => a.status == 'delivering').length;
    final arrivedCount = acquisitions.where((a) => a.status == 'arrived').length;
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ヘッダー
            InkWell(
              onTap: () {
                Navigator.pushNamed(context, AppConstants.acquisitionsPath);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '購入検討・状況',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  TextButton.icon(
                    icon: const Icon(Icons.arrow_forward),
                    label: const Text('すべて表示'),
                    onPressed: () {
                      Navigator.pushNamed(context, AppConstants.acquisitionsPath);
                    },
                  ),
                ],
              ),
            ),
            const Divider(),
            
            // 統計カード
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatCard(
                    context,
                    '申請中',
                    pendingCount.toString(),
                    Icons.pending_actions,
                    Colors.orange,
                  ),
                  _buildStatCard(
                    context,
                    '配送中',
                    deliveringCount.toString(),
                    Icons.local_shipping,
                    Colors.blue,
                  ),
                  _buildStatCard(
                    context,
                    '到着済',
                    arrivedCount.toString(),
                    Icons.check_circle,
                    Colors.green,
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // 最近の申請リスト
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '最近の申請状況',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                if (recentAcquisitions.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(child: Text('最近の申請はありません')),
                  )
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: recentAcquisitions.take(5).length,
                    itemBuilder: (context, index) {
                      final acquisition = recentAcquisitions[index];
                      return ListTile(
                        leading: const Icon(Icons.shopping_cart),
                        title: Text(
                          '${acquisition.assetCode} - ${acquisition.model}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          '申請者: ${acquisition.requestedBy?.displayName ?? '不明'} / '
                          '申請日: ${_formatDate(acquisition.requestedDate, acquisition.createdAt)}',
                        ),
                        trailing: Chip(
                          label: Text(_getStatusText(acquisition.status)),
                          backgroundColor: _getStatusColor(acquisition.status),
                        ),
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            AppConstants.acquisitionDetailsPath.replaceAll(
                              ':id',
                              acquisition.acquisitionId.toString(),
                            ),
                          );
                        },
                      );
                    },
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  // 統計カードを生成
  Widget _buildStatCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(
              icon,
              color: color,
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  // 日付のフォーマット（nullの場合は代替日付を使用）
  String _formatDate(DateTime? primaryDate, DateTime? fallbackDate) {
    final dateToFormat = primaryDate ?? fallbackDate ?? DateTime.now();
    return DateFormat('yyyy/MM/dd').format(dateToFormat);
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
      case 'pending': return Colors.orange.shade100;
      case 'delivering': return Colors.blue.shade100;
      case 'arrived': return Colors.green.shade100;
      default: return Colors.grey.shade100;
    }
  }
} 