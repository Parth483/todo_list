import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
        title: Text('Add Todo'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            TextFormField(
              controller: controller,
              autofocus: true,
              decoration: InputDecoration(hintText: 'Title'),
            ),
            SizedBox(
              height: 15,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  minimumSize: Size(300, 50),
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15)),
              onPressed: () {
                context
                    .read<SaveTask>()
                    .addTask(Task(title: controller.text, isCompleted: false));
                controller.clear();
                Navigator.of(context).pop();
              },
              child: Text('Add'),
            )
          ],
        ),
      ),
    );
  }
}
