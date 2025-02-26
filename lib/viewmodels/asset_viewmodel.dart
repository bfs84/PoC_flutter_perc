import 'package:flutter/foundation.dart';
import '../models/asset.dart';
import '../services/api_service.dart';

class AssetViewModel extends ChangeNotifier {
  final ApiService _apiService;
  
  List<Asset> _assets = [];
  bool _isLoading = false;
  String? _error;
  
  AssetViewModel(this._apiService);
  
  // ゲッター
  List<Asset> get assets => _assets;
  bool get isLoading => _isLoading;
  String? get error => _error;
  
  // 読み込み中状態の設定
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
  
  // 資産一覧取得
  Future<void> fetchAssets() async {
    _setLoading(true);
    try {
      final result = await _apiService.getAssets();
      _assets = result;
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }
  
  // 資産検索
  Future<void> searchAssets({
    String? keyword,
    String? category,
    String? status,
  }) async {
    _setLoading(true);
    try {
      final result = await _apiService.searchAssets(
        keyword: keyword,
        category: category,
        status: status,
      );
      _assets = result;
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }
  
  // 資産IDによる詳細取得
  Future<Asset?> fetchAssetById(int id) async {
    _setLoading(true);
    try {
      final result = await _apiService.getAsset(id);
      // 既存リストに無ければ追加
      if (!_assets.any((asset) => asset.assetId == id)) {
        _assets.add(result);
      }
      _error = null;
      return result;
    } catch (e) {
      _error = e.toString();
      return null;
    } finally {
      _setLoading(false);
    }
  }
  
  // 資産追加
  Future<bool> addAsset(Asset asset) async {
    _setLoading(true);
    try {
      // AssetからMapに変換
      final assetMap = asset.toJson();
      final result = await _apiService.createAsset(assetMap);
      _assets.add(result);
      _error = null;
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _setLoading(false);
    }
  }
  
  // 資産更新
  Future<bool> updateAsset(Asset asset) async {
    _setLoading(true);
    try {
      // AssetからMapに変換
      final assetMap = asset.toJson();
      final result = await _apiService.updateAsset(asset.assetId, assetMap);
      final index = _assets.indexWhere((a) => a.assetId == asset.assetId);
      if (index != -1) {
        _assets[index] = result;
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
  
  // 資産削除
  Future<bool> deleteAsset(int assetId) async {
    _setLoading(true);
    try {
      await _apiService.deleteAsset(assetId);
      _assets.removeWhere((a) => a.assetId == assetId);
      _error = null;
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _setLoading(false);
    }
  }
} 