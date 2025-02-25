import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('ホームダッシュボード'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              userProvider.logout();
              Navigator.of(context).pushReplacementNamed('/login');
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('ようこそ, ${userProvider.user?.firstName ?? 'Guest'}'),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pushNamed('/asset'),
              child: const Text('資産管理'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pushNamed('/acquisition'),
              child: const Text('購入検討資産管理'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pushNamed('/budget'),
              child: const Text('予算管理'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pushNamed('/knowledge'),
              child: const Text('ナレッジ管理'),
            ),
          ],
        ),
      ),
    );
  }
} 