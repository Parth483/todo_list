import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:todo/Modal/save_task.dart';
// import 'package:todo/Modal/task_model.dart';

class TodoList extends StatefulWidget {
  const TodoList({super.key});
  static const todolist = 'todolist';

  @override
  State<TodoList> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  @override
  void initState() {
    super.initState();
    _setupFirebase();

    _initializeLocalNotifications();
  }

  var _token;

  final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> _setupFirebase() async {
    // Request notification permissions (especially for iOS)
    await _requestPermission();

    // Get the FCM token
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    String? token = await messaging.getToken();
    setState(() {
      _token = token; // Save token for display
    });

    print('FCMToken: $_token');

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print(
          'Message Received:${message.notification?.title},${message.notification?.body}');

      _showNotification(message.notification?.title ?? 'No Title',
          message.notification?.body ?? 'No Body');
    });
  }

  Future<void> _requestPermission() async {
    NotificationSettings settings =
        await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User denied permission');
    }
  }

  Future<void> _initializeLocalNotifications() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: androidSettings);

    await _localNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> _showNotification(String title, String body) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'default_channel_id', // Channel ID
      'Default Channel', // Channel Name
      importance: Importance.high,
      priority: Priority.high,
    );

    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidDetails);

    await _localNotificationsPlugin.show(
      0, // Notification ID
      title,
      body,
      notificationDetails,
    );
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
