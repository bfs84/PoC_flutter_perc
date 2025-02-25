import 'package:flutter/material.dart';
import '../models/asset.dart';

class AssetEdit extends StatefulWidget {
  final Asset asset;
  const AssetEdit({Key? key, required this.asset}) : super(key: key);

  @override
  _AssetEditState createState() => _AssetEditState();
}

class _AssetEditState extends State<AssetEdit> {
  late TextEditingController _modelController;
  late TextEditingController _codeController;
  late TextEditingController _categoryController;
  late TextEditingController _priceController;
  late TextEditingController _statusController;

  @override
  void initState() {
    super.initState();
    _modelController = TextEditingController(text: widget.asset.model);
    _codeController = TextEditingController(text: widget.asset.assetCode);
    _categoryController = TextEditingController(text: widget.asset.category);
    _priceController = TextEditingController(text: widget.asset.price.toString());
    _statusController = TextEditingController(text: widget.asset.status);
  }

  @override
  void dispose() {
    _modelController.dispose();
    _codeController.dispose();
    _categoryController.dispose();
    _priceController.dispose();
    _statusController.dispose();
    super.dispose();
  }

  void _saveEdit() {
    // TODO: 実際の更新処理を実装する
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('資産編集'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _modelController,
              decoration: const InputDecoration(labelText: 'モデル'),
            ),
            TextField(
              controller: _codeController,
              decoration: const InputDecoration(labelText: 'コード'),
            ),
            TextField(
              controller: _categoryController,
              decoration: const InputDecoration(labelText: 'カテゴリー'),
            ),
            TextField(
              controller: _priceController,
              decoration: const InputDecoration(labelText: '価格'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _statusController,
              decoration: const InputDecoration(labelText: '状態'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveEdit,
              child: const Text('保存'),
            ),
          ],
        ),
      ),
    );
  }
} 