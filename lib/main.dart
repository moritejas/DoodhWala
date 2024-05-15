// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'homepage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home:MyApp(),
      home: const Dudhwale(),
    );
  }
}

// import 'package:flutter/material.dart';
//
// void main() {
//   runApp(MyApp());
// }

class Task {
  String id;
  String title;
  bool completed;

  Task({required this.id, required this.title, this.completed = false});
}

// ignore: use_key_in_widget_constructors
class TaskList extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _TaskListState createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  List<Task> tasks = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task List '),
      ),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(tasks[index].title),
            trailing: Checkbox(
              value: tasks[index].completed,
              onChanged: (value) {
                setState(() {
                  tasks[index].completed = value!;
                });
              },
            ),
            onTap: () {
              // Navigate to task detail screen or perform update operation
            },
            onLongPress: () {
              // Perform delete operation
              setState(() {
                tasks.removeAt(index);
              });
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to task creation screen
          // or call a function to add task
          _addTask();
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _addTask() {
    setState(() {
      tasks.add(Task(id: '1', title: 'New Task'));
    });
  }
}
