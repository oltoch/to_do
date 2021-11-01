import 'package:flutter/material.dart';
import 'package:to_do/Models/db_model.dart';
import 'package:to_do/Models/todo_data.dart';
import 'package:to_do/Notification/notification_api.dart';

class DeleteDialogBox extends StatelessWidget {
  final String message = 'Confirm to delete';
  final TodoData todoData;
  const DeleteDialogBox(this.todoData, {Key? key}) : super(key: key);
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
                          if (todoData.isAlarmOn) {
                            NotificationApi.cancelNotification(todoData.key);
                          }
                          DbModels.deleteTodo(todoData);

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
