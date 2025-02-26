import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/user_viewmodel.dart';
import '../../utils/constants.dart';
import '../widgets/common/app_drawer.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    // プロフィール画面表示時にユーザー情報を取得
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserViewModel>(context, listen: false).fetchUserProfile();
    });
  }
  
  @override
  Widget build(BuildContext context) {
    final userViewModel = Provider.of<UserViewModel>(context);
    final user = userViewModel.currentUser;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('プロフィール'),
      ),
      drawer: const AppDrawer(),
      body: userViewModel.isLoading
          ? const Center(child: CircularProgressIndicator())
          : user == null
              ? const Center(child: Text('ユーザー情報が取得できませんでした'))
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // プロフィール画像と基本情報
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // プロフィール画像
                                CircleAvatar(
                                  radius: 40,
                                  backgroundColor: Colors.grey.shade200,
                                  backgroundImage: user.profileImage != null
                                      ? NetworkImage(user.profileImage!)
                                      : null,
                                  child: user.profileImage == null
                                      ? const Icon(Icons.person, size: 40)
                                      : null,
                                ),
                                
                                const SizedBox(width: 16),
                                
                                // ユーザー基本情報
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        user.displayName,
                                        style: Theme.of(context).textTheme.titleLarge,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        user.email,
                                        style: Theme.of(context).textTheme.bodyMedium,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '所属: ${user.department ?? "未設定"}',
                                        style: Theme.of(context).textTheme.bodyMedium,
                                      ),
                                      const SizedBox(height: 4),
                                      Chip(
                                        label: Text(_getRoleText(user.role)),
                                        backgroundColor: _getRoleColor(user.role),
                                        labelStyle: const TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 16),
                        
                        // アカウント詳細情報
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'アカウント情報',
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                                const Divider(),
                                const SizedBox(height: 16),
                                
                                _buildInfoRow(context, 'ユーザー名', user.username),
                                _buildInfoRow(context, '電話番号', user.phoneNumber ?? '未設定'),
                                _buildInfoRow(context, 'ステータス', user.isActive ? 'アクティブ' : '無効'),
                              ],
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 16),
                        
                        // パスワード変更ボタン
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'セキュリティ設定',
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                                const Divider(),
                                const SizedBox(height: 16),
                                
                                ElevatedButton.icon(
                                  onPressed: () {
                                    // TODO: パスワード変更画面へ
                                  },
                                  icon: const Icon(Icons.lock),
                                  label: const Text('パスワードを変更'),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }
  
  Widget _buildInfoRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
  
  String _getRoleText(String role) {
    switch (role) {
      case 'admin': return '管理者';
      case 'manager': return 'マネージャー';
      case 'user': return '一般ユーザー';
      default: return role;
    }
  }
  
  Color _getRoleColor(String role) {
    switch (role) {
      case 'admin': return Colors.red;
      case 'manager': return Colors.blue;
      case 'user': return Colors.green;
      default: return Colors.grey;
    }
  }
} 