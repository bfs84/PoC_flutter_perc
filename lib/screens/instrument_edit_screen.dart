import 'package:flutter/material.dart';
import '../models/instrument.dart';
import '../models/user.dart';

class InstrumentEditScreen extends StatefulWidget {
  final Instrument instrument;
  final List<User> mockUsers;

  const InstrumentEditScreen({
    Key? key,
    required this.instrument,
    required this.mockUsers,
  }) : super(key: key);

  @override
  _InstrumentEditScreenState createState() => _InstrumentEditScreenState();
}

class _InstrumentEditScreenState extends State<InstrumentEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController modelController;
  late TextEditingController quantityController;
  late TextEditingController storageController;
  late TextEditingController purchaseDateController;
  late TextEditingController wearDegreeController;
  late TextEditingController shortDescriptionController;
  late TextEditingController descriptionController;
  late List<String> selectedOwnerIds;

  @override
  void initState() {
    super.initState();
    modelController = TextEditingController(text: widget.instrument.model);
    quantityController = TextEditingController(text: widget.instrument.quantity.toString());
    storageController = TextEditingController(text: widget.instrument.storageLocation);
    purchaseDateController = TextEditingController(
        text: widget.instrument.purchaseDate.toLocal().toString().split(" ")[0]);
    wearDegreeController = TextEditingController(text: (widget.instrument.wearDegree * 100).toString());
    shortDescriptionController = TextEditingController(text: '');
    descriptionController = TextEditingController(text: '');
    selectedOwnerIds = widget.instrument.ownerIds;
  }

  Future<List<String>?> _showUserSelectionDialog(BuildContext context, List<String> currentSelection) async {
    List<String> tempSelection = List.from(currentSelection);
    return showDialog<List<String>>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text("所有者を選択"),
              content: Container(
                width: double.maxFinite,
                child: ListView(
                  shrinkWrap: true,
                  children: widget.mockUsers.map((user) {
                    return CheckboxListTile(
                      value: tempSelection.contains(user.id),
                      title: Text(user.fullName),
                      subtitle: Text(user.email),
                      onChanged: (bool? value) {
                        if (value == true && !tempSelection.contains(user.id)) {
                          tempSelection.add(user.id);
                        } else if (value == false) {
                          tempSelection.remove(user.id);
                        }
                        setState(() {});
                      },
                    );
                  }).toList(),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, tempSelection);
                  },
                  child: Text("OK"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('楽器編集')),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              // フォーム上部右上に配置する保存ボタン
              Align(
                alignment: Alignment.topRight,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[800],
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('保存'),
                ),
              ),
              SizedBox(height: 16),
              // Row 1: 「名称」と「所有者」(参照型)
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: modelController,
                      decoration: InputDecoration(
                        labelText: '名称',
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        contentPadding: EdgeInsets.fromLTRB(12, 16, 12, 16),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        List<String>? result =
                            await _showUserSelectionDialog(context, selectedOwnerIds);
                        if (result != null) {
                          setState(() {
                            selectedOwnerIds = result;
                          });
                        }
                      },
                      child: InputDecorator(
                        decoration: InputDecoration(
                          labelText: '所有者',
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          contentPadding: EdgeInsets.fromLTRB(12, 16, 12, 16),
                          border: OutlineInputBorder(),
                        ),
                        child: Text(
                          selectedOwnerIds.isEmpty
                              ? ''
                              : selectedOwnerIds.map((id) {
                                  final user = widget.mockUsers.firstWhere(
                                    (u) => u.id == id,
                                    orElse: () => User(id: id, firstName: id, lastName: '', email: '', role: ''),
                                  );
                                  return user.fullName;
                                }).join(', '),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              // Row 2: 保管場所
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: storageController,
                      decoration: InputDecoration(
                        labelText: '保管場所',
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        contentPadding: EdgeInsets.fromLTRB(12, 16, 12, 16),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              // Row 3: 「購入日」と「損耗度 (%)」
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: purchaseDateController,
                      decoration: InputDecoration(
                        labelText: '購入日',
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        contentPadding: EdgeInsets.fromLTRB(12, 16, 12, 16),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: wearDegreeController,
                      decoration: InputDecoration(
                        labelText: '損耗度 (%)',
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        contentPadding: EdgeInsets.fromLTRB(12, 16, 12, 16),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              // 簡単な説明（全幅）
              TextFormField(
                controller: shortDescriptionController,
                decoration: InputDecoration(
                  labelText: '簡単な説明',
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  contentPadding: EdgeInsets.fromLTRB(12, 16, 12, 16),
                ),
              ),
              SizedBox(height: 16),
              // 説明（複数行）
              TextFormField(
                controller: descriptionController,
                decoration: InputDecoration(
                  labelText: '説明',
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  contentPadding: EdgeInsets.fromLTRB(12, 16, 12, 16),
                ),
                maxLines: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    modelController.dispose();
    quantityController.dispose();
    storageController.dispose();
    purchaseDateController.dispose();
    wearDegreeController.dispose();
    shortDescriptionController.dispose();
    descriptionController.dispose();
    super.dispose();
  }
} 