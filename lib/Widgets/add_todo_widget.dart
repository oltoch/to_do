import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:to_do/DataHandler/app_data.dart';
import 'package:to_do/Models/db_model.dart';
import 'package:to_do/Models/todo_data.dart';
import 'package:to_do/Notification/notification_api.dart';
import 'package:to_do/Widgets/text_field_widget.dart';

import '../boxes.dart';
import 'main_button_widget.dart';

class AddTodo extends StatefulWidget {
  const AddTodo(this.isEdit, {Key? key, this.todoData, this.context})
      : super(key: key);

  final bool isEdit;
  final TodoData? todoData;
  final BuildContext? context;

  @override
  _AddTodoState createState() => _AddTodoState();
}

class _AddTodoState extends State<AddTodo> {
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  final _dateController = TextEditingController();
  final _titleController = TextEditingController();
  final _timeController = TextEditingController();
  bool _isTimeValid = false;
  bool _isDateValid = false;
  bool _isNotificationOn = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: MediaQuery.of(context).viewInsets.bottom != 0
          ? const Color(0xff133875)
          : const Color(0xff757575),
      child: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                widget.isEdit ? 'Edit Todo' : 'Add New Todo',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  textStyle: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff111111),
                  ),
                ),
              ),
              const SizedBox(height: 10.0),
              TextFieldWidget(
                textInputType: TextInputType.text,
                controller: _titleController,
                label: 'Enter todo here',
              ),
              const SizedBox(height: 5),
              TextFieldWidget(
                readOnly: true,
                validity: _isDateValid,
                controller: _dateController,
                label: 'Choose a date',
                textInputType: TextInputType.datetime,
                icon: const Icon(
                  Icons.calendar_today_outlined,
                  color: Color(0xffff4081),
                  size: 30,
                ),
                onIconPressed: () async {
                  await _selectDate();
                },
              ),
              const SizedBox(height: 5),
              (_isDateValid)
                  ? TextFieldWidget(
                      readOnly: true,
                      validity: _isTimeValid,
                      controller: _timeController,
                      label: 'Set time',
                      textInputType: TextInputType.datetime,
                      icon: const Icon(Icons.access_time_outlined,
                          color: Color(0xffff4081), size: 30),
                      onIconPressed: () async {
                        await _selectTime();
                      },
                    )
                  : Container(),
              const SizedBox(height: 5),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isNotificationOn = !_isNotificationOn;
                  });
                },
                child: Icon(
                    _isNotificationOn
                        ? Icons.notifications_on_outlined
                        : Icons.notifications_off_outlined,
                    color: const Color(0xffff4081),
                    size: 50),
              ),
              const SizedBox(height: 10),
              MainButtonWidget(
                  title: widget.isEdit ? 'Save' : 'Add',
                  onTap: () async {
                    if (validate()) {
                      if (widget.isEdit) {
                        if (widget.todoData!.isAlarmOn && !_isNotificationOn) {
                          NotificationApi.cancelNotification(
                              widget.todoData!.key);
                        }
                        await DbModels.editTodo(widget.todoData!,
                            title: _titleController.text,
                            dateExpected: _selectedDate,
                            dateCompleted: null,
                            timeExpected:
                                _selectedTime.toString().substring(10, 15),
                            timeCompleted: null,
                            isAlarmOn: _isNotificationOn,
                            isCompleted: false);
                        if (_isNotificationOn) {
                          scheduleNotification(
                              id: widget.todoData!.key,
                              time: _selectedTime,
                              date: _selectedDate);
                        }
                        Navigator.pop(context);
                      } else {
                        String a = DateTime.now().toString();
                        String b = a.substring(8, 10) +
                            a.substring(18, 19) +
                            a.substring(20, 26);
                        int key = int.parse(b);
                        await DbModels.addTodo(
                            key: key,
                            title: _titleController.text,
                            dateExpected: _selectedDate,
                            dateCompleted: null,
                            timeExpected:
                                _selectedTime.toString().substring(10, 15),
                            timeCompleted: null,
                            isAlarmOn: _isNotificationOn,
                            isCompleted: false);
                        if (_isNotificationOn) {
                          scheduleNotification(
                              id: key,
                              time: _selectedTime,
                              date: _selectedDate);
                          scheduleDailyNotification(0, const Time(8, 0));
                        }

                        final box = Boxes.getTodoData();
                        int count = box.values
                            .where(
                                (element) => element.isCompleted ? false : true)
                            .length;
                        Provider.of<AppData>(context, listen: false)
                            .updateTileDataTotalTodo(count);
                        Navigator.pop(context);
                      }
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate, // Refer step 1
      firstDate: DateTime(_selectedDate.year, _selectedDate.month - 1),
      lastDate: DateTime(_selectedDate.year + 2),
      errorFormatText: 'Enter the date in a correct format',
      errorInvalidText: 'You cannot make that date selection',
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        setDateControllerText(picked);

        if (DateTime(picked.year, picked.month, picked.day).isBefore(DateTime(
            DateTime.now().year, DateTime.now().month, DateTime.now().day))) {
          _isDateValid = false;
        } else {
          _isDateValid = true;
        }
      });
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? result = await showTimePicker(
      context: context,
      initialTime: _selectedTime.hour == TimeOfDay.now().hour &&
              _selectedTime.minute == TimeOfDay.now().minute
          ? TimeOfDay(hour: TimeOfDay.now().hour + 1, minute: 0)
          : _selectedTime,
    );
    if (result != null) {
      setState(() {
        _selectedTime = result;
        setTimeControllerText(result);
        if (DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day)
            .isAfter(DateTime.now())) {
          _isTimeValid = true;
        } else if (result.hour < TimeOfDay.now().hour ||
            (result.hour == TimeOfDay.now().hour &&
                result.minute < TimeOfDay.now().minute)) {
          _isTimeValid = false;
        } else {
          _isTimeValid = true;
        }
      });
    }
  }

  bool validate() {
    //return _titleController.text.isEmpty || !_isTimeValid || !_isDateValid? false:true;
    if (_titleController.text.isEmpty) {
      EasyLoading.showError('Field cannot be empty');
      return false;
    } else if (!_isDateValid) {
      EasyLoading.showError('Why would you want to do this task yesterday?');
      return false;
    } else if (!_isTimeValid) {
      EasyLoading.showError('you can\'t travel back in time, or can you?');
      return false;
    } else {
      return true;
    }
  }

  void setDateControllerText(DateTime picked) {
    if (picked.day == DateTime.now().day + 1 &&
        picked.month == DateTime.now().month &&
        picked.year == DateTime.now().year) {
      _dateController.text = 'Tomorrow';
    } else if (picked.day == DateTime.now().day - 1 &&
        picked.month == DateTime.now().month &&
        picked.year == DateTime.now().year) {
      _dateController.text = 'Yesterday';
    } else if (picked.day == DateTime.now().day &&
        picked.month == DateTime.now().month &&
        picked.year == DateTime.now().year) {
      _dateController.text = 'Today';
    } else {
      _dateController.text = DateFormat('EEEE, d MMM, yyyy').format(picked);
    }
  }

  void setTimeControllerText(TimeOfDay time) {
    _timeController.text = time.format(context);
  }

  @override
  void dispose() {
    super.dispose();
    _timeController.dispose();
    _dateController.dispose();
    _titleController.dispose();
  }

  @override
  void initState() {
    putData();
    super.initState();
  }

  String formatTimeToString(String time) {
    String hr = time.substring(0, 2);
    String min = time.substring(3, 5);
    int hour = int.parse(hr);
    int minute = int.parse(min);
    return TimeOfDay(hour: hour, minute: minute).format(widget.context!);
  }

  TimeOfDay formatStringToTimeOfDay(String time) {
    String hr = time.substring(0, 2);
    String min = time.substring(3, 5);
    int hour = int.parse(hr);
    int minute = int.parse(min);
    return TimeOfDay(hour: hour, minute: minute);
  }

  void putData() {
    if (widget.isEdit) {
      final taskData = widget.todoData!;
      setDateControllerText(taskData.dateExpected);
      _titleController.text = taskData.title;
      _timeController.text = formatTimeToString(taskData.timeExpected);
      _isNotificationOn = taskData.isAlarmOn;
      _isTimeValid = true;
      _isDateValid = true;
      _selectedDate = widget.todoData!.dateExpected;
      _selectedTime = formatStringToTimeOfDay(widget.todoData!.timeExpected);
    }
  }

  void scheduleNotification(
      {int? id, required TimeOfDay time, required DateTime date}) {
    NotificationApi.showScheduledNotification(
        id: id ?? 0,
        //payLoad: '',
        title: 'Why haven\'t you completed me?',
        body: _titleController.text,
        scheduleTime: time,
        scheduleDate: date);
  }

  void scheduleDailyNotification(int id, Time time) {
    NotificationApi.showDailyNotification(
        id: id,
        time: time,
        title: 'Good morning!',
        body:
            'You have active tasks that need completion.\nHave a great day ahead');
  }
}
