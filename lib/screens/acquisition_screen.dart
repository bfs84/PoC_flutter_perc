import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/acquisition_provider.dart';

class AcquisitionScreen extends StatefulWidget {
  const AcquisitionScreen({Key? key}) : super(key: key);
  @override
  _AcquisitionScreenState createState() => _AcquisitionScreenState();
}

class _AcquisitionScreenState extends State<AcquisitionScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<AcquisitionProvider>(context, listen: false).fetchAcquisitionAssets();
  }

  @override
  Widget build(BuildContext context) {
    final acquisitionProvider = Provider.of<AcquisitionProvider>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('購入検討資産管理')),
      body: acquisitionProvider.acquisitionAssets.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: acquisitionProvider.acquisitionAssets.length,
              itemBuilder: (context, index) {
                final asset = acquisitionProvider.acquisitionAssets[index];
                return ListTile(
                  title: Text(asset.assetName),
                  subtitle: Text('状態: ${asset.status}'),
                );
              },
            ),
    );
  }
} 