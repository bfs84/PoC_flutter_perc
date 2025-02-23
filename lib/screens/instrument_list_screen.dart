import 'package:flutter/material.dart';
import '../models/instrument.dart';
import '../models/user.dart';
import '../widgets/app_drawer.dart';
import 'instrument_edit_screen.dart';

class InstrumentListScreen extends StatelessWidget {
  final List<Instrument> mockInstruments;
  final List<User> mockUsers;

  const InstrumentListScreen({
    Key? key,
    required this.mockInstruments,
    required this.mockUsers,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('楽器一覧')),
      drawer: AppDrawer(),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: [
            DataColumn(label: Text('名称')),
            DataColumn(label: Text('所有者')),
            DataColumn(label: Text('所持数')),
            DataColumn(label: Text('保管場所')),
            DataColumn(label: Text('購入日')),
            DataColumn(label: Text('損耗度')),
          ],
          rows: mockInstruments.map((inst) {
            return DataRow(
              cells: [
                DataCell(
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => InstrumentEditScreen(instrument: inst, mockUsers: mockUsers),
                        ),
                      );
                    },
                    child: Text(
                      inst.model,
                      style: TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
                DataCell(
                  Text(inst.ownerIds
                      .map((id) {
                        final user = mockUsers.firstWhere(
                          (u) => u.id == id,
                          orElse: () => User(id: id, firstName: id, lastName: '', email: '', role: ''),
                        );
                        return user.fullName;
                      })
                      .join(', ')),
                ),
                DataCell(Text(inst.quantity.toString())),
                DataCell(Text(inst.storageLocation)),
                DataCell(Text(inst.purchaseDate.toLocal().toString().split(" ")[0])),
                DataCell(Text('${(inst.wearDegree * 100).toStringAsFixed(0)}%')),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
} 