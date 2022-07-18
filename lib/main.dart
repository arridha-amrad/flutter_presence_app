import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:presence_app/firebase_options.dart';

import 'app/routes/app_pages.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ButtonStyle(
            elevation: MaterialStateProperty.all(0.0),
          )),
          primarySwatch: Colors.green,
          appBarTheme: const AppBarTheme(elevation: 0.0)),
      title: "Application",
      initialRoute: Routes.ADD_EMPLOYEE,
      getPages: AppPages.routes,
    ),
  );
}
