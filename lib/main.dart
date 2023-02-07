import 'package:caro_game/core/constrant.dart';
import 'package:caro_game/core/router_config.dart';
import 'package:caro_game/src/infrastructure/get_storage/local_database.dart';
import 'package:caro_game/src/presentation/view/login/login_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Storage.getInstance(storeName: Constant.appName);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorSchemeSeed: Colors.blue,
        brightness: Brightness.light,
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorSchemeSeed: Colors.blue,
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      getPages: routers,
      initialRoute: LoginView.routeName,
    );
  }
}
