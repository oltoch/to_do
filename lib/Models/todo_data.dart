import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'todo_data.g.dart';

@HiveType(typeId: 0)
class TodoData extends HiveObject {
  @HiveField(0)
  late String title;
  @HiveField(1)
  DateTime dateStarted = DateTime.now();
  @HiveField(2)
  String timeStarted = TimeOfDay.now().toString().substring(10, 15);
  @HiveField(3)
  late bool isAlarmOn;
  @HiveField(4)
  late bool isCompleted;
  @HiveField(5)
  late DateTime dateExpected;
  @HiveField(6)
  late DateTime? dateCompleted;
  @HiveField(7)
  late String timeExpected;
  @HiveField(8)
  late String? timeCompleted;
}
