import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager/constants/constants.dart';
import 'package:task_manager/model/task_model.dart';
import 'package:task_manager/screens/LoginScreen.dart';
import 'package:task_manager/viewmodel/task_viewmodel.dart';

class TaskScreen extends StatelessWidget {
  const TaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondary,
      appBar: AppBar(
        backgroundColor: primary,
        title: Text(
          'Task Manager',
          style: TextStyle(
              color: textBlue, fontSize: 25, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.clear(); // Clear all saved data
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => LoginScreen()),
              ); // Navigate to login screen
            },
            icon: Icon(Icons.logout), // Logout icon
            color: Colors.white,
          ),
        ],
      ),
      body: Consumer<TaskViewmodel>(builder: (context, taskProvider, _) {
        return ListView.separated(
            itemBuilder: (context, index) {
              final task = taskProvider.tasks[index];
              return TaskWidget(
                task: task,
              );
            },
            separatorBuilder: (context, index) {
              return Divider(
                color: primary,
                thickness: 1,
                height: 1,
              );
            },
            itemCount: taskProvider.tasks.length);
      }),
      floatingActionButton: CustomFloatingActionButton(),
    );
  }
}

class TaskWidget extends StatelessWidget {
  const TaskWidget({
    super.key,
    required this.task,
  });
  final Task task;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
      title: Text(
        task.taskName,
        style: TextStyle(
            fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
      ),
      subtitle: Text(
        "${task.date} ,${task.time}",
        style: TextStyle(
            fontSize: 15, fontWeight: FontWeight.w400, color: textBlue),
      ),
    );
  }
}

class CustomFloatingActionButton extends StatelessWidget {
  const CustomFloatingActionButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        showDialog(
            context: context,
            builder: (context) {
              return CustomDialog();
            });
      },
      child: Icon(
        Icons.add,
        size: 35,
        color: Colors.white,
      ),
      shape: CircleBorder(),
      backgroundColor: primary,
    );
  }
}

class CustomDialog extends StatelessWidget {
  const CustomDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    double sh = MediaQuery.of(context).size.height;
    double sw = MediaQuery.of(context).size.width;
    final taskProvider = Provider.of<TaskViewmodel>(context, listen: false);
    return Dialog(
      backgroundColor: secondary,
      child: SizedBox(
        height: sh * 0.5,
        width: sw * 0.8,
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: sw * 0.05, vertical: sh * 0.02),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  "Create New Task",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w600),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "What has to be done?",
                style: TextStyle(color: textBlue, fontSize: 18),
              ),
              customTextfield(
                hint: "Enter here",
                onChanged: (value) {
                  taskProvider.setTaskName(value);
                },
              ),
              SizedBox(
                height: 50,
              ),
              Text(
                "Due Date",
                style: TextStyle(color: textBlue, fontSize: 18),
              ),
              customTextfield(
                hint: "Pick Date",
                readOnly: true,
                icon: Icons.calendar_month_rounded,
                controller: taskProvider.dateCont,
                onTap: () async {
                  DateTime? date = await showDatePicker(
                      context: context,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2030),
                      initialDate: DateTime.now());

                  taskProvider.setDate(date);
                },
              ),
              SizedBox(
                height: 10,
              ),
              customTextfield(
                hint: "Pick Time",
                readOnly: true,
                icon: Icons.timer,
                controller: taskProvider.timeCont,
                onTap: () async {
                  TimeOfDay? time = await showTimePicker(
                      context: context, initialTime: TimeOfDay.now());

                  taskProvider.setTime(time);
                },
              ),
              SizedBox(
                height: 30,
              ),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    await taskProvider.addTask();
                    if (context.mounted) {
                      Navigator.pop(context);
                    }
                  },
                  child: Text(
                    "Create",
                    style: TextStyle(color: secondary),
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(Colors.white),
                    shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class customTextfield extends StatelessWidget {
  const customTextfield(
      {super.key,
      required this.hint,
      this.icon,
      this.onTap,
      this.readOnly = false,
      this.onChanged,
      this.controller});
  final String hint;
  final IconData? icon;
  final void Function()? onTap;
  final bool readOnly;
  final void Function(String)? onChanged;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      width: double.infinity,
      child: TextField(
        style: TextStyle(color: Colors.white),
        readOnly: readOnly,
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          suffixIcon: InkWell(
              onTap: onTap,
              child: Icon(
                icon,
                color: Colors.white,
              )),
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey),
        ),
      ),
    );
  }
}
