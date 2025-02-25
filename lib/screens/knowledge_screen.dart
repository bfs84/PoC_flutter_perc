import 'package:flutter/material.dart';

class KnowledgeScreen extends StatelessWidget {
  const KnowledgeScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // ダミーのナレッジ一覧
    return Scaffold(
      appBar: AppBar(title: const Text('ナレッジ管理')),
      body: ListView(
        children: const [
          ListTile(
            title: Text('打楽器のメンテナンス方法'),
            subtitle: Text('詳細情報…'),
          ),
          ListTile(
            title: Text('新規入団者向けマニュアル'),
            subtitle: Text('詳細情報…'),
          ),
        ],
      ),
    );
  }
} 