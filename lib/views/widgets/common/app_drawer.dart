import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../viewmodels/user_viewmodel.dart';
import '../../../utils/constants.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final userViewModel = Provider.of<UserViewModel>(context);
    final user = userViewModel.currentUser;
    
    return Drawer(
      child: Column(
        children: [
          // ユーザー情報ヘッダー
          UserAccountsDrawerHeader(
            accountName: Text(user?.displayName ?? 'ゲスト'),
            accountEmail: Text(user?.email ?? ''),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              backgroundImage: user?.profileImage != null
                  ? NetworkImage(user!.profileImage!)
                  : null,
              child: user?.profileImage == null
                  ? const Icon(Icons.person, size: 40)
                  : null,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
          ),
          
          // メニュー項目
          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text('ダッシュボード'),
            onTap: () {
              Navigator.pop(context); // ドロワーを閉じる
              if (ModalRoute.of(context)?.settings.name != AppConstants.homePath) {
                Navigator.pushReplacementNamed(context, AppConstants.homePath);
              }
            },
          ),
          
          ListTile(
            leading: const Icon(Icons.inventory),
            title: const Text('資産管理'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, AppConstants.assetsPath);
            },
          ),
          
          ListTile(
            leading: const Icon(Icons.shopping_cart),
            title: const Text('購入検討管理'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, AppConstants.acquisitionsPath);
            },
          ),
          
          ListTile(
            leading: const Icon(Icons.book),
            title: const Text('ナレッジ管理'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, AppConstants.knowledgePath);
            },
          ),
          
          const Divider(),
          
          // 管理者向けメニュー
          if (user?.role == 'admin')
            ListTile(
              leading: const Icon(Icons.admin_panel_settings),
              title: const Text('管理者設定'),
              onTap: () {
                Navigator.pop(context);
                // TODO: 管理者設定画面へのナビゲーション
              },
            ),
          
          // プロフィール&ログアウト
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('プロフィール'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, AppConstants.profilePath);
            },
          ),
          
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('ログアウト'),
            onTap: () async {
              Navigator.pop(context);
              await userViewModel.logout();
              Navigator.pushReplacementNamed(context, AppConstants.loginPath);
            },
          ),
        ],
      ),
    );
  }
} 