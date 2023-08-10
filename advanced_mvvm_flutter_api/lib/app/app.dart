


import 'package:advanced_mvvm_flutter_api/app/app_prefs.dart';
import 'package:advanced_mvvm_flutter_api/app/di.dart';
import 'package:advanced_mvvm_flutter_api/presentation/resources/routes_manager.dart';
import 'package:advanced_mvvm_flutter_api/presentation/resources/theme_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class MyApp extends StatefulWidget {
  // named constructor 
  MyApp._internal();
  static final MyApp _instance = MyApp._internal(); // singleton or single instance
  factory MyApp()=> _instance; 
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
 // factory 
  final AppPreferences _appPreferences = instance<AppPreferences>();
  @override
  void didChangeDependencies() {
   _appPreferences.getLocal().then((local) => {context.setLocale(local)});
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateRoute: RouteGenerator.getRoute,
      initialRoute: Routes.splashRoute,
      theme:getApplicationTheme(),
    );
  }
}