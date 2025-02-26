import 'package:flutter/material.dart';

/// 資産管理システム用のフォームビルダーウィジェット
class AssetManagementFormBuilder extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final bool isLoading;
  final VoidCallback? onSave;
  final VoidCallback? onCancel;
  final String saveButtonLabel;
  
  const AssetManagementFormBuilder({
    Key? key,
    required this.title,
    required this.children,
    this.isLoading = false,
    this.onSave,
    this.onCancel,
    this.saveButtonLabel = '保存',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const Divider(),
            const SizedBox(height: 16),
            
            // フォームフィールド
            ...children,
            
            const SizedBox(height: 32),
            
            // ボタンエリア
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (onCancel != null)
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: TextButton(
                      onPressed: isLoading ? null : onCancel,
                      child: const Text('キャンセル'),
                    ),
                  ),
                if (onSave != null)
                  ElevatedButton(
                    onPressed: isLoading ? null : onSave,
                    child: isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(saveButtonLabel),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// 資産管理システム用のテキストフォームフィールド
class AssetManagementTextFormField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool isRequired;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final bool readOnly;
  final int? maxLines;
  final String? hintText;
  
  const AssetManagementTextFormField({
    Key? key,
    required this.label,
    required this.controller,
    this.isRequired = false,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.readOnly = false,
    this.maxLines,
    this.hintText,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: isRequired ? '$label *' : label,
          border: OutlineInputBorder(),
          hintText: hintText,
        ),
        validator: validator,
        keyboardType: keyboardType,
        readOnly: readOnly,
        maxLines: maxLines,
      ),
    );
  }
}

/// 資産管理システム用のドロップダウンフィールド
class AssetManagementDropdownField<T> extends StatelessWidget {
  final String label;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final void Function(T?)? onChanged;
  final bool isRequired;
  
  const AssetManagementDropdownField({
    Key? key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
    this.isRequired = false,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<T>(
        value: value,
        items: items,
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: isRequired ? '$label *' : label,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
} 