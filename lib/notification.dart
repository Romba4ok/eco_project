import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    _initNotifications();
  }

  void _initNotifications() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings settings =
        InitializationSettings(android: androidSettings);

    await _notificationsPlugin.initialize(settings);
  }
  Future<void> _showNotification() async {
    int notificationId =
        DateTime.now().millisecondsSinceEpoch.remainder(100000);
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails('channel_id', 'Основной канал',
            channelDescription: 'Описание канала',
            importance: Importance.high,
            priority: Priority.high,
            ticker: 'ticker',
            icon: '@drawable/notificationlogo');

    const NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
    );

    await _notificationsPlugin.show(
      notificationId,
      'ECO • Слоган',
      'Чтотото и ещё что-то и так далее\nну придумать текст нужно',
      platformDetails,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text("Push Notification Example")),
        body: Center(
          child: ElevatedButton(
            onPressed: _showNotification,
            child: const Text("Показать уведомление"),
          ),
        ),
      ),
    );
  }
}
