import 'package:flutter/material.dart';

class BudgetDashboard extends StatelessWidget {
  const BudgetDashboard({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // ダミーのドラッグ＆ドロップUIプレースホルダー
    return Scaffold(
      appBar: AppBar(title: const Text('予算管理ダッシュボード')),
      body: const Center(
        child: Text('ここにDrag and Dropによる予算管理UIを実装'),
      ),
    );
  }
} 