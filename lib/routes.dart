import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/asset_list.dart';
import 'screens/asset_edit.dart';
import 'screens/acquisition_screen.dart';
import 'screens/budget_dashboard.dart';
import 'screens/knowledge_screen.dart';
import 'models/asset.dart';

final Map<String, WidgetBuilder> appRoutes = {
  '/login': (context) => const LoginScreen(),
  '/home': (context) => const HomeScreen(),
  '/asset/list': (context) => const AssetList(),
  '/asset/edit': (context) => AssetEdit(
    asset: Asset(
      assetId: 0,
      assetCode: 'dummy-code',
      category: 'dummy-category',
      model: 'dummy-model',
      price: 0.0,
      purchaseDate: DateTime.now(),
      status: 'dummy-status',
    ),
  ),
  '/acquisition': (context) => const AcquisitionScreen(),
  '/budget': (context) => const BudgetDashboard(),
  '/knowledge': (context) => const KnowledgeScreen(),
}; 