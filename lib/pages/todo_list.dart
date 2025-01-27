import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:todo/Modal/save_task.dart';
// import 'package:todo/Modal/task_model.dart';

class TodoList extends StatelessWidget {
  const TodoList({super.key});
  static const todolist = 'todolist';

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
          Navigator.of(context).pushNamed('addtodo');
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
                        context.read<SaveTask>().deleteTask(task.tasks[index]);
                      },
                      icon: Icons.delete,
                      borderRadius: BorderRadius.circular(2.w),
                      backgroundColor: Colors.red,
                      padding: EdgeInsets.symmetric(vertical: 2.h),
                    )
                  ]),
                  child: Column(
                    children: [
                      ListTile(
                        title: Text(
                          task.tasks[index].title,
                          style: TextStyle(
                              fontSize: 20.sp,
                              decoration: task.tasks[index].isCompleted
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none),
                        ),
                        trailing: Wrap(
                          children: [
                            Checkbox(
                                value: task.tasks[index].isCompleted,
                                onChanged: (_) {
                                  context.read<SaveTask>().checkTask(index);
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
