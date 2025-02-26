import 'package:flutter/foundation.dart';
import '../models/user.dart';
import '../services/api_service.dart';
import '../services/database_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserViewModel with ChangeNotifier {
  final ApiService _apiService;
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  
  User? _currentUser;
  bool _isLoading = false;
  String? _error;
  bool _isAuthenticated = false;
  
  // ゲッター
  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _isAuthenticated;
  
  UserViewModel(this._apiService) {
    // 起動時に以前のログイン状態を確認
    _checkSavedLogin();
  }
  
  // 保存されたログイン情報を確認
  Future<void> _checkSavedLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final savedUsername = prefs.getString('username');
    
    if (savedUsername != null) {
      _isAuthenticated = true;
      
      try {
        // ユーザー情報を取得（APIまたはDB）
        await fetchUserProfile();
      } catch (e) {
        // エラー時は認証状態をリセット
        _isAuthenticated = false;
        await prefs.remove('username');
      }
      
      notifyListeners();
    }
  }
  
  // ログイン処理
  Future<bool> login(String username, String password) async {
    _setLoading(true);
    try {
      // 開発モードかつWebでない場合はローカルDB認証
      if (kDebugMode && !kIsWeb) {
        final user = await _dbHelper.authenticateUser(username, password);
        if (user != null) {
          _currentUser = user;
          _isAuthenticated = true;
          _error = null;
          
          // ログイン情報を保存
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('username', username);
          
          return true;
        } else {
          throw Exception('ユーザー名またはパスワードが正しくありません');
        }
      } else if (kDebugMode && kIsWeb) {
        // Webでの開発モードではダミー認証
        if (username == 'admin' && password == 'admin123') {
          // ダミーユーザーを作成
          _currentUser = User(
            userId: 1,
            username: 'admin',
            email: 'admin@example.com',
            displayName: '管理者',
            role: 'admin',
            isActive: true,
          );
          _isAuthenticated = true;
          _error = null;
          
          // ログイン情報を保存
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('username', username);
          
          return true;
        } else {
          throw Exception('ユーザー名またはパスワードが正しくありません');
        }
      } else {
        // 本番モードではAPIを使用
        final user = await _apiService.login(username, password);
        _currentUser = user;
        _isAuthenticated = true;
        _error = null;
        return true;
      }
    } catch (e) {
      _error = e.toString();
      _isAuthenticated = false;
      return false;
    } finally {
      _setLoading(false);
    }
  }
  
  // ログアウト処理
  Future<void> logout() async {
    _setLoading(true);
    try {
      if (!kDebugMode) {
        await _apiService.logout();
      }
      
      // ローカルの認証情報をクリア
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('username');
      
      _currentUser = null;
      _isAuthenticated = false;
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }
  
  // ユーザープロフィール取得
  Future<void> fetchUserProfile() async {
    if (!_isAuthenticated) return;
    
    _setLoading(true);
    try {
      if (kDebugMode && !kIsWeb) {
        // 開発モードかつWebでない場合はDBから検索
        final prefs = await SharedPreferences.getInstance();
        final username = prefs.getString('username');
        
        if (username != null) {
          final db = await _dbHelper.database;
          final results = await db.query(
            'users',
            where: 'username = ?',
            whereArgs: [username],
          );
          
          if (results.isNotEmpty) {
            // SQLiteの結果をUserモデルに変換
            Map<String, dynamic> userData = Map<String, dynamic>.from(results.first);
            // UserモデルのJSONフォーマットに合わせて変換
            userData['userId'] = userData['id'] ?? 0;
            userData['displayName'] = userData['display_name'] ?? 'ユーザー';
            userData['isActive'] = userData['isActive'] ?? true;
            
            _currentUser = User.fromJson(userData);
          }
        }
      } else if (kDebugMode && kIsWeb) {
        // Webでの開発モードではダミーデータ
        final prefs = await SharedPreferences.getInstance();
        final username = prefs.getString('username');
        
        if (username == 'admin') {
          // ダミーユーザーを設定
          _currentUser = User(
            userId: 1,
            username: 'admin',
            email: 'admin@example.com',
            displayName: '管理者',
            role: 'admin',
            isActive: true,
          );
        }
      } else {
        // 本番モードではAPIを使用
        final user = await _apiService.getUserProfile();
        _currentUser = user;
      }
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }
  
  // ローディング状態の設定
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
} 