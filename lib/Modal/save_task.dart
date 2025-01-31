import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:todo/Modal/task_model.dart';

class SaveTask extends ChangeNotifier {
  List<Task> _tasks = [];

  List<Task> get tasks => _tasks;

  final CollectionReference _taskcollection =
      FirebaseFirestore.instance.collection('tasks');

  Future<String> uploadImageToFirebase(XFile image) async {
    try {
      // Get the file name and reference
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('task_images/$fileName');

      // Upload the file
      await ref.putFile(File(image.path));

      // Get the download URL of the uploaded image
      String downloadUrl = await ref.getDownloadURL();
      print('Image uploaded successfully: $downloadUrl');
      return downloadUrl;
    } catch (e) {
      print('Error uploading image: $e');
      return '';
    }
  }

  Future<String> uploadAudioToFirebase(File audioFile) async {
    try {
      // Get the file name and reference
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('task_audios/$fileName');

      // Upload the file
      await ref.putFile(audioFile);

      // Get the download URL of the uploaded audio file
      String downloadUrl = await ref.getDownloadURL();
      print('Audio uploaded successfully: $downloadUrl');
      return downloadUrl;
    } catch (e) {
      print('Error uploading audio: $e');
      return '';
    }
  }

  Future<String> uploadVideoToFirebase(File videoFile) async {
    try {
      // Get the file name and reference
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('task_videos/$fileName');

      // Upload the file
      await ref.putFile(videoFile);

      // Get the download URL of the uploaded audio file
      String downloadUrl = await ref.getDownloadURL();
      print('video uploaded successfully: $downloadUrl');
      return downloadUrl;
    } catch (e) {
      print('Error uploading video: $e');
      return '';
    }
  }

  Future<bool> addTasks(
      Task task, XFile? image, File? audio, File? video) async {
    try {
      String imageUrl = '';
      String audioUrl = '';
      String videoUrl = '';

      if (image != null) {
        imageUrl = await uploadImageToFirebase(image);
      }

      if (audio != null) {
        audioUrl = await uploadAudioToFirebase(audio);
      }

      if (video != null) {
        videoUrl = await uploadVideoToFirebase(video);
      }
      // print('imageUrl:' + imageUrl);

      await _taskcollection.add({
        'name': task.name,
        'description': task.description,
        'title': task.title,
        'isCompleted': task.isCompleted,
        'timestamp': FieldValue.serverTimestamp(),
        'groupvalue': task.groupvalue,
        'imageUrl': imageUrl,
        'audioUrl': audioUrl,
        'videoUrl': videoUrl
      });
      // _tasks.add(task);
      notifyListeners();
      return true;
    } catch (e) {
      print('Failed to add task:$e');
      return false;
    }
  }

  Future<void> fetchTasks() async {
    try {
      final QuerySnapshot snapshot =
          await _taskcollection.orderBy('timestamp').get();
      _tasks = snapshot.docs.map((doc) {
        var timestamp = doc['timestamp'];
        DateTime dateTime = timestamp != null && timestamp is Timestamp
            ? timestamp.toDate()
            : DateTime.now();

        return Task(
            name: doc['name'],
            description: doc['description'],
            title: doc['title'],
            isCompleted: doc['isCompleted'],
            groupvalue: doc['groupvalue'],
            dateTime: dateTime,
            imageUrl: doc['imageUrl'],
            audioUrl: doc['audioUrl'],
            videoUrl: doc['videoUrl']);
      }).toList();
      notifyListeners();
    } catch (e) {
      print('Error fetching tasks:$e');
    }
  }

  Future<void> deleteTasks(Task task) async {
    try {
      if (task.imageUrl!.isNotEmpty) {
        try {
          final ref = firebase_storage.FirebaseStorage.instance
              .refFromURL(task.imageUrl!);
          await ref.delete();
          print('image deleted successfully from Firebase Storage');
        } catch (e) {
          print('Error deleting image from Firebase Stroage:$e');
        }
      }

      if (task.audioUrl!.isNotEmpty) {
        try {
          final ref = firebase_storage.FirebaseStorage.instance
              .refFromURL(task.audioUrl!);
          await ref.delete();
          print('Audio deleted successfully from Firebase Storage');
        } catch (e) {
          print('Error deleting audio from Firebase Storage: $e');
        }
      }

      if (task.videoUrl!.isNotEmpty) {
        try {
          final ref = firebase_storage.FirebaseStorage.instance
              .refFromURL(task.videoUrl!);
          await ref.delete();
          print('Audio deleted successfully from Firebase Storage');
        } catch (e) {
          print('Error deleting audio from Firebase Storage: $e');
        }
      }
      final taskDoc = await _taskcollection
          .where('title', isEqualTo: task.title)
          .where('isCompleted', isEqualTo: task.isCompleted)
          .where('name', isEqualTo: task.name)
          .where('description', isEqualTo: task.description)
          .where('groupvalue', isEqualTo: task.groupvalue)
          .where('imageUrl', isEqualTo: task.imageUrl)
          .where('audioUrl', isEqualTo: task.audioUrl)
          .where('videoUrl', isEqualTo: task.videoUrl)
          .get();

      if (taskDoc.docs.isNotEmpty) {
        await _taskcollection.doc(taskDoc.docs.first.id).delete();
        _tasks.remove(task);
        notifyListeners();
      }
    } catch (e) {
      print('failed to delete tasK:$e');
    }
  }

  Future<void> checkTasks(
    int index,
  ) async {
    try {
      Task task = _tasks[index];

      task.isDone();

      String newGroupvalue = task.isCompleted ? 'Deactive' : 'Active';
      task.groupvalue = newGroupvalue;

      _tasks[index] = task;

      final taskDoc = await _taskcollection
          .where('title', isEqualTo: task.title)
          .where('name', isEqualTo: task.name)
          .where('description', isEqualTo: task.description)
          .get();

      if (taskDoc.docs.isNotEmpty) {
        await _taskcollection.doc(taskDoc.docs.first.id).update(
            {'isCompleted': task.isCompleted, 'groupvalue': newGroupvalue});
        notifyListeners();
      }
    } catch (e) {
      print('Failed to update task completion:$e');
    }
  }

  // Future<void> updateGroupvalue(String newGroupvalue,Task task) async {
  //   try {

  //     task.groupvalue = newGroupvalue;

  //     final taskDoc = await _taskcollection
  //         .where('title', isEqualTo: task.title)
  //         .where('name', isEqualTo: task.name)
  //         .where('description', isEqualTo: task.description)
  //         .where('groupvalue', isEqualTo: task.groupvalue)
  //         .get();

  //     if (taskDoc.docs.isNotEmpty) {
  //       await _taskcollection
  //           .doc(taskDoc.docs.first.id)
  //           .update({'groupvalue': newGroupvalue});

  //       notifyListeners();
  //     }
  //   } catch (e) {
  //     print('Failed to update groupvalue:$e');
  //   }
  // }

  // void addTask(Task task) {
  //   tasks.add(task);
  //   notifyListeners();
  // }

  // void deleteTask(Task task) {
  //   tasks.remove(task);

  //   notifyListeners();
  // }

  // void checkTask(int index) {
  //   tasks[index].isDone();
  //   notifyListeners();
  // }
}
