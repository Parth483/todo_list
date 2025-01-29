import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todo/Modal/task_model.dart';

class SaveTask extends ChangeNotifier {
  List<Task> _tasks = [];

  List<Task> get tasks => _tasks;

  final CollectionReference _taskcollection =
      FirebaseFirestore.instance.collection('tasks');

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
            dateTime: dateTime);
      }).toList();
      notifyListeners();
    } catch (e) {
      print('Error fetching tasks:$e');
    }
  }

  Future<void> addTasks(Task task) async {
    try {
      await _taskcollection.add({
        'name': task.name,
        'description': task.description,
        'title': task.title,
        'isCompleted': task.isCompleted,
        'timestamp': FieldValue.serverTimestamp(),
        'groupvalue': task.groupvalue
      });
      // _tasks.add(task);
      notifyListeners();
    } catch (e) {
      print('Failed to add task:$e');
    }
  }

  Future<void> deleteTasks(Task task) async {
    try {
      final taskDoc = await _taskcollection
          .where('title', isEqualTo: task.title)
          .where('isCompleted', isEqualTo: task.isCompleted)
          .where('name', isEqualTo: task.name)
          .where('description', isEqualTo: task.description)
          .where('groupvalue', isEqualTo: task.groupvalue)
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
