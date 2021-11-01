import 'package:flutter/material.dart';
import 'package:to_do/Models/db_model.dart';
import 'package:to_do/Models/todo_data.dart';
import 'package:to_do/Notification/notification_api.dart';

class CompletedDialogBox extends StatelessWidget {
  final String message = 'Mark todo as completed';
  final TodoData todoData;
  const CompletedDialogBox(this.todoData, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        height: 150,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(height: 5),
              Text(
                message,
                style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                    color: Colors.black),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.close,
                          color: Colors.red,
                        ),
                        label: const Text('No',
                            style: TextStyle(fontSize: 22, color: Colors.red))),
                    TextButton.icon(
                        onPressed: () {
                          DbModels.editTodo(todoData,
                              title: todoData.title,
                              dateExpected: todoData.dateExpected,
                              dateCompleted: DateTime.now(),
                              timeExpected: todoData.timeExpected,
                              timeCompleted:
                                  TimeOfDay.now().toString().substring(10, 15),
                              isAlarmOn: todoData.isAlarmOn,
                              isCompleted: true);
                          if (todoData.isAlarmOn) {
                            NotificationApi.cancelNotification(todoData.key);
                          }

                          Navigator.pop(context, 'yes');
                        },
                        icon: const Icon(
                          Icons.check,
                          color: Colors.green,
                        ),
                        label: const Text('Yes',
                            style:
                                TextStyle(fontSize: 22, color: Colors.green))),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
