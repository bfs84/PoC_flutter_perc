class AcquisitionAsset {
  final int acquisitionAssetId;
  final String assetName;
  final String model;
  final String vendor;
  final double estimatedCost;
  final String calculationDetails;
  final String currency;
  final String purchaseReason;
  final String status; // pending, delivering, arrived
  final int requestedBy;
  final DateTime requestedDate;

  AcquisitionAsset({
    required this.acquisitionAssetId,
    required this.assetName,
    required this.model,
    required this.vendor,
    required this.estimatedCost,
    required this.calculationDetails,
    required this.currency,
    required this.purchaseReason,
    required this.status,
    required this.requestedBy,
    required this.requestedDate,
  });

  factory AcquisitionAsset.fromJson(Map<String, dynamic> json) {
    return AcquisitionAsset(
      acquisitionAssetId: json['acquisition_asset_id'],
      assetName: json['asset_name'],
      model: json['model'],
      vendor: json['vendor'],
      estimatedCost: (json['estimated_cost'] as num).toDouble(),
      calculationDetails: json['calculation_details'],
      currency: json['currency'],
      purchaseReason: json['purchase_reason'],
      status: json['status'],
      requestedBy: json['requested_by'],
      requestedDate: DateTime.parse(json['requested_date']),
    );
  }

  Map<String, dynamic> toJson() => {
        'acquisition_asset_id': acquisitionAssetId,
        'asset_name': assetName,
        'model': model,
        'vendor': vendor,
        'estimated_cost': estimatedCost,
        'calculation_details': calculationDetails,
        'currency': currency,
        'purchase_reason': purchaseReason,
        'status': status,
        'requested_by': requestedBy,
        'requested_date': requestedDate.toIso8601String(),
      };
} 