import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:syncfusion_localizations/syncfusion_localizations.dart';
import 'package:mockhouse_crm/widgets/auth_check.dart';

class MOCKHOUSECRMApp extends StatelessWidget {
  const MOCKHOUSECRMApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        GlobalWidgetsLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        SfGlobalLocalizations.delegate
      ],
      supportedLocales: [Locale("pt", "BR")],
      title: 'Mockhouse CRM',
      debugShowCheckedModeBanner: false,
      theme:
          ThemeData(primarySwatch: Colors.grey, brightness: Brightness.light),
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(brightness: Brightness.dark),
      home: AuthCheck(),
    );
  }
}
