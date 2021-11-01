import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:to_do/Models/todo_data.dart';
import 'package:to_do/Widgets/add_todo_widget.dart';
import 'package:to_do/Widgets/todo_tile.dart';
import 'package:to_do/boxes.dart';

import 'DataHandler/app_data.dart';
import 'Widgets/task_text.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff2979ff),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add, size: 36, color: Color(0xfff50057)),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          onPressed: () {
            showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (context) => SingleChildScrollView(
                        child: Container(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: const AddTodo(false),
                    )));
          }),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(
                            10.0,
                          ),
                        ),
                        child: const Icon(
                          Icons.list_alt_outlined,
                          size: 40,
                          color: Color(0xfff50057),
                        ),
                      ),
                      Row(
                        children: [
                          PopupMenuButton<int>(
                            onSelected: (item) =>
                                onFilterItemSelected(context, item),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                            icon: const Icon(Icons.filter_list,
                                size: 40, color: Colors.white
                                //color: Color(0xffff4081),
                                ),
                            itemBuilder: (context) => [
                              const PopupMenuItem<int>(
                                value: 0,
                                child: Text('Show all'),
                              ),
                              const PopupMenuItem<int>(
                                value: 1,
                                child: Text('Completed'),
                              ),
                              const PopupMenuItem<int>(
                                value: 2,
                                child: Text('In Progress'),
                              ),
                            ],
                          ),
                          const SizedBox(width: 20),
                          PopupMenuButton(
                            icon: const Icon(Icons.settings,
                                size: 40, color: Colors.white),
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                child: Row(
                                  children: const [
                                    Icon(Icons.logout_outlined),
                                    SizedBox(width: 2),
                                    Text('Exit'),
                                  ],
                                ),
                                onTap: () {
                                  SystemNavigator.pop();
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10.0),
                  Text(
                    'My ToDo',
                    style: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                        color: Color(0xfffcfcfc),
                        fontSize: 36.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const TaskText(),
                ],
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0),
                  ),
                ),
                child: Consumer<AppData>(
                  builder: (context, appData, _) {
                    return ValueListenableBuilder<Box<TodoData>>(
                      valueListenable: Boxes.getTodoData().listenable(),
                      builder: (context, box, _) {
                        List<TodoData> todoDataList;
                        int value = appData.data.filterValue;
                        if (value == 0) {
                          todoDataList = box.values.toList().cast<TodoData>();
                        } else if (value == 1) {
                          todoDataList = box.values
                              .toList()
                              .where((element) {
                                return element.isCompleted ? true : false;
                              })
                              .toList()
                              .cast<TodoData>();
                        } else {
                          todoDataList = box.values
                              .toList()
                              .where((element) {
                                return !element.isCompleted ? true : false;
                              })
                              .toList()
                              .cast<TodoData>();
                        }
                        return TodoTile(todoData: todoDataList);
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  onFilterItemSelected(BuildContext context, int item) {
    final box = Boxes.getTodoData().values;
    switch (item) {
      case 0:
        Provider.of<AppData>(context, listen: false)
            .updateTileDataFilterValue(0);
        int a = box.toList().cast<TodoData>().length;
        Provider.of<AppData>(context, listen: false).updateTileDataTotalTodo(a);

        break;
      case 1:
        Provider.of<AppData>(context, listen: false)
            .updateTileDataFilterValue(1);
        int a = box.toList().where((element) {
          return element.isCompleted ? true : false;
        }).length;
        Provider.of<AppData>(context, listen: false).updateTileDataTotalTodo(a);
        break;
      default:
        Provider.of<AppData>(context, listen: false)
            .updateTileDataFilterValue(2);
        int a = box.toList().where((element) {
          return !element.isCompleted ? true : false;
        }).length;
        Provider.of<AppData>(context, listen: false).updateTileDataTotalTodo(a);
        break;
    }
  }
}
