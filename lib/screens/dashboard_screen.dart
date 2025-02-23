import 'package:flutter/material.dart';
import '../models/instrument.dart';
import '../models/user.dart';
import '../widgets/app_drawer.dart';

class DashboardScreen extends StatelessWidget {
  final List<User> mockUsers;
  final List<Instrument> mockInstruments;

  const DashboardScreen({
    Key? key,
    required this.mockUsers,
    required this.mockInstruments,
  }) : super(key: key);

  // ユーザー別楽器所持数を計算
  Map<String, int> getOwnerInstrumentCount() {
    Map<String, int> counts = {};
    for (var instrument in mockInstruments) {
      for (var ownerId in instrument.ownerIds) {
        counts[ownerId] = (counts[ownerId] ?? 0) + instrument.quantity;
      }
    }
    return counts;
  }

  // 最終メンテナンスが古い順に並べ替え
  List<Instrument> get sortedByOldMaintenance {
    List<Instrument> instruments = List.from(mockInstruments);
    instruments.sort((a, b) {
      DateTime? dateA = a.lastMaintenanceDate;
      DateTime? dateB = b.lastMaintenanceDate;
      if (dateA == null && dateB == null) return 0;
      if (dateA == null) return 1;
      if (dateB == null) return -1;
      return dateA.compareTo(dateB);
    });
    return instruments;
  }

  @override
  Widget build(BuildContext context) {
    final ownerCounts = getOwnerInstrumentCount();
    final sortedMaintenance = sortedByOldMaintenance;

    return Scaffold(
      appBar: AppBar(title: Text('ホームダッシュボード')),
      drawer: AppDrawer(),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 全体概要
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '全体の楽器状況概要',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text('登録楽器数: ${mockInstruments.length}', style: TextStyle(fontSize: 16)),
                  ],
                ),
              ),
              SizedBox(height: 20),
              // 所有者別レポート
              Card(
                elevation: 4,
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '所有者別楽器数',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Column(
                        children: ownerCounts.entries.map((entry) {
                          String fullName = mockUsers.firstWhere(
                            (user) => user.id == entry.key,
                            orElse: () => User(id: entry.key, firstName: entry.key, lastName: '', email: '', role: ''),
                          ).fullName;
                          return ListTile(
                            title: Text(fullName),
                            trailing: Text('${entry.value} 台'),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              // メンテナンスが古い楽器一覧レポート
              Card(
                elevation: 4,
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'メンテナンスが古い楽器一覧',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Column(
                        children: sortedMaintenance.map((instrument) {
                          return ListTile(
                            title: Text(instrument.model),
                            subtitle: Text('最終メンテナンス: ' +
                                (instrument.lastMaintenanceDate != null
                                    ? instrument.lastMaintenanceDate!.toLocal().toString().split(" ")[0]
                                    : "記録なし")),
                          );
                        }).toList(),
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
} 