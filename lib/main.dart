import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'bill_provider.dart';
import 'bill_list_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => BillProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bill Reminder',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BillListScreen(),
    );
  }
}
