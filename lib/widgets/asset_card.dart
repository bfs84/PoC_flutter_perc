import 'package:flutter/material.dart';
import '../models/asset.dart';

class AssetCard extends StatelessWidget {
  final Asset asset;
  const AssetCard(this.asset, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(asset.model),
        subtitle: Text('コード: ${asset.assetCode} - 価格: ${asset.price}'),
      ),
    );
  }
} 