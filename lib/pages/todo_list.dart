import 'package:flutter/material.dart';

import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';
import 'package:todo/Firebase/Firebase.dart';
import 'package:todo/Modal/save_task.dart';

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
          Navigator.of(context).pushNamed('addtodo').then((result) {
            if (result == true) {
              context.read<SaveTask>().fetchTasks();
            }
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
                        margin: const EdgeInsets.only(
                            bottom: 5, left: 10, right: 10),
                        child: Card(
                          elevation: 0.5,
                          color: Colors.white,
                          child: ListTile(
                            contentPadding:
                                EdgeInsets.only(left: 2.w, right: 2.w),
                            title: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(14),
                                          border:
                                              Border.all(color: Colors.green)),
                                      child: Card(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(14)),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(14),
                                          child: task.tasks[index].imageUrl!
                                                  .isEmpty
                                              ? Shimmer.fromColors(
                                                  baseColor: Colors.grey[300]!,
                                                  highlightColor:
                                                      Colors.grey[100]!,
                                                  period: Duration(seconds: 1),
                                                  child: Container(
                                                      width: 80,
                                                      height: 80,
                                                      color: Colors.white),
                                                )
                                              : Image.network(
                                                  task.tasks[index]
                                                      .imageUrl!, // Assuming you have an image URL in your model
                                                  width: 80, // Adjust the width
                                                  height:
                                                      80, // Adjust the height
                                                  fit: BoxFit
                                                      .cover, // Choose the fit type based on your need
                                                ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        getRow(
                                            'Name',
                                            task.tasks[index].groupvalue,
                                            task.tasks[index].name,
                                            0),
                                        getRow(
                                            'Title',
                                            task.tasks[index].groupvalue,
                                            task.tasks[index].title,
                                            1),
                                        getRow(
                                            'Description',
                                            task.tasks[index].groupvalue,
                                            task.tasks[index].description,
                                            2),
                                        getRow(
                                            'Date & Time',
                                            task.tasks[index].groupvalue,
                                            DateFormat('dd/MM/yy, hh:mm a')
                                                .format(
                                                    task.tasks[index].dateTime),
                                            3),
                                      ],
                                    ),
                                  ],
                                ),
                                Positioned(
                                  //   top: 10,
                                  right: -85,
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
                                          fontSize: 10, color: Colors.white),
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
                      // SizedBox(
                      //   height: 2.h,
                      // )
                    ],
                  ),
                );
              });
        },
      ),
    );
  }

  Widget getRow(title, data, value, index) {
    return Row(
      children: [
        Text(
          title,
          style: TextStyle(
              fontSize: 13.sp,
              decoration: data == 'Deactive'
                  ? TextDecoration.lineThrough
                  : TextDecoration.none),
        ),
        SizedBox(
            width: index == 0
                ? 9.w
                : index == 1
                    ? 10.6.w
                    : index == 2
                        ? 2.w
                        : 1.3.w),
        Text(
          ':',
          style: TextStyle(
            fontSize: 13.sp,
          ),
        ),
        SizedBox(width: 1.w),
        Text(
          value,
          style: TextStyle(
              fontSize: 13.sp,
              decoration: data == 'Deactive'
                  ? TextDecoration.lineThrough
                  : TextDecoration.none),
        ),
      ],
    );
  }
}
