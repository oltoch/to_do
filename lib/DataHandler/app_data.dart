import 'package:flutter/material.dart';
import 'package:to_do/DataHandler/todo_tile_data.dart';
import 'package:to_do/Models/todo_data.dart';

import '../boxes.dart';

class AppData extends ChangeNotifier {
  static int count = Boxes.getTodoData()
      .values
      .where((element) => element.isCompleted ? false : true)
      .length;
  List<TodoData> todos = [];
  TodoTileData data = TodoTileData(totalTodo: count);
  TodoData todoData = TodoData();

  void updateTodoList(TodoData todoData) {
    todos.add(todoData);
    notifyListeners();
  }

  void updateTileDataTotalTodo(int value) {
    data.totalTodo = value;
    notifyListeners();
  }

  void updateTileDataFilterValue(int value) {
    data.filterValue = value;
    notifyListeners();
  }

  void updateTodoData(TodoData data) {
    todoData = data;
    notifyListeners();
  }
}
