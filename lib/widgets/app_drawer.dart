import 'package:flutter/material.dart';
import '../screens/dashboard_screen.dart';
import '../screens/instrument_list_screen.dart';
import '../screens/user_list_screen.dart';
import '../main.dart'; // グローバルな mockUsers, mockInstruments を利用するため

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            child: Text(
              'メニュー',
              style: TextStyle(fontSize: 24, color: Colors.white),
            ),
            decoration: BoxDecoration(color: Colors.blue),
          ),
          ListTile(
            title: Text('ホーム'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => DashboardScreen(
                    mockUsers: mockUsers,
                    mockInstruments: mockInstruments,
                  ),
                ),
              );
            },
          ),
          ListTile(
            title: Text('楽器一覧'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => InstrumentListScreen(
                    mockInstruments: mockInstruments,
                    mockUsers: mockUsers,
                  ),
                ),
              );
            },
          ),
          ListTile(
            title: Text('ユーザー一覧'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => UserListScreen(
                    mockUsers: mockUsers,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
} 