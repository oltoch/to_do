import 'package:hive/hive.dart';
import 'package:to_do/Models/todo_data.dart';

class Boxes {
  static Box<TodoData> getTodoData() => Hive.box<TodoData>('todo_data');
}
