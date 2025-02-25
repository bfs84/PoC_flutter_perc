import 'package:flutter/foundation.dart';
import '../models/asset.dart';

class AssetProvider extends ChangeNotifier {
  List<Asset> _assets = [];
  List<Asset> get assets => _assets;

  Future<void> fetchAssets() async {
    // ダミーのAPI通信シミュレーション
    await Future.delayed(const Duration(seconds: 2));
    _assets = [
      Asset(
        assetId: 1,
        assetCode: 'A001',
        category: '打楽器',
        model: 'Model X',
        price: 1000.0,
        purchaseDate: DateTime.now().subtract(const Duration(days: 365)),
        status: 'active',
      ),
      Asset(
        assetId: 2,
        assetCode: 'A002',
        category: '打楽器',
        model: 'Model Y',
        price: 1500.0,
        purchaseDate: DateTime.now().subtract(const Duration(days: 200)),
        status: 'maintenance',
      ),
    ];
    notifyListeners();
  }
} 