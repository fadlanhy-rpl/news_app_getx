import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:news_app_getx/screens/main_screen.dart';
import 'package:news_app_getx/screens/splash/splash_screen.dart'; 
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'SkyNews App',
      debugShowCheckedModeBanner: false,

      theme: ThemeData.light(),      
      // darkTheme: ThemeData.dark(),

      home: const SplashScreen(),
    );
  }
}