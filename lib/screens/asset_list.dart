import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/asset_provider.dart';
import '../models/asset.dart';
import 'asset_edit.dart';

class AssetList extends StatefulWidget {
  const AssetList({Key? key}) : super(key: key);
  
  @override
  _AssetListState createState() => _AssetListState();
}

class _AssetListState extends State<AssetList> {
  @override
  void initState() {
    super.initState();
    // 遅延呼び出しで context の問題を避ける場合はこちらに変更も可
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AssetProvider>(context, listen: false).fetchAssets();
    });
  }
  
  @override
  Widget build(BuildContext context) {
    final assetProvider = Provider.of<AssetProvider>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('資産一覧')),
      body: assetProvider.assets.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: assetProvider.assets.length,
              itemBuilder: (context, index) {
                final asset = assetProvider.assets[index];
                return ListTile(
                  title: Text(asset.model),
                  subtitle: Text('コード: ${asset.assetCode}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      // asset_edit 画面へ遷移
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => AssetEdit(asset: asset),
                      ));
                    },
                  ),
                );
              },
            ),
    );
  }
} 