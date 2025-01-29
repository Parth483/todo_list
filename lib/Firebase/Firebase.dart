// lib/services/firebase_service.dart

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FirebaseService {
  final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> setupFirebase() async {
    await _requestPermission();
    String? token = await _getFCMToken();
    print('FCM Token: $token');
    _listenForMessages();
  }

  Future<String?> _getFCMToken() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    return await messaging.getToken();
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

  void _listenForMessages() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print(
          'Message Received: ${message.notification?.title}, ${message.notification?.body}');
      _showNotification(message.notification?.title ?? 'No Title',
          message.notification?.body ?? 'No Body');
    });
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
}


//old code
//  Future<void> _setupFirebase() async {
//     // Request notification permissions (especially for iOS)
//     await _requestPermission();

//     // Get the FCM token
//     FirebaseMessaging messaging = FirebaseMessaging.instance;
//     String? token = await messaging.getToken();
//     setState(() {
//       _token = token; // Save token for display
//     });

//     print('FCMToken: $_token');

//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       print(
//           'Message Received:${message.notification?.title},${message.notification?.body}');

//       _showNotification(message.notification?.title ?? 'No Title',
//           message.notification?.body ?? 'No Body');
//     });
//   }

//   Future<void> _requestPermission() async {
//     NotificationSettings settings =
//         await FirebaseMessaging.instance.requestPermission(
//       alert: true,
//       announcement: false,
//       badge: true,
//       carPlay: false,
//       criticalAlert: false,
//       provisional: false,
//       sound: true,
//     );

//     if (settings.authorizationStatus == AuthorizationStatus.authorized) {
//       print('User granted permission');
//     } else if (settings.authorizationStatus ==
//         AuthorizationStatus.provisional) {
//       print('User granted provisional permission');
//     } else {
//       print('User denied permission');
//     }
//   }

//   Future<void> _initializeLocalNotifications() async {
//     const AndroidInitializationSettings androidSettings =
//         AndroidInitializationSettings('@mipmap/ic_launcher');
//     const InitializationSettings initializationSettings =
//         InitializationSettings(android: androidSettings);

//     await _localNotificationsPlugin.initialize(initializationSettings);
//   }

//   Future<void> _showNotification(String title, String body) async {
//     const AndroidNotificationDetails androidDetails =
//         AndroidNotificationDetails(
//       'default_channel_id', // Channel ID
//       'Default Channel', // Channel Name
//       importance: Importance.high,
//       priority: Priority.high,
//     );

//     const NotificationDetails notificationDetails =
//         NotificationDetails(android: androidDetails);

//     await _localNotificationsPlugin.show(
//       0, // Notification ID
//       title,
//       body,
//       notificationDetails,
//     );
//   }