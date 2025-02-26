class ApiConstants {
  // APIエンドポイント
  static const String baseUrl = 'https://api.percussioninventory.example.com/v1';
  
  // APIパス
  static const String assetsPath = '/assets';
  static const String usersPath = '/users';
  static const String acquisitionPath = '/acquisitions';
  static const String knowledgePath = '/knowledge';
  
  // リクエストパラメータ
  static const String keywordParam = 'keyword';
  static const String categoryParam = 'category';
  static const String pageParam = 'page';
  static const String pageSizeParam = 'pageSize';
}

class AppConstants {
  // API設定
  static const String apiBaseUrl = 'https://api.drum-asset-management.example.com/v1';
  
  // 認証関連
  static const int sessionTimeoutMinutes = 60;
  
  // アプリ名
  static const String appName = '打楽器管理システム';
  
  // ナビゲーション関連
  static const String homePath = '/';
  static const String assetsPath = '/assets';
  static const String assetDetailsPath = '/assets/:id';
  static const String assetCreatePath = '/assets/create';
  static const String assetEditPath = '/assets/edit/:id';
  static const String acquisitionsPath = '/acquisitions';
  static const String acquisitionDetailsPath = '/acquisitions/:id';
  static const String acquisitionCreatePath = '/acquisitions/create';
  static const String acquisitionEditPath = '/acquisitions/edit/:id';
  static const String knowledgePath = '/knowledge';
  static const String knowledgeDetailsPath = '/knowledge/:id';
  static const String knowledgeCreatePath = '/knowledge/create';
  static const String knowledgeEditPath = '/knowledge/edit/:id';
  static const String loginPath = '/login';
  static const String profilePath = '/profile';
  
  // 設定値
  static const int defaultPageSize = 20;
  
  // その他の定数
  static const List<String> degradationLevels = ['critical', 'high', 'medium', 'low', 'good'];
  static const List<String> assetCategories = [
    'ティンパニ', 'マリンバ', 'シロフォン', 'ドラム', 'シンバル', 
    'トライアングル', 'タンバリン', 'その他'
  ];
} 