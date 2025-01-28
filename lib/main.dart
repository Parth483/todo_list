import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:todo/Modal/save_task.dart';
import 'package:todo/pages/add_todo.dart';
import 'package:todo/pages/todo_list.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  runApp(ChangeNotifierProvider(
      create: (context) => SaveTask(), child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(brightness: Brightness.dark),
        initialRoute: TodoList.todolist,
        routes: {
          TodoList.todolist: (context) => TodoList(),
          AddTodo.addtodo: (context) => AddTodo()
        },
      );
    });
  }
}
