import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:todo/Modal/save_task.dart';
import 'package:todo/Modal/task_model.dart';

class AddTodo extends StatefulWidget {
  AddTodo({super.key});

  static const addtodo = 'addtodo';

  @override
  State<AddTodo> createState() => _AddTodoState();
}

class _AddTodoState extends State<AddTodo> {
  final namecontroller = TextEditingController();

  final titlecontroller = TextEditingController();

  final desccontroller = TextEditingController();
  final GlobalKey<FormState> _form = GlobalKey<FormState>();

  String? groupvalue;

  bool isGenderSelected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Todo',
          style: TextStyle(fontSize: 20.sp),
        ),
        titleSpacing: 0,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.w),
        child: Form(
          key: _form,
          child: Column(
            children: [
              TextFormField(
                controller: namecontroller,
                autofocus: true,
                decoration: InputDecoration(
                    hintText: 'Name', hintStyle: TextStyle(fontSize: 20.sp)),
                style: TextStyle(fontSize: 20.sp),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please Enter Name';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 2.h,
              ),
              TextFormField(
                controller: titlecontroller,
                autofocus: true,
                decoration: InputDecoration(
                    hintText: 'Title', hintStyle: TextStyle(fontSize: 20.sp)),
                style: TextStyle(fontSize: 20.sp),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please Enter Title';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 2.h,
              ),
              TextFormField(
                controller: desccontroller,
                autofocus: true,
                decoration: InputDecoration(
                    hintText: 'Description',
                    hintStyle: TextStyle(fontSize: 20.sp)),
                style: TextStyle(fontSize: 20.sp),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please Enter Description';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 2.h,
              ),
              Row(
                children: [
                  Text(
                    'Active',
                    style: TextStyle(fontSize: 20),
                  ),
                  Radio(
                      value: 'Active',
                      groupValue: groupvalue,
                      onChanged: (value) {
                        setState(() {
                          groupvalue = value!;
                        });
                      }),
                  // Text('Deactive'),
                  // Radio(
                  //     value: 'Deactive',
                  //     groupValue: groupvalue,
                  //     onChanged: (value) {
                  //       setState(() {
                  //         groupvalue = value!;
                  //       });
                  //     })
                ],
              ),
              if (isGenderSelected)
                Container(
                    padding: EdgeInsets.only(right: 190),
                    child: Text(
                      'Please Select The Status',
                      style: TextStyle(
                          fontSize: 2.h,
                          color: const Color.fromARGB(255, 185, 39, 31)),
                    )),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    minimumSize: Size(70.w, 5.h),
                    padding:
                        EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h)),
                onPressed: () {
                  if (_form.currentState?.validate() ?? false) {
                    if (groupvalue == null) {
                      setState(() {
                        isGenderSelected = true;
                      });
                    } else {
                      context.read<SaveTask>().addTasks(Task(
                          groupvalue: groupvalue!,
                          name: namecontroller.text,
                          description: desccontroller.text,
                          title: titlecontroller.text,
                          isCompleted: false,
                          dateTime: DateTime.now()));
                      namecontroller.clear();
                      desccontroller.clear();
                      titlecontroller.clear();
                      Navigator.of(context).pop();
                    }
                  }
                },
                child: Text(
                  'Add',
                  style: TextStyle(fontSize: 20.sp),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
