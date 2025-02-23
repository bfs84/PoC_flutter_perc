import 'package:flutter/material.dart';
import 'models/instrument.dart';
import 'models/user.dart';
import 'screens/dashboard_screen.dart';

// グローバルなモックデータ
List<User> mockUsers = [
  User(id: "u1", firstName: "太郎", lastName: "山田", email: "taro@example.com", role: "担当A"),
  User(id: "u2", firstName: "一郎", lastName: "鈴木", email: "ichiro@example.com", role: "担当B"),
  User(id: "u3", firstName: "花子", lastName: "佐藤", email: "hanako@example.com", role: "担当C"),
];

List<Instrument> mockInstruments = [
  Instrument(
    ownerIds: ["u1"],
    quantity: 5,
    model: "Yamaha Drum Set Model X",
    storageLocation: "倉庫A",
    purchaseDate: DateTime(2020, 5, 20),
    wearDegree: 0.2,
    maintenanceHistory: ["2021-06-15: メンテナンス", "2022-03-10: 修理"],
  ),
  Instrument(
    ownerIds: ["u2"],
    quantity: 3,
    model: "Pearl Drum Set Model Y",
    storageLocation: "倉庫B",
    purchaseDate: DateTime(2019, 8, 10),
    wearDegree: 0.5,
    maintenanceHistory: ["2020-09-05: 点検"],
  ),
];

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '打楽器管理システム',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // 初期画面はホームダッシュボード。モックデータを渡します。
      home: DashboardScreen(
        mockUsers: mockUsers,
        mockInstruments: mockInstruments,
      ),
    );
  }
}
