import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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

  final ImagePicker _picker = ImagePicker();
  XFile? _imageFile;

  Future<void> _pickImage({iscamera}) async {
    final XFile? image = await _picker.pickImage(
        source: iscamera == true ? ImageSource.camera : ImageSource.gallery);
    if (image != null) {
      print('Picked Image Path:${image.path}');
      setState(() {
        _imageFile = image;
      });
    } else {
      print('No image selected');
    }
  }

  Future showOptions() async {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        actions: [
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.of(context).pop();

              _pickImage(iscamera: false);
            },
            child: Text('Photo Gallery'),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.of(context).pop();

              _pickImage(iscamera: true);
            },
            child: Text('Camera'),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                _imageFile = null;
              });
            },
            child: Text('Remove Picture'),
          ),
        ],
      ),
    );
  }

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
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w),
          child: Form(
            key: _form,
            child: Column(
              children: [
                GestureDetector(
                  onTap: showOptions,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      // border: Border.all(color: Colors.grey,),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: _imageFile == null
                        ? Icon(
                            Icons.account_circle,
                            size: 100,
                          )
                        // ? Container(
                        //     alignment: Alignment.center,
                        //     child: const Column(
                        //       crossAxisAlignment:
                        //           CrossAxisAlignment.center,
                        //       mainAxisAlignment:
                        //           MainAxisAlignment.center,
                        //       children: [
                        //         Icon(
                        //           Icons.image,
                        //           size: 40,
                        //           color: Colors.grey,
                        //         ),
                        //         Text(
                        //           'No image selected.',
                        //           textAlign: TextAlign.center,
                        //         ),
                        //       ],
                        //     ))
                        : ClipOval(
                            child: Image.file(
                              File(_imageFile!.path),
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                  ),
                ),
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
      ),
    );
  }
}
