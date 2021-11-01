import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:to_do/DataHandler/app_data.dart';
import 'package:to_do/Models/todo_data.dart';
import 'package:to_do/Notification/notification_api.dart';

import '../boxes.dart';
import 'add_todo_widget.dart';
import 'completed_dialog_box.dart';
import 'delete_dialog_box.dart';

class TodoTile extends StatefulWidget {
  const TodoTile({Key? key, required this.todoData}) : super(key: key);

  final List<TodoData> todoData;

  @override
  _TodoTileState createState() => _TodoTileState();
}

class _TodoTileState extends State<TodoTile> {
  @override
  Widget build(BuildContext context) {
    return widget.todoData.isEmpty
        ? const Center(
            child: Text(
              'No tasks yet!',
              style: TextStyle(fontSize: 24),
            ),
          )
        : Column(
            children: [
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: widget.todoData.length,
                  itemBuilder: (context, index) {
                    //to sort the items in the order of date they are created
                    widget.todoData
                        .sort((a, b) => a.dateStarted.compareTo(b.dateStarted));
                    final todoData = widget.todoData[index];
                    return buildTodo(context, todoData, index);
                  },
                ),
              ),
            ],
          );
  }

  Widget buildTodo(BuildContext context, TodoData todoData, int index) {
    Color color =
        index.isOdd ? const Color(0xffff4081) : const Color(0xff448aff);
    final dateExpected = DateFormat.MMMd().format(todoData.dateExpected);
    String dateCompleted = '';
    if (todoData.isCompleted) {
      dateCompleted = DateFormat.yMMMd().format(todoData.dateCompleted!);
    }
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      color: color,
      child: GestureDetector(
        onLongPress: () {
          if (!todoData.isCompleted) {
            showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return CompletedDialogBox(todoData);
                    },
                    barrierDismissible: false)
                .then((value) {
              if (value == 'yes') {
                NotificationApi.cancelNotification(todoData.key);
                final box = Boxes.getTodoData().values;
                int count;
                int a = Provider.of<AppData>(context, listen: false)
                    .data
                    .filterValue;
                if (a == 0) {
                  count = box.toList().length;
                } else if (a == 1) {
                  count = box.toList().where((element) {
                    return element.isCompleted ? true : false;
                  }).length;
                } else {
                  count = box.toList().where((element) {
                    return !element.isCompleted ? true : false;
                  }).length;
                }
                Provider.of<AppData>(context, listen: false)
                    .updateTileDataTotalTodo(count);
                int countActive = box.toList().where((element) {
                  return !element.isCompleted ? true : false;
                }).length;
                if (countActive == 0) {
                  NotificationApi.cancelNotification(0);
                }
              }
            });
          }
        },
        child: ExpansionTile(
          iconColor: Colors.white,
          collapsedTextColor: Colors.white,
          textColor: Colors.white,
          collapsedIconColor: Colors.white,
          tilePadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
          title: Text(
            todoData.title,
            softWrap: true,
            maxLines: 5,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          subtitle: Text(
            !todoData.isCompleted
                ? '\nDeadline: ' + dateExpected
                : '\nCompleted: ' + dateCompleted,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          children: [
            buildButtons(context, todoData),
          ],
        ),
      ),
    );
  }

  Widget buildButtons(BuildContext context, TodoData todoData) {
    final dateStarted = DateFormat.MMMd().format(todoData.dateStarted);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '\nCreated: ' + dateStarted,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton.icon(
                label: const Text(
                  'Edit',
                  style: TextStyle(color: Colors.white),
                ),
                icon: const Icon(Icons.edit, color: Colors.white),
                onPressed: () {
                  showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (context) => SingleChildScrollView(
                              child: Container(
                            padding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom),
                            child: AddTodo(
                              true,
                              todoData: todoData,
                              context: context,
                            ),
                          )));
                },
              ),
              TextButton.icon(
                label: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.white),
                ),
                icon: const Icon(Icons.delete, color: Colors.white),
                onPressed: () {
                  showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return DeleteDialogBox(todoData);
                          },
                          barrierDismissible: false)
                      .then((value) {
                    if (value == 'yes') {
                      final box = Boxes.getTodoData().values;
                      int count;
                      int a = Provider.of<AppData>(context, listen: false)
                          .data
                          .filterValue;
                      if (a == 0) {
                        count = box.toList().length;
                      } else if (a == 1) {
                        count = box.toList().where((element) {
                          return element.isCompleted ? true : false;
                        }).length;
                      } else {
                        count = box.toList().where((element) {
                          return !element.isCompleted ? true : false;
                        }).length;
                      }
                      Provider.of<AppData>(context, listen: false)
                          .updateTileDataTotalTodo(count);
                      int countActive = box.toList().where((element) {
                        return !element.isCompleted ? true : false;
                      }).length;
                      if (countActive == 0) {
                        NotificationApi.cancelNotification(0);
                      }
                    }
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
