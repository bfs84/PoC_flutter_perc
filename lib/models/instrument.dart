class Instrument {
  final List<String> ownerIds; // 所有者のID一覧
  final int quantity; // 所持数
  final String model; // モデル
  final String storageLocation; // 保管場所
  final DateTime purchaseDate; // 購入日
  final double wearDegree; // 損耗度（例：0.2=20%）
  final List<String> maintenanceHistory; // メンテナンス履歴

  Instrument({
    required this.ownerIds,
    required this.quantity,
    required this.model,
    required this.storageLocation,
    required this.purchaseDate,
    required this.wearDegree,
    required this.maintenanceHistory,
  });

  // 最後のメンテナンス日（履歴の最新レコードの日付）を返す
  DateTime? get lastMaintenanceDate {
    if (maintenanceHistory.isEmpty) return null;
    try {
      // "YYYY-MM-DD: ..." フォーマットと仮定
      return DateTime.parse(maintenanceHistory.last.split(':').first);
    } catch (e) {
      return null;
    }
  }
} 