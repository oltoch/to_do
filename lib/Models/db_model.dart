import 'package:to_do/Models/todo_data.dart';

import '../boxes.dart';

class DbModels {
  static Future<void> addTodo(
      {required int key,
      required String title,
      required DateTime dateExpected,
      required DateTime? dateCompleted,
      required String timeExpected,
      required String? timeCompleted,
      required bool isAlarmOn,
      required bool isCompleted}) async {
    final todoData = TodoData();
    todoData.title = title;
    todoData.timeCompleted = timeCompleted;
    todoData.timeExpected = timeExpected;
    todoData.dateCompleted = dateCompleted;
    todoData.dateExpected = dateExpected;
    todoData.isCompleted = isCompleted;
    todoData.isAlarmOn = isAlarmOn;

    final box = Boxes.getTodoData();
    //await box.add(taskData);
    await box.put(key, todoData);
  }

  static Future<void> editTodo(TodoData todoData,
      {required String title,
      required DateTime dateExpected,
      required DateTime? dateCompleted,
      required String timeExpected,
      required String? timeCompleted,
      required bool isAlarmOn,
      required bool isCompleted}) async {
    todoData.title = title;
    todoData.timeCompleted = timeCompleted;
    todoData.timeExpected = timeExpected;
    todoData.dateCompleted = dateCompleted;
    todoData.dateExpected = dateExpected;
    todoData.isCompleted = isCompleted;
    todoData.isAlarmOn = isAlarmOn;

    await todoData.save();
  }

  static void deleteTodo(TodoData todoData) {
    todoData.delete();
  }
}
