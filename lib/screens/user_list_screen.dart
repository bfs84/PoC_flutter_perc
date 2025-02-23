import 'package:flutter/material.dart';
import '../models/user.dart';
import '../widgets/app_drawer.dart';
import 'user_edit_screen.dart';

class UserListScreen extends StatelessWidget {
  final List<User> mockUsers;

  const UserListScreen({Key? key, required this.mockUsers}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('ユーザー一覧')),
      drawer: AppDrawer(),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: [
            DataColumn(label: Text('姓名')),
            DataColumn(label: Text('メールアドレス')),
            DataColumn(label: Text('担当')),
          ],
          rows: mockUsers.map((user) {
            return DataRow(
              cells: [
                DataCell(
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => UserEditScreen(user: user)),
                      );
                    },
                    child: Text(
                      user.fullName,
                      style: TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
                DataCell(Text(user.email)),
                DataCell(Text(user.role)),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
} 