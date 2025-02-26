import 'package:flutter/material.dart';
import '../../../models/base_model.dart';

/// 資産管理システム用のリスト列定義
class AssetManagementListColumn<T> {
  final String label;
  final Widget Function(T) build;
  final int flex;
  
  const AssetManagementListColumn({
    required this.label,
    required this.build,
    this.flex = 1,
  });
}

/// 資産管理システム用のリストビルダーウィジェット
class AssetManagementListBuilder<T> extends StatelessWidget {
  final String title;
  final List<T> items;
  final List<AssetManagementListColumn<T>> columns;
  final bool isLoading;
  final String? errorMessage;
  final void Function(T)? onItemTap;
  final void Function(T)? onItemEdit;
  final void Function(T)? onItemDelete;
  
  const AssetManagementListBuilder({
    Key? key,
    required this.title,
    required this.items,
    required this.columns,
    this.isLoading = false,
    this.errorMessage,
    this.onItemTap,
    this.onItemEdit,
    this.onItemDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // タイトルバー
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          const Divider(height: 1),
          
          // カラムヘッダー
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Row(
              children: [
                ...columns.map((column) => Expanded(
                  flex: column.flex,
                  child: Text(
                    column.label,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                )),
                // アクションカラム用のスペース
                if (onItemEdit != null || onItemDelete != null)
                  const SizedBox(width: 80),
              ],
            ),
          ),
          
          const Divider(height: 1),
          
          // リストアイテム
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : errorMessage != null
                    ? Center(child: Text(errorMessage!))
                    : items.isEmpty
                        ? const Center(child: Text('データがありません'))
                        : ListView.separated(
                            itemCount: items.length,
                            separatorBuilder: (_, __) => const Divider(height: 1),
                            itemBuilder: (context, index) {
                              final item = items[index];
                              return InkWell(
                                onTap: onItemTap != null
                                    ? () => onItemTap!(item)
                                    : null,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8.0,
                                    horizontal: 16.0,
                                  ),
                                  child: Row(
                                    children: [
                                      ...columns.map((column) => Expanded(
                                        flex: column.flex,
                                        child: column.build(item),
                                      )),
                                      if (onItemEdit != null || onItemDelete != null)
                                        SizedBox(
                                          width: 80,
                                          child: Row(
                                            children: [
                                              if (onItemEdit != null)
                                                IconButton(
                                                  icon: const Icon(Icons.edit),
                                                  onPressed: () => onItemEdit!(item),
                                                  tooltip: '編集',
                                                ),
                                              if (onItemDelete != null)
                                                IconButton(
                                                  icon: const Icon(Icons.delete),
                                                  onPressed: () => onItemDelete!(item),
                                                  tooltip: '削除',
                                                ),
                                            ],
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
          ),
        ],
      ),
    );
  }
} 