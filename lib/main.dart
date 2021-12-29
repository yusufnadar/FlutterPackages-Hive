import 'package:flutter/material.dart';
import 'package:flutter_packages/hive/amountPage.dart';
import 'package:flutter_packages/hive/model/amount.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(AmountModelAdapter());
  await Hive.openBox<AmountModel>('amount');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Packages',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:  const AmountPage(),
    );
  }
}
