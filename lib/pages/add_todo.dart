import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:todo/Modal/save_task.dart';
import 'package:todo/Modal/task_model.dart';

class AddTodo extends StatelessWidget {
  AddTodo({super.key});

  static const addtodo = 'addtodo';

  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Todo',
          style: TextStyle(fontSize: 20.sp),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.w),
        child: Column(
          children: [
            TextFormField(
              controller: controller,
              autofocus: true,
              decoration: InputDecoration(
                  hintText: 'Title', hintStyle: TextStyle(fontSize: 20.sp)),
              style: TextStyle(fontSize: 20.sp),
            ),
            SizedBox(
              height: 2.h,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  minimumSize: Size(70.w, 5.h),
                  padding:
                      EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h)),
              onPressed: () {
                context
                    .read<SaveTask>()
                    .addTask(Task(title: controller.text, isCompleted: false));
                controller.clear();
                Navigator.of(context).pop();
              },
              child: Text(
                'Add',
                style: TextStyle(fontSize: 20.sp),
              ),
            )
          ],
        ),
      ),
    );
  }
}
