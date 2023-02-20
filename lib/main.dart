import 'package:caro_game/core/constrant.dart';
import 'package:caro_game/core/router_config.dart';
import 'package:caro_game/src/infrastructure/get_storage/local_database.dart';
import 'package:caro_game/src/presentation/view/login/login_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';

import 'generated/l10n.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Storage.getInstance(storeName: Constant.appName);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  Locale get locate {
    String code = Storage.instance.readString(Constant.stoLang);
    if (code.isEmpty) code = 'en';
    return Locale.fromSubtags(languageCode: code);
  }

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
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      locale: locate,
    );
  }
}
