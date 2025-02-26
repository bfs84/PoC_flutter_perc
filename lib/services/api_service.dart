import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/asset.dart';
import '../models/user.dart';
import '../models/acquisition_asset.dart';
import '../models/knowledge.dart';
import '../utils/constants.dart';

class ApiService {
  final String baseUrl = AppConstants.apiBaseUrl;
  String? _authToken;
  
  // =========== 認証 API ===========
  
  /// ログイン
  Future<User> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'username': username,
        'password': password,
      }),
    );
    
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      _authToken = data['token'];
      return User.fromJson(data['user']);
    } else {
      throw Exception('ログインに失敗しました: ${response.statusCode}');
    }
  }
  
  /// ログアウト
  Future<void> logout() async {
    if (_authToken != null) {
      await http.post(
        Uri.parse('$baseUrl/auth/logout'),
        headers: {'Authorization': 'Bearer $_authToken'},
      );
      _authToken = null;
    }
  }
  
  /// ユーザープロフィール取得
  Future<User> getUserProfile() async {
    final response = await http.get(
      Uri.parse('$baseUrl/users/profile'),
      headers: {'Authorization': 'Bearer $_authToken'},
    );
    
    if (response.statusCode == 200) {
      return User.fromJson(json.decode(response.body));
    } else {
      throw Exception('プロフィール取得に失敗しました: ${response.statusCode}');
    }
  }
  
  // =========== 資産 API ===========
  
  /// 資産一覧取得
  Future<List<Asset>> getAssets() async {
    final response = await http.get(
      Uri.parse('$baseUrl/assets'),
      headers: {'Authorization': 'Bearer $_authToken'},
    );
    
    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((item) => Asset.fromJson(item)).toList();
    } else {
      throw Exception('資産一覧の取得に失敗しました: ${response.statusCode}');
    }
  }
  
  /// 資産検索
  Future<List<Asset>> searchAssets({
    String? keyword,
    String? category,
    String? status,
    String? degradation,
  }) async {
    final queryParams = <String, String>{};
    if (keyword != null) queryParams['q'] = keyword;
    if (category != null) queryParams['category'] = category;
    if (status != null) queryParams['status'] = status;
    if (degradation != null) queryParams['degradation'] = degradation;
    
    final uri = Uri.parse('$baseUrl/assets').replace(queryParameters: queryParams);
    final response = await http.get(
      uri,
      headers: {'Authorization': 'Bearer $_authToken'},
    );
    
    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((item) => Asset.fromJson(item)).toList();
    } else {
      throw Exception('資産検索に失敗しました: ${response.statusCode}');
    }
  }
  
  /// 資産作成
  Future<Asset> createAsset(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/assets'),
      headers: {
        'Authorization': 'Bearer $_authToken',
        'Content-Type': 'application/json',
      },
      body: json.encode(data),
    );
    
    if (response.statusCode == 201) {
      return Asset.fromJson(json.decode(response.body));
    } else {
      throw Exception('資産作成に失敗しました: ${response.statusCode}');
    }
  }
  
  /// 資産更新
  Future<Asset> updateAsset(int id, Map<String, dynamic> data) async {
    final response = await http.put(
      Uri.parse('$baseUrl/assets/$id'),
      headers: {
        'Authorization': 'Bearer $_authToken',
        'Content-Type': 'application/json',
      },
      body: json.encode(data),
    );
    
    if (response.statusCode == 200) {
      return Asset.fromJson(json.decode(response.body));
    } else {
      throw Exception('資産更新に失敗しました: ${response.statusCode}');
    }
  }
  
  /// 資産削除
  Future<void> deleteAsset(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/assets/$id'),
      headers: {'Authorization': 'Bearer $_authToken'},
    );
    
    if (response.statusCode != 204) {
      throw Exception('資産削除に失敗しました: ${response.statusCode}');
    }
  }
  
  /// 資産詳細取得
  Future<Asset> getAsset(int id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/assets/$id'),
      headers: {'Authorization': 'Bearer $_authToken'},
    );
    
    if (response.statusCode == 200) {
      return Asset.fromJson(json.decode(response.body));
    } else {
      throw Exception('資産詳細の取得に失敗しました: ${response.statusCode}');
    }
  }
  
  // =========== 購入検討資産 API ===========
  
  /// 購入検討資産一覧取得
  Future<List<AcquisitionAsset>> getAcquisitions() async {
    final response = await http.get(
      Uri.parse('$baseUrl/acquisitions'),
      headers: {'Authorization': 'Bearer $_authToken'},
    );
    
    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((item) => AcquisitionAsset.fromJson(item)).toList();
    } else {
      throw Exception('購入検討資産一覧の取得に失敗しました: ${response.statusCode}');
    }
  }
  
  /// 購入検討資産検索
  Future<List<AcquisitionAsset>> searchAcquisitions({
    String? keyword,
    String? category,
    String? status,
  }) async {
    final queryParams = <String, String>{};
    if (keyword != null) queryParams['q'] = keyword;
    if (category != null) queryParams['category'] = category;
    if (status != null) queryParams['status'] = status;
    
    final uri = Uri.parse('$baseUrl/acquisitions').replace(queryParameters: queryParams);
    final response = await http.get(
      uri,
      headers: {'Authorization': 'Bearer $_authToken'},
    );
    
    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((item) => AcquisitionAsset.fromJson(item)).toList();
    } else {
      throw Exception('購入検討資産検索に失敗しました: ${response.statusCode}');
    }
  }
  
  /// 購入検討資産作成
  Future<AcquisitionAsset> createAcquisition(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/acquisitions'),
      headers: {
        'Authorization': 'Bearer $_authToken',
        'Content-Type': 'application/json',
      },
      body: json.encode(data),
    );
    
    if (response.statusCode == 201) {
      return AcquisitionAsset.fromJson(json.decode(response.body));
    } else {
      throw Exception('購入検討資産作成に失敗しました: ${response.statusCode}');
    }
  }
  
  /// 購入検討資産更新
  Future<AcquisitionAsset> updateAcquisition(int id, Map<String, dynamic> data) async {
    final response = await http.put(
      Uri.parse('$baseUrl/acquisitions/$id'),
      headers: {
        'Authorization': 'Bearer $_authToken',
        'Content-Type': 'application/json',
      },
      body: json.encode(data),
    );
    
    if (response.statusCode == 200) {
      return AcquisitionAsset.fromJson(json.decode(response.body));
    } else {
      throw Exception('購入検討資産更新に失敗しました: ${response.statusCode}');
    }
  }
  
  /// 購入検討資産削除
  Future<void> deleteAcquisition(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/acquisitions/$id'),
      headers: {'Authorization': 'Bearer $_authToken'},
    );
    
    if (response.statusCode != 204) {
      throw Exception('購入検討資産削除に失敗しました: ${response.statusCode}');
    }
  }
  
  /// 購入検討資産のステータス更新
  Future<AcquisitionAsset> updateAcquisitionStatus(int id, String newStatus) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/acquisitions/$id/status'),
      headers: {
        'Authorization': 'Bearer $_authToken', 
        'Content-Type': 'application/json'
      },
      body: json.encode({'status': newStatus}),
    );
    
    if (response.statusCode == 200) {
      return AcquisitionAsset.fromJson(json.decode(response.body));
    } else {
      throw Exception('ステータス更新に失敗しました: ${response.statusCode}');
    }
  }
  
  // =========== ナレッジ API ===========
  
  /// ナレッジ一覧取得
  Future<List<Knowledge>> getKnowledgeItems() async {
    final response = await http.get(
      Uri.parse('$baseUrl/knowledge'),
      headers: {'Authorization': 'Bearer $_authToken'},
    );
    
    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((item) => Knowledge.fromJson(item)).toList();
    } else {
      throw Exception('ナレッジ一覧の取得に失敗しました: ${response.statusCode}');
    }
  }
  
  /// ナレッジ検索
  Future<List<Knowledge>> searchKnowledge({
    String? keyword,
    String? category,
    List<String>? tags,
  }) async {
    final queryParams = <String, String>{};
    if (keyword != null) queryParams['q'] = keyword;
    if (category != null) queryParams['category'] = category;
    if (tags != null) queryParams['tags'] = tags.join(',');
    
    final uri = Uri.parse('$baseUrl/knowledge').replace(queryParameters: queryParams);
    final response = await http.get(
      uri,
      headers: {'Authorization': 'Bearer $_authToken'},
    );
    
    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((item) => Knowledge.fromJson(item)).toList();
    } else {
      throw Exception('ナレッジ検索に失敗しました: ${response.statusCode}');
    }
  }
  
  /// ナレッジ詳細取得
  Future<Knowledge> getKnowledgeItem(int id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/knowledge/$id'),
      headers: {'Authorization': 'Bearer $_authToken'},
    );
    
    if (response.statusCode == 200) {
      return Knowledge.fromJson(json.decode(response.body));
    } else {
      throw Exception('ナレッジ詳細の取得に失敗しました: ${response.statusCode}');
    }
  }
  
  /// ナレッジ作成
  Future<Knowledge> createKnowledge(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/knowledge'),
      headers: {
        'Authorization': 'Bearer $_authToken',
        'Content-Type': 'application/json',
      },
      body: json.encode(data),
    );
    
    if (response.statusCode == 201) {
      return Knowledge.fromJson(json.decode(response.body));
    } else {
      throw Exception('ナレッジ作成に失敗しました: ${response.statusCode}');
    }
  }
  
  /// ナレッジ更新
  Future<Knowledge> updateKnowledge(int id, Map<String, dynamic> data) async {
    final response = await http.put(
      Uri.parse('$baseUrl/knowledge/$id'),
      headers: {
        'Authorization': 'Bearer $_authToken',
        'Content-Type': 'application/json',
      },
      body: json.encode(data),
    );
    
    if (response.statusCode == 200) {
      return Knowledge.fromJson(json.decode(response.body));
    } else {
      throw Exception('ナレッジ更新に失敗しました: ${response.statusCode}');
    }
  }
  
  /// ナレッジ削除
  Future<void> deleteKnowledge(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/knowledge/$id'),
      headers: {'Authorization': 'Bearer $_authToken'},
    );
    
    if (response.statusCode != 204) {
      throw Exception('ナレッジ削除に失敗しました: ${response.statusCode}');
    }
  }
  
  /// ナレッジ公開状態更新
  Future<Knowledge> updateKnowledgePublishStatus(int id, bool isPublished) async {
    final status = isPublished ? 'published' : 'draft';
    
    final response = await http.patch(
      Uri.parse('$baseUrl/knowledge/$id/publish-status'),
      headers: {
        'Authorization': 'Bearer $_authToken',
        'Content-Type': 'application/json',
      },
      body: json.encode({'publishStatus': status}),
    );
    
    if (response.statusCode == 200) {
      return Knowledge.fromJson(json.decode(response.body));
    } else {
      throw Exception('ナレッジ公開状態の更新に失敗しました: ${response.statusCode}');
    }
  }
} 