import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          const DrawerHeader(
            child: Text(
              'メニュー',
              style: TextStyle(fontSize: 24, color: Colors.white),
            ),
            decoration: BoxDecoration(color: Colors.blue),
          ),
          ListTile(
            title: const Text('ホーム'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/home');
            },
          ),
          ListTile(
            title: const Text('資産管理'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/asset/list');
            },
          ),
          ListTile(
            title: const Text('購入検討資産管理'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/acquisition');
            },
          ),
          ListTile(
            title: const Text('予算管理'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/budget');
            },
          ),
          ListTile(
            title: const Text('ナレッジ管理'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/knowledge');
            },
          ),
        ],
      ),
    );
  }
} 