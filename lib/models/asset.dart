class Asset {
  final int assetId;
  final String assetCode;
  final String category;
  final String model;
  final double price;
  final DateTime purchaseDate;
  final String status;

  Asset({
    required this.assetId,
    required this.assetCode,
    required this.category,
    required this.model,
    required this.price,
    required this.purchaseDate,
    required this.status,
  });

  factory Asset.fromJson(Map<String, dynamic> json) {
    return Asset(
      assetId: json['asset_id'],
      assetCode: json['asset_code'],
      category: json['category'],
      model: json['model'],
      price: (json['price'] as num).toDouble(),
      purchaseDate: DateTime.parse(json['purchase_date']),
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() => {
        'asset_id': assetId,
        'asset_code': assetCode,
        'category': category,
        'model': model,
        'price': price,
        'purchase_date': purchaseDate.toIso8601String(),
        'status': status,
      };
} 