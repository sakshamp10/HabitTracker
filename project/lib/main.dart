// ignore_for_file: prefer_const_constructors, unused_import

import 'package:flutter/material.dart';
import 'package:project/data/habit_database.dart';
import 'package:project/pages/HomePage.dart';
import 'package:project/theme/darkMode.dart';
import 'package:project/theme/theme_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await HabitDatabase.initialize();
  await HabitDatabase().saveFirstLaunchDate();


  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create:(context)=> ThemeProvider(),),
        ChangeNotifierProvider(create:(context)=> HabitDatabase(),),
      
      ],
      child: const MyApp(),
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
      theme: Provider.of<ThemeProvider>(context).themeData,
    );
  }
}

