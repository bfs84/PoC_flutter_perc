import 'package:flutter/material.dart';
import '../../../models/acquisition_asset.dart';
import '../../../utils/constants.dart';

class RecentAcquisitionsWidget extends StatelessWidget {
  final List<AcquisitionAsset> acquisitions;
  final VoidCallback onViewAll;
  
  const RecentAcquisitionsWidget({
    Key? key,
    required this.acquisitions,
    required this.onViewAll,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    // 最近の5件を表示
    final recentItems = acquisitions.length > 5 
        ? acquisitions.sublist(0, 5) 
        : acquisitions;
    
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ヘッダー
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '最近の購入検討資産',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                TextButton(
                  onPressed: onViewAll,
                  child: const Text('すべて表示'),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          
          // データがない場合
          if (recentItems.isEmpty)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(
                child: Text('購入検討資産がありません'),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: recentItems.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final item = recentItems[index];
                return ListTile(
                  title: Text(item.getDisplayValue()),
                  subtitle: Text(
                    '¥${item.price.toStringAsFixed(0)} - ${item.statusText}',
                  ),
                  trailing: _buildStatusChip(item.status),
                  onTap: () {
                    // 詳細画面に遷移
                    Navigator.pushNamed(
                      context, 
                      AppConstants.acquisitionDetailsPath.replaceAll(':id', item.acquisitionId.toString()),
                    );
                  },
                );
              },
            ),
        ],
      ),
    );
  }
  
  Widget _buildStatusChip(String status) {
    Color color;
    switch (status) {
      case 'pending':
        color = Colors.orange;
        break;
      case 'delivering':
        color = Colors.blue;
        break;
      case 'arrived':
        color = Colors.green;
        break;
      default:
        color = Colors.grey;
    }
    
    return Chip(
      label: Text(
        status == 'pending' ? '申請中' : 
        status == 'delivering' ? '配送中' : 
        status == 'arrived' ? '到着済' : status,
        style: TextStyle(color: Colors.white, fontSize: 12),
      ),
      backgroundColor: color,
      padding: EdgeInsets.zero,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
} 