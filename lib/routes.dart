import 'package:flutter/material.dart';
import 'utils/constants.dart';
import 'views/screens/login_screen.dart';
import 'views/screens/home_dashboard.dart';
import 'views/screens/assets/asset_list_screen.dart';
import 'views/screens/assets/asset_details_screen.dart';
import 'views/screens/assets/asset_form_screen.dart';
import 'views/screens/acquisitions/acquisition_list_screen.dart';
import 'views/screens/acquisitions/acquisition_details_screen.dart';
import 'views/screens/acquisitions/acquisition_form_screen.dart';
import 'views/screens/knowledge/knowledge_list_screen.dart';
import 'views/screens/knowledge/knowledge_details_screen.dart';
import 'views/screens/knowledge/knowledge_form_screen.dart';
import 'views/screens/profile_screen.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // 画面遷移時のURLからIDを抽出する関数
    int? extractId(String name, String pattern) {
      final regExp = RegExp(pattern);
      return int.tryParse(regExp.firstMatch(name)?.group(1) ?? '');
    }
    
    switch (settings.name) {
      case AppConstants.loginPath:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
        
      case AppConstants.homePath:
        return MaterialPageRoute(builder: (_) => const HomeDashboard());
        
      case AppConstants.profilePath:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
        
      // 資産関連のルート
      case AppConstants.assetsPath:
        return MaterialPageRoute(builder: (_) => const AssetListScreen());
        
      case AppConstants.assetCreatePath:
        return MaterialPageRoute(builder: (_) => const AssetFormScreen());
        
      // 資産詳細/編集のルート - IDをURLから抽出
      default:
        if (settings.name?.startsWith('/assets/') ?? false) {
          final assetId = extractId(settings.name!, r'/assets/(\d+)');
          
          if (settings.name?.endsWith('/edit') ?? false) {
            return MaterialPageRoute(
              builder: (_) => AssetFormScreen(assetId: assetId),
            );
          } else if (assetId != null) {
            return MaterialPageRoute(
              builder: (_) => AssetDetailsScreen(assetId: assetId),
            );
          }
        }
        
        // 購入検討資産関連のルート
        if (settings.name == AppConstants.acquisitionsPath) {
          return MaterialPageRoute(builder: (_) => const AcquisitionListScreen());
        }
        
        if (settings.name == AppConstants.acquisitionCreatePath) {
          return MaterialPageRoute(builder: (_) => const AcquisitionFormScreen());
        }
        
        if (settings.name?.startsWith('/acquisitions/') ?? false) {
          final acquisitionId = extractId(settings.name!, r'/acquisitions/(\d+)');
          
          if (settings.name?.endsWith('/edit') ?? false) {
            return MaterialPageRoute(
              builder: (_) => AcquisitionFormScreen(acquisitionId: acquisitionId),
            );
          } else if (acquisitionId != null) {
            return MaterialPageRoute(
              builder: (_) => AcquisitionDetailsScreen(acquisitionId: acquisitionId),
            );
          }
        }
        
        // ナレッジ関連のルート
        if (settings.name == AppConstants.knowledgePath) {
          return MaterialPageRoute(builder: (_) => const KnowledgeListScreen());
        }
        
        if (settings.name == AppConstants.knowledgeCreatePath) {
          return MaterialPageRoute(builder: (_) => const KnowledgeFormScreen());
        }
        
        if (settings.name?.startsWith('/knowledge/') ?? false) {
          final knowledgeId = extractId(settings.name!, r'/knowledge/(\d+)');
          
          if (settings.name?.endsWith('/edit') ?? false) {
            return MaterialPageRoute(
              builder: (_) => KnowledgeFormScreen(knowledgeId: knowledgeId),
            );
          } else if (knowledgeId != null) {
            return MaterialPageRoute(
              builder: (_) => KnowledgeDetailsScreen(knowledgeId: knowledgeId),
            );
          }
        }
        
        // 未定義のルートの場合はダッシュボードへ
        return MaterialPageRoute(builder: (_) => const HomeDashboard());
    }
  }
} 