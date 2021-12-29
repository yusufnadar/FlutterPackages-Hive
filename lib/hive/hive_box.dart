import 'package:flutter_packages/hive/model/amount.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveBox{
  static Box<AmountModel> getAmount() => Hive.box<AmountModel>('amount');
}