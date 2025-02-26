import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../viewmodels/acquisition_viewmodel.dart';
import '../../../viewmodels/user_viewmodel.dart';
import '../../../models/acquisition_asset.dart';
import '../../widgets/common/form_builder.dart';

class AcquisitionFormScreen extends StatefulWidget {
  final int? acquisitionId;
  
  const AcquisitionFormScreen({Key? key, this.acquisitionId}) : super(key: key);

  @override
  _AcquisitionFormScreenState createState() => _AcquisitionFormScreenState();
}

class _AcquisitionFormScreenState extends State<AcquisitionFormScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // フォームコントローラー
  final _assetCodeController = TextEditingController();
  final _modelController = TextEditingController();
  final _priceController = TextEditingController();
  final _reasonController = TextEditingController();
  final _descriptionController = TextEditingController();
  
  // ドロップダウン用の状態変数
  String _selectedCategory = 'ティンパニ';
  String _selectedCurrency = 'JPY';
  DateTime? _requestedDate = DateTime.now();
  int _fiscalYear = DateTime.now().year;
  
  bool _isEditing = false;
  AcquisitionAsset? _originalAcquisition;
  
  @override
  void initState() {
    super.initState();
    _isEditing = widget.acquisitionId != null;
    
    if (_isEditing) {
      // 編集モードの場合、既存データを取得
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _loadAcquisitionForEditing();
      });
    }
  }
  
  @override
  void dispose() {
    _assetCodeController.dispose();
    _modelController.dispose();
    _priceController.dispose();
    _reasonController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
  
  // 編集対象の購入検討資産データを取得
  Future<void> _loadAcquisitionForEditing() async {
    final viewModel = Provider.of<AcquisitionViewModel>(context, listen: false);
    
    if (widget.acquisitionId != null) {
      // 一覧データから検索
      AcquisitionAsset? acquisitionNullable = viewModel.acquisitions
          .where((a) => a.acquisitionId == widget.acquisitionId)
          .toList()
          .firstOrNull;
      
      // 見つからない場合は取得
      if (acquisitionNullable == null) {
        // TODO: 詳細取得APIの実装後修正
        await viewModel.fetchAcquisitions(); // 全件取得でリフレッシュ (暫定)
        acquisitionNullable = viewModel.acquisitions
          .where((a) => a.acquisitionId == widget.acquisitionId)
          .toList()
          .firstOrNull;
      }
      
      if (acquisitionNullable != null) {
        // nullでない場合は別の変数に格納して型を確定
        final acquisition = acquisitionNullable;
        setState(() {
          _originalAcquisition = acquisition;
          
          // フォームに値をセット - null安全な方法で
          _assetCodeController.text = acquisition.assetCode;
          _modelController.text = acquisition.model;
          _priceController.text = acquisition.price.toString();
          _selectedCategory = acquisition.category;
          _selectedCurrency = acquisition.currency;
          
          // null安全な方法で値を設定
          _reasonController.text = acquisition.purchaseReason ?? '';
          _descriptionController.text = acquisition.description ?? '';
          
          // null合体演算子を使用して安全に値を取得
          _requestedDate = acquisition.requestedDate ?? DateTime.now();
          _fiscalYear = acquisition.fiscalYear ?? DateTime.now().year;
        });
      }
    }
  }
  
  // 保存処理
  Future<void> _handleSave() async {
    if (_formKey.currentState?.validate() ?? false) {
      final viewModel = Provider.of<AcquisitionViewModel>(context, listen: false);
      final userViewModel = Provider.of<UserViewModel>(context, listen: false);
      
      // 入力データを収集
      final acquisitionData = AcquisitionAsset(
        acquisitionId: _isEditing ? _originalAcquisition!.acquisitionId : 0, // 新規の場合はサーバーで割り当て
        assetCode: _assetCodeController.text,
        category: _selectedCategory,
        model: _modelController.text,
        price: double.tryParse(_priceController.text) ?? 0,
        currency: _selectedCurrency,
        purchaseReason: _reasonController.text.isNotEmpty ? _reasonController.text : null,
        status: _isEditing ? _originalAcquisition!.status : 'pending', // 新規は申請中
        requestedById: userViewModel.currentUser?.userId,
        requestedBy: userViewModel.currentUser,
        requestedDate: _requestedDate,
        description: _descriptionController.text.isNotEmpty ? _descriptionController.text : null,
        fiscalYear: _fiscalYear,
        id: _isEditing ? _originalAcquisition!.id : null,
        createdAt: _isEditing ? _originalAcquisition!.createdAt : DateTime.now(),
        updatedAt: DateTime.now(),
      );
      
      bool success;
      if (_isEditing) {
        // 更新処理
        success = await viewModel.updateAcquisition(acquisitionData);
      } else {
        // 新規作成
        success = await viewModel.addAcquisition(acquisitionData);
      }
      
      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_isEditing ? '購入検討資産を更新しました' : '購入検討資産を登録しました')),
        );
        // 一覧画面に戻る
        Navigator.pop(context);
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(viewModel.error ?? '保存に失敗しました'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<AcquisitionViewModel>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? '購入検討資産の編集' : '購入検討資産の登録'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: AssetManagementFormBuilder(
            title: _isEditing ? '購入検討資産の編集' : '購入検討資産の登録',
            isLoading: viewModel.isLoading,
            onSave: _handleSave,
            onCancel: () => Navigator.pop(context),
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
                  hintText: 'TI-001',
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
                  hintText: 'Adams Professional 29"',
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
                items: [
                  'ティンパニ', 'マリンバ', 'ビブラフォン', 'シロフォン', 'ドラム', 'シンバル', 'その他'
                ]
                    .map((c) => DropdownMenuItem(
                          value: c,
                          child: Text(c),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value!;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'カテゴリを選択してください';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 16),
              
              // 価格
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 価格入力
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      controller: _priceController,
                      decoration: const InputDecoration(
                        labelText: '価格 *',
                        hintText: '1000000',
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '価格を入力してください';
                        }
                        if (double.tryParse(value) == null) {
                          return '数値を入力してください';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  
                  // 通貨選択
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _selectedCurrency,
                      decoration: const InputDecoration(
                        labelText: '通貨 *',
                      ),
                      items: const [
                        DropdownMenuItem(value: 'JPY', child: Text('JPY (円)')),
                        DropdownMenuItem(value: 'USD', child: Text('USD (ドル)')),
                        DropdownMenuItem(value: 'EUR', child: Text('EUR (ユーロ)')),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedCurrency = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // 購入理由
              TextFormField(
                controller: _reasonController,
                decoration: const InputDecoration(
                  labelText: '購入理由',
                  hintText: '現在の設備が老朽化しているため',
                ),
                maxLines: 2,
              ),
              
              const SizedBox(height: 16),
              
              // 申請日
              InkWell(
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: _requestedDate ?? DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (date != null) {
                    setState(() {
                      _requestedDate = date;
                    });
                  }
                },
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: '申請日',
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(_requestedDate != null 
                          ? DateFormat('yyyy年MM月dd日').format(_requestedDate!)
                          : ''),
                      const Icon(Icons.calendar_today),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // 会計年度
              DropdownButtonFormField<int>(
                value: _fiscalYear,
                decoration: const InputDecoration(
                  labelText: '会計年度',
                ),
                items: [
                  for (int year = DateTime.now().year - 2; year <= DateTime.now().year + 2; year++)
                    DropdownMenuItem(
                      value: year,
                      child: Text('$year年度'),
                    ),
                ],
                onChanged: (value) {
                  setState(() {
                    _fiscalYear = value!;
                  });
                },
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
                  hintText: '購入を検討している資産の詳細情報...',
                ),
                maxLines: 5,
              ),
              
              const SizedBox(height: 16),
              
              // 添付ファイル
              // TODO: ファイルアップロード実装
              OutlinedButton.icon(
                onPressed: () {
                  // ファイル選択ダイアログを表示
                },
                icon: const Icon(Icons.attach_file),
                label: const Text('ファイルを添付'),
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