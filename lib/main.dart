import 'package:flutter/material.dart';
import 'routes.dart';
import 'utils/theme.dart';
import 'package:provider/provider.dart';
import 'providers/user_provider.dart';
import 'providers/asset_provider.dart';
import 'providers/acquisition_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => AssetProvider()),
        ChangeNotifierProvider(create: (_) => AcquisitionProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PoC_flutter_perc',
      theme: appTheme,
      initialRoute: '/login',
      routes: appRoutes,
    );
  }
}
