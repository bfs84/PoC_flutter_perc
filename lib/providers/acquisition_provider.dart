import 'package:flutter/foundation.dart';
import '../models/acquisition_asset.dart';

class AcquisitionProvider extends ChangeNotifier {
  List<AcquisitionAsset> _acquisitionAssets = [];
  List<AcquisitionAsset> get acquisitionAssets => _acquisitionAssets;

  Future<void> fetchAcquisitionAssets() async {
    await Future.delayed(const Duration(seconds: 2));
    _acquisitionAssets = [
      AcquisitionAsset(
        acquisitionAssetId: 1,
        assetName: 'Drum Set X',
        model: 'DX-100',
        vendor: 'Vendor A',
        estimatedCost: 5000.0,
        calculationDetails: 'Detailed cost breakdown',
        currency: 'JPY',
        purchaseReason: '既存資産更新',
        status: 'pending',
        requestedBy: 1,
        requestedDate: DateTime.now().subtract(const Duration(days: 5)),
      ),
    ];
    notifyListeners();
  }

  Future<void> updateAcquisitionStatus(int id, String newStatus) async {
    int index = _acquisitionAssets.indexWhere((a) => a.acquisitionAssetId == id);
    if (index != -1) {
      final asset = _acquisitionAssets[index];
      _acquisitionAssets[index] = AcquisitionAsset(
        acquisitionAssetId: asset.acquisitionAssetId,
        assetName: asset.assetName,
        model: asset.model,
        vendor: asset.vendor,
        estimatedCost: asset.estimatedCost,
        calculationDetails: asset.calculationDetails,
        currency: asset.currency,
        purchaseReason: asset.purchaseReason,
        status: newStatus,
        requestedBy: asset.requestedBy,
        requestedDate: asset.requestedDate,
      );
      notifyListeners();
    }
  }
} 