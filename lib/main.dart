import 'package:flutter/material.dart';
import 'views/home_view.dart';

void main() {
  runApp(BatalhaDeSeriesApp());
}

class BatalhaDeSeriesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Batalha de Séries',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white, // Fundo branco
        appBarTheme: AppBarTheme(
          color: Colors.blue, // AppBar azul
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.blue,
        ),
      ),
      home: HomeView(),
    );
  }
}
