import 'package:flutter/material.dart';
import 'package:sistema_importar_csv/views/configurations_page.dart';
import 'package:sistema_importar_csv/views/home_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sistema de importes',
      initialRoute: 'home',
      routes: {
        'home': (_) => HomePage(),
        'configurations': (_) => ConfigurationsPage()
      },
    );
  }
}
