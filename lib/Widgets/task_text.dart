import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:to_do/DataHandler/app_data.dart';

class TaskText extends StatelessWidget {
  const TaskText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AppData>(
      builder: (context, appData, child) {
        int total = appData.data.totalTodo;
        int value = appData.data.filterValue;

        return value == 0
            ? Text(
                'All Tasks ($total)',
                style: GoogleFonts.poppins(
                  textStyle:
                      const TextStyle(color: Color(0xfffcfcfc), fontSize: 18),
                ),
              )
            : Text(
                '$total ${taskStatus(value)} ${isSingular(total)}',
                style: GoogleFonts.poppins(
                  textStyle:
                      const TextStyle(color: Color(0xfffcfcfc), fontSize: 18),
                ),
              );
      },
    );
  }

  String isSingular(int value) {
    return value == 1 ? 'Task' : 'Tasks';
  }

  String taskStatus(int value) {
    if (value == 1) {
      return 'Completed';
    } else {
      return 'Running';
    }
  }
}
