import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/asset_viewmodel.dart';
import '../../viewmodels/acquisition_viewmodel.dart';
import '../../viewmodels/knowledge_viewmodel.dart';
import '../../viewmodels/user_viewmodel.dart';
import '../widgets/dashboard/asset_stats_widget.dart';
import '../widgets/dashboard/acquisition_stats_widget.dart';
import '../widgets/dashboard/recent_knowledge_widget.dart';
import '../widgets/common/app_drawer.dart';

class HomeDashboard extends StatefulWidget {
  const HomeDashboard({Key? key}) : super(key: key);

  @override
  _HomeDashboardState createState() => _HomeDashboardState();
}

class _HomeDashboardState extends State<HomeDashboard> {
  @override
  void initState() {
    super.initState();
    // ダッシュボード表示時に各種データを取得
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final assetViewModel = Provider.of<AssetViewModel>(context, listen: false);
      final acquisitionViewModel = Provider.of<AcquisitionViewModel>(context, listen: false);
      final knowledgeViewModel = Provider.of<KnowledgeViewModel>(context, listen: false);
      
      assetViewModel.fetchAssets();
      acquisitionViewModel.fetchAcquisitions();
      knowledgeViewModel.fetchKnowledgeItems();
    });
  }

  @override
  Widget build(BuildContext context) {
    final userViewModel = Provider.of<UserViewModel>(context);
    final user = userViewModel.currentUser;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('ダッシュボード'),
      ),
      drawer: const AppDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ようこそメッセージ
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: user?.profileImage != null
                            ? NetworkImage(user!.profileImage!)
                            : null,
                        child: user?.profileImage == null
                            ? const Icon(Icons.person, size: 30)
                            : null,
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'ようこそ、${user?.displayName ?? 'ゲスト'}さん',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '打楽器管理システムへようこそ。最新情報を確認しましょう。',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // 資産統計ウィジェット
              const AssetStatsWidget(),
              
              const SizedBox(height: 16),
              
              // 購入検討資産統計ウィジェット
              const AcquisitionStatsWidget(),
              
              const SizedBox(height: 16),
              
              // 最近のナレッジウィジェット
              const RecentKnowledgeWidget(),
            ],
          ),
        ),
      ),
    );
  }
} 