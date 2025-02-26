import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../viewmodels/asset_viewmodel.dart';
import '../../../viewmodels/user_viewmodel.dart';
import '../../../models/asset.dart';
import '../../widgets/common/form_builder.dart';

class AssetFormScreen extends StatefulWidget {
  final int? assetId;
  
  const AssetFormScreen({Key? key, this.assetId}) : super(key: key);

  @override
  _AssetFormScreenState createState() => _AssetFormScreenState();
}

class _AssetFormScreenState extends State<AssetFormScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // フォームコントローラー
  final _assetCodeController = TextEditingController();
  final _modelController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _storageLocationController = TextEditingController();
  final _worknotesController = TextEditingController();
  
  // ドロップダウン用の状態変数
  String _selectedCategory = 'ティンパニ';
  String _selectedStatus = 'active';
  String _selectedDegradation = 'good';
  DateTime _purchaseDate = DateTime.now();
  DateTime? _lastMaintenanceDate;
  
  bool _isEditing = false;
  Asset? _originalAsset;
  
  @override
  void initState() {
    super.initState();
    _isEditing = widget.assetId != null;
    
    if (_isEditing) {
      // 編集モードの場合、既存データを取得
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _loadAssetForEditing();
      });
    }
  }
  
  @override
  void dispose() {
    _assetCodeController.dispose();
    _modelController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _storageLocationController.dispose();
    _worknotesController.dispose();
    super.dispose();
  }
  
  // 編集対象の資産データを取得
  Future<void> _loadAssetForEditing() async {
    final assetViewModel = Provider.of<AssetViewModel>(context, listen: false);
    
    if (widget.assetId != null) {
      // 一覧データから検索
      Asset? assetNullable = assetViewModel.assets
          .where((a) => a.assetId == widget.assetId)
          .toList()
          .firstOrNull;
      
      // 見つからない場合は取得
      if (assetNullable == null) {
        await assetViewModel.fetchAssetById(widget.assetId!);
        assetNullable = assetViewModel.assets
          .where((a) => a.assetId == widget.assetId)
          .toList()
          .firstOrNull;
      }
      
      if (assetNullable != null) {
        // nullでない変数を作成して型を確定させる
        final asset = assetNullable;
        setState(() {
          _originalAsset = asset;
          
          // フォームに値をセット - null安全な方法で
          _assetCodeController.text = asset.assetCode;
          _modelController.text = asset.model;
          _priceController.text = asset.price.toString();
          _descriptionController.text = asset.description ?? '';
          _storageLocationController.text = asset.storageLocation ?? '';
          _worknotesController.text = asset.worknotes ?? '';
          
          _selectedCategory = asset.category;
          _selectedStatus = asset.status;
          
          // degradationをStringに変換
          _selectedDegradation = asset.degradation != null 
              ? asset.degradation.toString() 
              : 'good';
          
          _purchaseDate = asset.purchaseDate ?? DateTime.now();
          _lastMaintenanceDate = asset.lastMaintenanceDate;
        });
      }
    }
  }
  
  // 保存処理
  Future<void> _handleSave() async {
    if (_formKey.currentState?.validate() ?? false) {
      final assetViewModel = Provider.of<AssetViewModel>(context, listen: false);
      final userViewModel = Provider.of<UserViewModel>(context, listen: false);
      
      // 価格を数値に変換
      final price = double.tryParse(_priceController.text) ?? 0.0;
      
      // 資産オブジェクトを作成
      final asset = Asset(
        assetId: _isEditing ? _originalAsset!.assetId : 0,
        assetCode: _assetCodeController.text,
        model: _modelController.text,
        category: _selectedCategory,
        price: price,
        purchaseDate: _purchaseDate,
        status: _selectedStatus,
        degradation: int.tryParse(_selectedDegradation) ?? 0,  // 文字列から数値への変換
        description: _descriptionController.text.isNotEmpty ? _descriptionController.text : null,
        storageLocation: _storageLocationController.text.isNotEmpty ? _storageLocationController.text : null,
        worknotes: _worknotesController.text.isNotEmpty ? _worknotesController.text : null,
        lastMaintenanceDate: _lastMaintenanceDate,
        ownerId: userViewModel.currentUser?.userId,
        owner: userViewModel.currentUser,
        id: _isEditing ? _originalAsset!.id : null,
        createdAt: _isEditing ? _originalAsset!.createdAt : null,
        updatedAt: _isEditing ? DateTime.now() : null,
      );
      
      bool success;
      if (_isEditing) {
        success = await assetViewModel.updateAsset(asset);
      } else {
        success = await assetViewModel.addAsset(asset);
      }
      
      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_isEditing ? '資産情報を更新しました' : '新しい資産を登録しました')),
        );
        Navigator.pop(context);
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(assetViewModel.error ?? '保存に失敗しました'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final assetViewModel = Provider.of<AssetViewModel>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? '資産の編集' : '新規資産登録'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: AssetManagementFormBuilder(
            title: _isEditing ? '資産の編集' : '新規資産登録',
            isLoading: assetViewModel.isLoading,
            onSave: _handleSave,
            onCancel: () => Navigator.pop(context),
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    // 基本情報
                    Text(
                      '基本情報',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),
                    
                    // 資産コード
                    TextFormField(
                      controller: _assetCodeController,
                      decoration: const InputDecoration(
                        labelText: '資産コード *',
                        hintText: 'TMP-001',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '資産コードを入力してください';
                        }
                        return null;
                      },
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // モデル名
                    TextFormField(
                      controller: _modelController,
                      decoration: const InputDecoration(
                        labelText: 'モデル *',
                        hintText: 'ヤマハ TP-6300',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'モデル名を入力してください';
                        }
                        return null;
                      },
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // カテゴリ
                    DropdownButtonFormField<String>(
                      value: _selectedCategory,
                      decoration: const InputDecoration(
                        labelText: 'カテゴリ *',
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'ティンパニ',
                          child: Text('ティンパニ'),
                        ),
                        DropdownMenuItem(
                          value: 'マリンバ',
                          child: Text('マリンバ'),
                        ),
                        DropdownMenuItem(
                          value: 'シロフォン',
                          child: Text('シロフォン'),
                        ),
                        DropdownMenuItem(
                          value: 'ドラム',
                          child: Text('ドラム'),
                        ),
                        DropdownMenuItem(
                          value: 'シンバル',
                          child: Text('シンバル'),
                        ),
                        DropdownMenuItem(
                          value: 'トライアングル',
                          child: Text('トライアングル'),
                        ),
                        DropdownMenuItem(
                          value: 'タンバリン',
                          child: Text('タンバリン'),
                        ),
                        DropdownMenuItem(
                          value: 'その他',
                          child: Text('その他'),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _selectedCategory = value;
                          });
                        }
                      },
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // 価格
                    TextFormField(
                      controller: _priceController,
                      decoration: const InputDecoration(
                        labelText: '価格 *',
                        hintText: '1000000',
                        prefixText: '¥ ',
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '価格を入力してください';
                        }
                        if (double.tryParse(value) == null) {
                          return '有効な数値を入力してください';
                        }
                        return null;
                      },
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // 購入日
                    InkWell(
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: _purchaseDate,
                          firstDate: DateTime(2000),
                          lastDate: DateTime.now(),
                        );
                        if (date != null) {
                          setState(() {
                            _purchaseDate = date;
                          });
                        }
                      },
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: '購入日 *',
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(DateFormat('yyyy年MM月dd日').format(_purchaseDate)),
                            const Icon(Icons.calendar_today),
                          ],
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // 状態
                    DropdownButtonFormField<String>(
                      value: _selectedDegradation,
                      decoration: const InputDecoration(
                        labelText: '状態',
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'good',
                          child: Text('良好'),
                        ),
                        DropdownMenuItem(
                          value: 'fair',
                          child: Text('普通'),
                        ),
                        DropdownMenuItem(
                          value: 'poor',
                          child: Text('劣化'),
                        ),
                        DropdownMenuItem(
                          value: 'critical',
                          child: Text('重度の劣化'),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _selectedDegradation = value;
                          });
                        }
                      },
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // ステータス
                    DropdownButtonFormField<String>(
                      value: _selectedStatus,
                      decoration: const InputDecoration(
                        labelText: 'ステータス',
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'active',
                          child: Text('使用中'),
                        ),
                        DropdownMenuItem(
                          value: 'maintenance',
                          child: Text('メンテナンス中'),
                        ),
                        DropdownMenuItem(
                          value: 'retired',
                          child: Text('廃棄済み'),
                        ),
                        DropdownMenuItem(
                          value: 'lost',
                          child: Text('紛失'),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _selectedStatus = value;
                          });
                        }
                      },
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // 最終メンテナンス日
                    InkWell(
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: _lastMaintenanceDate ?? DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime.now(),
                        );
                        if (date != null) {
                          setState(() {
                            _lastMaintenanceDate = date;
                          });
                        }
                      },
                      child: InputDecorator(
                        decoration: InputDecoration(
                          labelText: '最終メンテナンス日',
                          suffixIcon: _lastMaintenanceDate != null 
                              ? IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: () {
                                    setState(() {
                                      _lastMaintenanceDate = null;
                                    });
                                  },
                                )
                              : null,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(_lastMaintenanceDate != null 
                                ? DateFormat('yyyy年MM月dd日').format(_lastMaintenanceDate!)
                                : '設定なし'),
                            const Icon(Icons.calendar_today),
                          ],
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // 保管場所
                    TextFormField(
                      controller: _storageLocationController,
                      decoration: const InputDecoration(
                        labelText: '保管場所',
                        hintText: '第2練習室',
                      ),
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // 追加情報
                    Text(
                      '追加情報',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),
                    
                    // 説明
                    TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        labelText: '説明',
                        hintText: '資産の詳細説明...',
                      ),
                      maxLines: 3,
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // 作業メモ
                    TextFormField(
                      controller: _worknotesController,
                      decoration: const InputDecoration(
                        labelText: '作業メモ',
                        hintText: 'メンテナンス履歴などの作業記録...',
                      ),
                      maxLines: 5,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Dart 2.xでのnullableリスト拡張（firstOrNull）
extension ListExtension<T> on List<T> {
  T? get firstOrNull => isEmpty ? null : first;
} 