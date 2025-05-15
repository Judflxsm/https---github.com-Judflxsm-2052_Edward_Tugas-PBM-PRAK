import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'pages/pemain_list_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MU Players CRUD',
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.red,
        colorScheme: const ColorScheme.dark(primary: Colors.red),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          labelStyle: TextStyle(color: Colors.red),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
          ),
        ),
      ),
      home: const PemainListPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
