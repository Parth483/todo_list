// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
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
                var i = 16;
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
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          color: Colors.white,
                          child: ListTile(
                            title: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Name',
                                          style: TextStyle(
                                              fontSize: i.sp,
                                              decoration: task.tasks[index]
                                                          .groupvalue ==
                                                      'Deactive'
                                                  ? TextDecoration.lineThrough
                                                  : TextDecoration.none),
                                        ),
                                        Text(
                                          'Title',
                                          style: TextStyle(
                                              fontSize: i.sp,
                                              decoration: task.tasks[index]
                                                          .groupvalue ==
                                                      'Deactive'
                                                  ? TextDecoration.lineThrough
                                                  : TextDecoration.none),
                                        ),
                                        Text(
                                          'Description',
                                          style: TextStyle(
                                              fontSize: i.sp,
                                              decoration: task.tasks[index]
                                                          .groupvalue ==
                                                      'Deactive'
                                                  ? TextDecoration.lineThrough
                                                  : TextDecoration.none),
                                        ),
                                        Text(
                                          'Date & Time',
                                          style: TextStyle(
                                              fontSize: i.sp,
                                              decoration: task.tasks[index]
                                                          .groupvalue ==
                                                      'Deactive'
                                                  ? TextDecoration.lineThrough
                                                  : TextDecoration.none),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          ':  ${task.tasks[index].name}',
                                          style: TextStyle(
                                              fontSize: i.sp,
                                              decoration: task.tasks[index]
                                                          .groupvalue ==
                                                      'Deactive'
                                                  ? TextDecoration.lineThrough
                                                  : TextDecoration.none),
                                        ),
                                        Text(
                                          ':  ${task.tasks[index].title}',
                                          style: TextStyle(
                                              fontSize: i.sp,
                                              decoration: task.tasks[index]
                                                          .groupvalue ==
                                                      'Deactive'
                                                  ? TextDecoration.lineThrough
                                                  : TextDecoration.none),
                                        ),
                                        Text(
                                          ':  ${task.tasks[index].description}',
                                          style: TextStyle(
                                              fontSize: i.sp,
                                              decoration: task.tasks[index]
                                                          .groupvalue ==
                                                      'Deactive'
                                                  ? TextDecoration.lineThrough
                                                  : TextDecoration.none),
                                        ),
                                        Text(
                                          ':  ${DateFormat('dd/MM/yy, hh:mm a').format(task.tasks[index].dateTime)}',
                                          style: TextStyle(
                                              fontSize: i.sp,
                                              decoration: task.tasks[index]
                                                          .groupvalue ==
                                                      'Deactive'
                                                  ? TextDecoration.lineThrough
                                                  : TextDecoration.none),
                                        ),
                                        Image.network(
                                          task.tasks[index]
                                              .imageUrl!, // Assuming you have an image URL in your model
                                          width: 50, // Adjust the width
                                          height: 50, // Adjust the height
                                          fit: BoxFit
                                              .cover, // Choose the fit type based on your need
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Positioned(
                                  //   top: 10,
                                  right: -90,
                                  child: Container(
                                    margin:
                                        EdgeInsets.only(left: 300, right: 20),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 7, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: task.tasks[index].groupvalue ==
                                              'Active'
                                          ? Colors.green
                                          : Colors.red,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      task.tasks[index].groupvalue,
                                      style: TextStyle(
                                          fontSize: 15, color: Colors.white),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            trailing: Wrap(
                              children: [
                                Checkbox(
                                    value:
                                        // task.tasks[index].groupvalue == 'Active'
                                        //     ? task.tasks[index].isCompleted
                                        task.tasks[index].isCompleted,
                                    onChanged: (_) {
                                      context
                                          .read<SaveTask>()
                                          .checkTasks(index);
                                    })
                              ],
                            ),
                          ),
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
