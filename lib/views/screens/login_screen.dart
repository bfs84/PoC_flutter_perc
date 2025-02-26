import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/user_viewmodel.dart';
import '../../utils/constants.dart';
import '../../utils/theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  
  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
  
  // ログイン処理
  Future<void> _handleLogin() async {
    if (_formKey.currentState?.validate() ?? false) {
      final userViewModel = Provider.of<UserViewModel>(context, listen: false);
      
      final success = await userViewModel.login(
        _usernameController.text,
        _passwordController.text,
      );
      
      if (success) {
        // ログイン成功時はダッシュボードへ遷移
        Navigator.pushReplacementNamed(context, AppConstants.homePath);
      } else {
        // エラーメッセージを表示
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(userViewModel.error ?? 'ログインに失敗しました'),
              backgroundColor: AppTheme.errorColor,
            ),
          );
        }
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final userViewModel = Provider.of<UserViewModel>(context);
    
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Card(
            margin: const EdgeInsets.all(32.0),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // アプリロゴやタイトル
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Text(
                        AppConstants.appName,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // ユーザー名入力
                    TextFormField(
                      controller: _usernameController,
                      decoration: const InputDecoration(
                        labelText: 'ユーザー名',
                        prefixIcon: Icon(Icons.person),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'ユーザー名を入力してください';
                        }
                        return null;
                      },
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // パスワード入力
                    TextFormField(
                      controller: _passwordController,
                      obscureText: !_isPasswordVisible,
                      decoration: InputDecoration(
                        labelText: 'パスワード',
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'パスワードを入力してください';
                        }
                        return null;
                      },
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // ログインボタン
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: userViewModel.isLoading
                            ? null
                            : _handleLogin,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          child: userViewModel.isLoading
                              ? const CircularProgressIndicator(color: Colors.white)
                              : const Text('ログイン'),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // エラーメッセージ
                    if (userViewModel.error != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          userViewModel.error!,
                          style: TextStyle(color: AppTheme.errorColor),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
} 