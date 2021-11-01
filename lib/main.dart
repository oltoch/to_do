import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:to_do/DataHandler/app_data.dart';

import 'Models/todo_data.dart';
import 'Notification/notification_api.dart';
import 'home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(TodoDataAdapter());
  await Hive.openBox<TodoData>('todo_data');
  tz.initializeTimeZones();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppData(),
      child: MaterialApp(
        title: 'ToDo App',
        theme: ThemeData(
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: Colors.grey[200],
            elevation: 4,
            sizeConstraints:
                const BoxConstraints.tightFor(width: 65, height: 65),
          ),
        ),
        home: const HomePage(),
        builder: EasyLoading.init(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    Hive.close();
  }

  @override
  void initState() {
    super.initState();
    NotificationApi.init(initScheduled: true);
    listenNotifications();
  }

  void listenNotifications() =>
      NotificationApi.onNotifications.stream.listen(onCLickedNotification);

  void onCLickedNotification(String? payload) {
    //implement logic for what should happen when user tap on notification.
    //Use payload to load up the appropriate screen
  }
}
