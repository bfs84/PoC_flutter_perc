import 'package:flutter/foundation.dart';
import '../models/knowledge.dart';
import '../services/api_service.dart';

class KnowledgeViewModel with ChangeNotifier {
  final ApiService _apiService;
  
  List<Knowledge> _knowledgeItems = [];
  Knowledge? _selectedItem;
  bool _isLoading = false;
  String? _error;
  
  // ゲッター
  List<Knowledge> get knowledgeItems => _knowledgeItems;
  Knowledge? get selectedItem => _selectedItem;
  bool get isLoading => _isLoading;
  String? get error => _error;
  
  KnowledgeViewModel(this._apiService);
  
  // ナレッジ一覧取得
  Future<void> fetchKnowledgeItems() async {
    _setLoading(true);
    try {
      final result = await _apiService.getKnowledgeItems();
      _knowledgeItems = result;
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }
  
  // 特定のナレッジ記事を取得
  Future<void> fetchKnowledgeItem(int knowledgeId) async {
    _setLoading(true);
    try {
      final result = await _apiService.getKnowledgeItem(knowledgeId);
      _selectedItem = result;
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }
  
  // ナレッジの検索
  Future<void> searchKnowledge({
    String? keyword,
    String? category,
    List<String>? tags,
  }) async {
    _setLoading(true);
    try {
      final result = await _apiService.searchKnowledge(
        keyword: keyword,
        category: category,
        tags: tags,
      );
      _knowledgeItems = result;
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }
  
  // ナレッジの作成
  Future<bool> createKnowledge(Knowledge knowledge) async {
    _setLoading(true);
    try {
      // KnowledgeからMapに変換
      final knowledgeMap = knowledge.toJson();
      final result = await _apiService.createKnowledge(knowledgeMap);
      _knowledgeItems.add(result);
      _error = null;
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _setLoading(false);
    }
  }
  
  // ナレッジの更新
  Future<bool> updateKnowledge(Knowledge knowledge) async {
    _setLoading(true);
    try {
      // KnowledgeからMapに変換
      final knowledgeMap = knowledge.toJson();
      final result = await _apiService.updateKnowledge(
        knowledge.knowledgeId,
        knowledgeMap
      );
      final index = _knowledgeItems.indexWhere(
        (k) => k.knowledgeId == knowledge.knowledgeId
      );
      if (index != -1) {
        _knowledgeItems[index] = result;
      }
      if (_selectedItem?.knowledgeId == knowledge.knowledgeId) {
        _selectedItem = result;
      }
      _error = null;
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _setLoading(false);
    }
  }
  
  // ナレッジの削除
  Future<bool> deleteKnowledge(int knowledgeId) async {
    _setLoading(true);
    try {
      await _apiService.deleteKnowledge(knowledgeId);
      _knowledgeItems.removeWhere((k) => k.knowledgeId == knowledgeId);
      if (_selectedItem?.knowledgeId == knowledgeId) {
        _selectedItem = null;
      }
      _error = null;
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _setLoading(false);
    }
  }
  
  // 公開/非公開の切り替え
  Future<bool> togglePublished(int knowledgeId, bool isPublished) async {
    _setLoading(true);
    try {
      final result = await _apiService.updateKnowledgePublishStatus(knowledgeId, isPublished);
      final index = _knowledgeItems.indexWhere((k) => k.knowledgeId == knowledgeId);
      if (index != -1) {
        _knowledgeItems[index] = result;
      }
      if (_selectedItem?.knowledgeId == knowledgeId) {
        _selectedItem = result;
      }
      _error = null;
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _setLoading(false);
    }
  }
  
  // ナレッジ追加
  Future<bool> addKnowledge(Knowledge knowledge) async {
    _setLoading(true);
    try {
      // KnowledgeからMapに変換
      final knowledgeMap = knowledge.toJson();
      final result = await _apiService.createKnowledge(knowledgeMap);
      _knowledgeItems.add(result);
      _error = null;
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _setLoading(false);
    }
  }
  
  // 公開状態更新
  Future<bool> updateKnowledgePublishStatus(int knowledgeId, bool isPublished) async {
    _setLoading(true);
    try {
      // APIメソッドを追加（未実装の場合は実装してください）
      final status = isPublished ? 'published' : 'draft';
      final knowledge = _knowledgeItems.firstWhere((k) => k.knowledgeId == knowledgeId);
      final updatedKnowledge = knowledge.copyWith(publishStatus: status);
      
      return await updateKnowledge(updatedKnowledge);
    } catch (e) {
      _error = e.toString();
      return false;
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