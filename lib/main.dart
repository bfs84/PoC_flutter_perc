import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'routes.dart';
import 'services/api_service.dart';
import 'services/database_helper.dart';
import 'viewmodels/user_viewmodel.dart';
import 'viewmodels/asset_viewmodel.dart';
import 'viewmodels/acquisition_viewmodel.dart';
import 'viewmodels/knowledge_viewmodel.dart';
import 'utils/theme.dart';
import 'utils/constants.dart';
import 'views/screens/login_screen.dart';
import 'views/screens/home_dashboard.dart';

void main() async {
  // FlutterウィジェットバインディングとSQLiteの初期化
  WidgetsFlutterBinding.ensureInitialized();
  
  // Webプラットフォームかどうかを確認
  if (!kIsWeb) {
    // モバイル環境の場合のみSQLiteを初期化
    await DatabaseHelper.instance.database;
  } else {
    // Web環境の場合は別の処理
    print('Webプラットフォームでの実行を検出しました。SQLiteは初期化しません。');
  }
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // APIサービスの初期化
    final apiService = ApiService();
    
    // 複数のProviderを設定
    return MultiProvider(
      providers: [
        // ViewModelsのProvider登録
        ChangeNotifierProvider(create: (_) => UserViewModel(apiService)),
        ChangeNotifierProvider(create: (_) => AssetViewModel(apiService)),
        ChangeNotifierProvider(create: (_) => AcquisitionViewModel(apiService)),
        ChangeNotifierProvider(create: (_) => KnowledgeViewModel(apiService)),
      ],
      child: MaterialApp(
        title: AppConstants.appName,
        theme: AppTheme.lightTheme,
        initialRoute: AppConstants.loginPath,
        onGenerateRoute: AppRouter.generateRoute,
        home: const AuthWrapper(),
      ),
    );
  }
}

// 認証状態に応じて適切な画面を表示するラッパー
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final userViewModel = Provider.of<UserViewModel>(context);
    
    // 認証状態に応じて画面を切り替え
    if (userViewModel.isAuthenticated) {
      return const HomeDashboard();
    } else {
      return const LoginScreen();
    }
  }
} 