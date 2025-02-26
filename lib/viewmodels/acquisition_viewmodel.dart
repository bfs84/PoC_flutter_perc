import 'package:flutter/foundation.dart';
import '../models/acquisition_asset.dart';
import '../services/api_service.dart';

class AcquisitionViewModel with ChangeNotifier {
  final ApiService _apiService;
  
  List<AcquisitionAsset> _acquisitions = [];
  bool _isLoading = false;
  String? _error;
  
  // ゲッター
  List<AcquisitionAsset> get acquisitions => _acquisitions;
  bool get isLoading => _isLoading;
  String? get error => _error;
  
  AcquisitionViewModel(this._apiService);
  
  // 購入検討資産一覧取得
  Future<void> fetchAcquisitions() async {
    _setLoading(true);
    try {
      final result = await _apiService.getAcquisitions();
      _acquisitions = result;
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }
  
  // 購入検討資産検索
  Future<void> searchAcquisitions({
    String? keyword,
    String? category,
    String? status,
  }) async {
    _setLoading(true);
    try {
      final result = await _apiService.searchAcquisitions(
        keyword: keyword,
        category: category,
        status: status,
      );
      _acquisitions = result;
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }
  
  // 購入検討資産の追加
  Future<bool> addAcquisition(AcquisitionAsset acquisition) async {
    _setLoading(true);
    try {
      // AcquisitionAssetからMapに変換
      final acquisitionMap = acquisition.toJson();
      final result = await _apiService.createAcquisition(acquisitionMap);
      _acquisitions.add(result);
      _error = null;
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _setLoading(false);
    }
  }
  
  // 購入検討資産の更新
  Future<bool> updateAcquisition(AcquisitionAsset acquisition) async {
    _setLoading(true);
    try {
      // AcquisitionAssetからMapに変換
      final acquisitionMap = acquisition.toJson();
      final result = await _apiService.updateAcquisition(
        acquisition.acquisitionId,
        acquisitionMap
      );
      final index = _acquisitions.indexWhere(
        (a) => a.acquisitionId == acquisition.acquisitionId
      );
      if (index != -1) {
        _acquisitions[index] = result;
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
  
  // 購入検討資産の削除
  Future<bool> deleteAcquisition(int acquisitionId) async {
    _setLoading(true);
    try {
      await _apiService.deleteAcquisition(acquisitionId);
      _acquisitions.removeWhere((a) => a.acquisitionId == acquisitionId);
      _error = null;
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _setLoading(false);
    }
  }
  
  // ステータス更新（申請中→配送中→到着済など）
  Future<bool> updateAcquisitionStatus(int acquisitionId, String newStatus) async {
    _setLoading(true);
    try {
      final result = await _apiService.updateAcquisitionStatus(acquisitionId, newStatus);
      final index = _acquisitions.indexWhere((a) => a.acquisitionId == acquisitionId);
      if (index != -1) {
        _acquisitions[index] = result;
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
  
  // ローディング状態の設定
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
} 