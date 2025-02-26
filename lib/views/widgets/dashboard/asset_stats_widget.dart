import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../viewmodels/asset_viewmodel.dart';
import '../../../models/asset.dart';
import '../../../utils/constants.dart';

class AssetStatsWidget extends StatelessWidget {
  const AssetStatsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final assetViewModel = Provider.of<AssetViewModel>(context);
    final assets = assetViewModel.assets;
    
    // カテゴリ別の資産数を集計
    final Map<String, int> categoryCount = {};
    for (final asset in assets) {
      final category = asset.category;
      if (categoryCount.containsKey(category)) {
        categoryCount[category] = categoryCount[category]! + 1;
      } else {
        categoryCount[category] = 1;
      }
    }
    
    // 劣化度別の資産数を集計
    final Map<String, int> degradationMap = {
      'critical': 0, // 重大
      'high': 0, // 高
      'medium': 0, // 中
      'low': 0, // 小
      'good': 0, // なし
    };
    
    for (final asset in assets) {
      final degradation = asset.degradation?.toString() ?? 'good';
      if (degradationMap.containsKey(degradation)) {
        degradationMap[degradation] = degradationMap[degradation]! + 1;
      }
    }
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ヘッダー
            InkWell(
              onTap: () {
                Navigator.pushNamed(context, AppConstants.assetsPath);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '資産統計',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  // すべて表示ボタン
                  TextButton.icon(
                    icon: const Icon(Icons.arrow_forward),
                    label: const Text('すべて表示'),
                    onPressed: () {
                      Navigator.pushNamed(context, AppConstants.assetsPath);
                    },
                  ),
                ],
              ),
            ),
            const Divider(),
            
            // 統計サマリー
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatCard(
                    context,
                    '総資産数',
                    assets.length.toString(),
                    Icons.inventory,
                    Colors.blue,
                  ),
                  _buildStatCard(
                    context,
                    '劣化要対応',
                    (degradationMap['critical']! + degradationMap['high']!).toString(),
                    Icons.warning,
                    Colors.orange,
                  ),
                  _buildStatCard(
                    context,
                    '良好状態',
                    degradationMap['good']!.toString(),
                    Icons.check_circle,
                    Colors.green,
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // グラフエリア
            Row(
              children: [
                // カテゴリ別円グラフ
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        'カテゴリ別資産数',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 200,
                        child: categoryCount.isEmpty
                            ? const Center(child: Text('データなし'))
                            : PieChart(
                                PieChartData(
                                  sectionsSpace: 2,
                                  centerSpaceRadius: 40,
                                  sections: _getCategorySections(categoryCount),
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
                
                // 劣化度別棒グラフ
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        '劣化度別資産数',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 200,
                        child: BarChart(
                          BarChartData(
                            titlesData: FlTitlesData(
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              topTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              rightTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: (value, meta) {
                                    String text = '';
                                    switch (value.toInt()) {
                                      case 0: text = '重大'; break;
                                      case 1: text = '高'; break;
                                      case 2: text = '中'; break;
                                      case 3: text = '小'; break;
                                      case 4: text = 'なし'; break;
                                    }
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Text(text, style: const TextStyle(fontSize: 10)),
                                    );
                                  },
                                ),
                              ),
                            ),
                            gridData: FlGridData(show: false),
                            borderData: FlBorderData(show: false),
                            barGroups: [
                              for (int i = 0; i < 5; i++)
                                BarChartGroupData(
                                  x: i,
                                  barRods: [
                                    BarChartRodData(
                                      toY: degradationMap.values.elementAt(i).toDouble(),
                                      color: i == 0 
                                          ? Colors.red 
                                          : i == 1 
                                              ? Colors.orange 
                                              : i == 2 
                                                  ? Colors.green 
                                                  : Colors.grey,
                                      width: 20,
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(4),
                                        topRight: Radius.circular(4),
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                            maxY: degradationMap.values
                                    .reduce((a, b) => a > b ? a : b)
                                    .toDouble() * 1.2,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  // カテゴリ別の円グラフセクションを生成
  List<PieChartSectionData> _getCategorySections(Map<String, int> categoryCount) {
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.red,
      Colors.teal,
      Colors.brown,
      Colors.indigo,
    ];
    
    final List<PieChartSectionData> sections = [];
    int colorIndex = 0;
    
    categoryCount.forEach((category, count) {
      sections.add(
        PieChartSectionData(
          color: colors[colorIndex % colors.length],
          value: count.toDouble(),
          title: '$category\n$count',
          radius: 80,
          titleStyle: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      );
      colorIndex++;
    });
    
    return sections;
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
} 