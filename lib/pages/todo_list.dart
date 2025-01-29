import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:todo/Firebase/Firebase.dart';
import 'package:todo/Modal/save_task.dart';
// import 'package:todo/Modal/task_model.dart';

class TodoList extends StatefulWidget {
  const TodoList({super.key});
  static const todolist = 'todolist';

  @override
  State<TodoList> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  final FirebaseService _firebaseService =
      FirebaseService(); // Instance of FirebaseService

  @override
  void initState() {
    super.initState();

    _firebaseService.setupFirebase(); // Initialize Firebase

    context.read<SaveTask>().fetchTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Todo List',
          style: TextStyle(fontSize: 20.sp),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed('addtodo').then((_) {
            context.read<SaveTask>().fetchTasks();
          });
        },
        child: Icon(
          Icons.add,
          size: 6.w,
        ),
      ),
      body: Consumer<SaveTask>(
        builder: (context, task, child) {
          return ListView.builder(
              itemCount: task.tasks.length,
              itemBuilder: (BuildContext context, index) {
                return Slidable(
                  endActionPane: ActionPane(motion: StretchMotion(), children: [
                    SlidableAction(
                      onPressed: (context) {
                        context.read<SaveTask>().deleteTasks(task.tasks[index]);
                      },
                      icon: Icons.delete,
                      borderRadius: BorderRadius.circular(2.w),
                      backgroundColor: Colors.red,
                      padding: EdgeInsets.symmetric(vertical: 2.h),
                    )
                  ]),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 30),
                        // color: Colors.green,
                        decoration: task.tasks[index].groupvalue == 'Active'
                            ? BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(15))
                            : BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(15)),
                        child: Text(
                          task.tasks[index].groupvalue,
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                      ListTile(
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              task.tasks[index].name,
                              style: TextStyle(
                                  fontSize: 20.sp,
                                  decoration: task.tasks[index].isCompleted
                                      ? TextDecoration.lineThrough
                                      : TextDecoration.none),
                            ),
                            Text(
                              task.tasks[index].title,
                              style: TextStyle(
                                  fontSize: 20.sp,
                                  decoration: task.tasks[index].isCompleted
                                      ? TextDecoration.lineThrough
                                      : TextDecoration.none),
                            ),
                            Text(
                              task.tasks[index].description,
                              style: TextStyle(
                                  fontSize: 20.sp,
                                  decoration: task.tasks[index].isCompleted
                                      ? TextDecoration.lineThrough
                                      : TextDecoration.none),
                            ),
                            Text(
                              DateFormat('dd MMM yyyy, hh:mm a')
                                  .format(task.tasks[index].dateTime),
                              style: TextStyle(
                                  fontSize: 20.sp,
                                  decoration: task.tasks[index].isCompleted
                                      ? TextDecoration.lineThrough
                                      : TextDecoration.none),
                            ),
                          ],
                        ),
                        trailing: Wrap(
                          children: [
                            Checkbox(
                                value: task.tasks[index].isCompleted,
                                onChanged: (_) {
                                  context.read<SaveTask>().checkTasks(index);
                                })
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 2.h,
                      )
                    ],
                  ),
                );
              });
        },
      ),
    );
  }
}
