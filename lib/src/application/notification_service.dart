import 'dart:convert';
import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationsService {
  static late final FirebaseMessaging _messaging;

  static Future<void> init() async {
    _messaging = FirebaseMessaging.instance;
    // TODO: need to save it on firestore
    // await _getFCMToken(); // TODO probably not needed here?
    // register a handler for background notifications
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    // initialize local notifications
    await _initialiazeLocalNotifications();
    // check permission for sending notification and listen to the forground notifications stream
    AuthorizationStatus permission = await _requestPermission();
    if (permission == AuthorizationStatus.authorized) {
      // handle foreground notifications
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print(
            '==========  got foreground message notification ${message.notification?.body}');
        showNotification(
          message.notification?.title,
          message.notification?.body,
          json.encode(message.data),
        );
      });
    }
  }

  /// Handle background notifications
  @pragma('vm:entry-point')
  static Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    print(
        '==========  got backgroung message notification ${message.notification?.body}');
    await showNotification(
      message.notification?.title,
      message.notification?.body,
      json.encode(message.data),
    );
  }

  /// Request user's permission for notifications
  static Future<AuthorizationStatus> _requestPermission() async {
    var settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );
    print(
        '============ notifications permission: ${settings.authorizationStatus}');

    return settings.authorizationStatus;
  }

  /// Gets device's registration token for Firebase Cloud Messaging
  static Future<String?> _getFCMToken() async {
    var fcmToken = await _messaging.getToken();
    print('============= got token $fcmToken');
    return fcmToken;
  }

  static final _localNotificationsPlugin = FlutterLocalNotificationsPlugin();

  /// Initialize FlutterLocalNotificationsPlugin with settings for each platform
  static Future<void> _initialiazeLocalNotifications() async {
    final initializationSettings = InitializationSettings(
      // stored in \android\app\src\main\res\drawable\
      android: const AndroidInitializationSettings('push_icon'),
      iOS: DarwinInitializationSettings(
        onDidReceiveLocalNotification: (id, title, body, payload) =>
            showNotification(title, body, payload),
      ),
    );
    // Initialise the time zone database for scheduled local notifications
    tz.initializeTimeZones();

    await _localNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (_) => {});
  }

  static const AndroidNotificationDetails _androidNotificationDetails =
      AndroidNotificationDetails(
    'notifications',
    'notifications',
    // color: Colors.white,
    importance: Importance.max,
    priority: Priority.high,
    ticker: 'ticker',
  );

  static const DarwinNotificationDetails _darwinNotificationDetails =
      DarwinNotificationDetails();

  static const NotificationDetails _notificationDetails = NotificationDetails(
    android: _androidNotificationDetails,
    iOS: _darwinNotificationDetails,
  );

  /// Show flutter_local_notifications
  static Future<void> showNotification(
    String? title,
    String? body,
    String? payload,
  ) async {
    _localNotificationsPlugin.show(
      Random().nextInt(2147483647),
      title,
      body,
      _notificationDetails,
      payload: payload,
    );
  }

  static Future<void> scheduleNotification(
      {required int id,
      required DateTime scheduledTime,
      String? title,
      String? body,
      String? payload}) async {
    _localNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledTime, tz.local),
      _notificationDetails,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: payload,
    );
  }

  static Future<void> cancelNotification(int id) =>
      _localNotificationsPlugin.cancel(id);
}

final fCMTokenProvider = FutureProvider<String?>((ref) async {
  return NotificationsService._getFCMToken();
});

// final firebaseMessagingProvider =
//     Provider<FirebaseMessaging>((ref) => FirebaseMessaging.instance);

// final notificationsServiceProvider = Provider<NotificationsService>((ref) {
//   final messaging = ref.watch(firebaseMessagingProvider);
//   return NotificationsService(messaging);
// });
