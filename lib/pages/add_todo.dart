import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:todo/Modal/save_task.dart';
import 'package:todo/Modal/task_model.dart';
import 'package:video_player/video_player.dart';

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

//image
  final ImagePicker _picker = ImagePicker();
  XFile? _imageFile;

  bool isSubmit = false;

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

  //music
  File? _selectedMusicFile;
  String? _audiofileName;
  final AudioPlayer _audioPlayer = AudioPlayer();

  Future<void> pickMusicFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mp3', 'wav', 'aac', 'm4a'],
      //allowedExtensions: ['mp3', 'wav', 'aac', 'm4a', 'mp4', 'avi', 'mov'],
    );

    if (result != null) {
      setState(() {
        _selectedMusicFile = File(result.files.single.path!);
        _audiofileName = result.files.single.name;
      });
      print('Selected Music File:${_selectedMusicFile!.path}');
    } else {
      print('No Music File Selected');
    }
  }

  void playMusic() async {
    if (_selectedMusicFile != null) {
      await _audioPlayer.play(DeviceFileSource(_selectedMusicFile!.path));
    }
  }

  void stopMusic() async {
    await _audioPlayer.stop();
  }

  //video
  File? _selectedVideoFile;
  String? _videofileName;
  VideoPlayerController? _videocontroller;

  Future<void> pickVideoFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mp4', 'avi', 'mov'],
    );

    if (result != null) {
      setState(() {
        _selectedVideoFile = File(result.files.single.path!);
        _videofileName = result.files.single.name;

        // Initialize the video player controller
        _videocontroller = VideoPlayerController.file(_selectedVideoFile!)
          ..initialize().then((_) {
            setState(() {});
          });
      });
      print('Selected Video File: ${_selectedVideoFile!.path}');
    } else {
      print('No Video File Selected');
    }
  }

  // Build video player with play and stop buttons
  Widget _buildVideoPlayer() {
    if (_videocontroller != null && _videocontroller!.value.isInitialized) {
      return Column(
        children: [
          AspectRatio(
            aspectRatio: _videocontroller!.value.aspectRatio,
            child: VideoPlayer(_videocontroller!),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {
                  setState(() {
                    _videocontroller!.play();
                  });
                },
                icon: Icon(Icons.play_arrow),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    _videocontroller!.pause();
                  });
                },
                icon: Icon(Icons.pause),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    _videocontroller!
                        .seekTo(Duration.zero); // Reset to the beginning
                    _videocontroller!.pause(); // Pause the video
                  });
                },
                icon: Icon(Icons.stop),
              ),
            ],
          ),
        ],
      );
    } else {
      return Center(child: CircularProgressIndicator());
    }
  }

  @override
  void dispose() {
    super.dispose();
    namecontroller.dispose();
    titlecontroller.dispose();
    desccontroller.dispose();
    _audioPlayer.dispose();
    _videocontroller?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
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
                SizedBox(
                  height: 2.h,
                ),
                ElevatedButton(
                    onPressed: pickMusicFile, child: Text('Pick Music')),
                _selectedMusicFile != null
                    ? Column(
                        children: [
                          Icon(
                            Icons.music_note,
                            size: 50,
                            color: Colors.blue,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            _audiofileName ?? 'Unknown File',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                onPressed: playMusic,
                                icon: Icon(
                                  Icons.play_arrow,
                                  size: 30,
                                  color: Colors.grey,
                                ),
                              ),
                              IconButton(
                                onPressed: stopMusic,
                                icon: Icon(
                                  Icons.stop,
                                  size: 30,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          )
                        ],
                      )
                    : Text('No File Selected'),
                SizedBox(
                  height: 2.h,
                ),
                ElevatedButton(
                    onPressed: pickVideoFile, child: Text('Pick Video')),
                _selectedVideoFile != null
                    ? Column(
                        children: [
                          Icon(
                            Icons.video_file,
                            size: 50,
                            color: Colors.blue,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          _buildVideoPlayer(),
                          Text(
                            _videofileName ?? 'Unknown File',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      )
                    : Text('No File Selected'),
                SizedBox(
                  height: 2.h,
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
                !isSubmit
                    ? ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            minimumSize: Size(70.w, 5.h),
                            padding: EdgeInsets.symmetric(
                                horizontal: 5.w, vertical: 2.h)),
                        onPressed: () async {
                          if (_form.currentState?.validate() ?? false) {
                            if (groupvalue == null) {
                              setState(() {
                                isGenderSelected = true;
                              });
                            } else {
                              setState(() {
                                isSubmit = true;
                              });
                              bool isSaved = await context
                                  .read<SaveTask>()
                                  .addTasks(
                                      Task(
                                          groupvalue: groupvalue!,
                                          name: namecontroller.text,
                                          description: desccontroller.text,
                                          title: titlecontroller.text,
                                          isCompleted: false,
                                          dateTime: DateTime.now(),
                                          imageUrl: '',
                                          audioUrl: '',
                                          videoUrl: ''),
                                      _imageFile,
                                      _selectedMusicFile,
                                      _selectedVideoFile);

                              if (isSaved) {
                                namecontroller.clear();
                                desccontroller.clear();
                                titlecontroller.clear();
                                Navigator.of(context).pop(true);
                              }
                            }
                          }
                        },
                        child: Text(
                          'Add',
                          style: TextStyle(fontSize: 20.sp),
                        ),
                      )
                    : CircularProgressIndicator()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
