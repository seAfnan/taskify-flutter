import 'dart:ffi';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:taskify/models/task.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late double _deviceWidth, _deviceHeight;
  String? _taskTitle;
  Box? _taskBox;

  _HomePageState();

  @override
  Widget build(BuildContext context) {
    _deviceWidth = MediaQuery.of(context).size.width;
    _deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 1, 18, 34),
        appBar: AppBar(
          title: const Text('Taskify', style: TextStyle(fontSize: 25)),
          toolbarHeight: _deviceHeight * 0.1,
          backgroundColor: const Color.fromARGB(255, 207, 207, 207),
        ),
        body: _tasksView(),
        floatingActionButton: _addTaskButton());
  }

  Widget _addTaskButton() {
    return FloatingActionButton(
      backgroundColor: const Color.fromARGB(255, 207, 207, 207),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5))),
      child: const Icon(
        Icons.add,
        color: Color.fromARGB(255, 1, 18, 34),
      ),
      onPressed: _addTaskPopup,
    );
  }

  Widget _tasksView() {
    return FutureBuilder(
      future: Hive.openBox('tasks'),
      // future: Future.delayed(Duration(seconds: 2)),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          _taskBox = snapshot.data;
          return _taskList();
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _taskList() {
    // Task _newTask = Task(title: 'Task 3', date: DateTime.now());
    // _taskBox?.add(_newTask.toMap());
    List tasks = _taskBox!.values.toList();
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (BuildContext context, int index) {
        var task = Task.fromMap(tasks[index]);
        return ListTile(
          textColor: Color(0xFFFFFFFF),
          title: Text(
            task.title,
            style: TextStyle(
              fontSize: 18,
              color: task.isDone
                  ? Color.fromARGB(255, 220, 4, 4)
                  : const Color.fromARGB(255, 96, 227, 100),
              decoration: task.isDone ? TextDecoration.lineThrough : null,
              decorationColor: Colors.white,
              // decorationThickness: 2,
            ),
          ),
          subtitle: Text(
            task.date.toString(),
            style: TextStyle(
              decoration: task.isDone ? TextDecoration.lineThrough : null,
              decorationColor: Colors.white,
            ),
          ),
          trailing: Icon(
            task.isDone
                ? Icons.check_box_outlined
                : Icons.check_box_outline_blank,
            color: task.isDone
                ? Color.fromARGB(255, 220, 4, 4)
                : Color.fromARGB(255, 96, 227, 100),
          ),
          onTap: () {
            setState(() {
              task.isDone = !task.isDone;
              _taskBox?.putAt(index, task.toMap());
            });
          },
          onLongPress: () {
            setState(() {
              _taskBox?.deleteAt(index);
            });
          },
        );
      },
    );
  }

  void _addTaskPopup() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Add Task'),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5)),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  onChanged: (String value) {
                    _taskTitle = value;
                    // setState(() {
                    //   _taskTitle = value;
                    // });
                  },
                  onSubmitted: (String value) {
                    _taskTitle = value;
                  },
                  decoration: const InputDecoration(
                      hintText: 'Task name', labelText: 'Task'),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            5), // Adjust this value to change the border radius
                      ),
                      backgroundColor: const Color.fromARGB(255, 1, 18, 34),
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      if (_taskTitle != null) {
                        Task newTask =
                            Task(title: _taskTitle!, date: DateTime.now());
                        _taskBox?.add(newTask.toMap());
                        setState(() {
                          _taskTitle = null;
                          Navigator.of(context).pop();
                        });
                      }
                    },
                    child: const Text('Add Task'))
              ],
            ),
          );
        });
  }
}
