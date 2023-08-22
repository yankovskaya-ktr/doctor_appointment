import 'dart:convert';
import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationsService {
  static late final FirebaseMessaging _messaging;

  static Future<void> registerNotifications() async {
    _messaging = FirebaseMessaging.instance;
    // TODO: need to save it on firestore

    await _getFCMToken(); // TODO probably not needed here?
    // register a handler for background notifications
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    // initialize local notifications
    await _initialiazeLocalNotifications();
    // check permission for sending notification and listen to the forground notifications stream
    AuthorizationStatus permission = await _requestPermission();
    if (permission == AuthorizationStatus.authorized) {
      //
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        _showNotification(
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
    await _showNotification(
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
    return settings.authorizationStatus;
  }

  /// Gets device's registration token needed for sending notification
  static Future<String?> _getFCMToken() async {
    var fcmToken = await _messaging.getToken();
    print('============= got token $fcmToken');
    return fcmToken;
  }

  static final _localNotificationsPlugin = FlutterLocalNotificationsPlugin();

  /// Initialize FlutterLocalNotificationsPlugin with settings for each platform
  static Future<void> _initialiazeLocalNotifications() async {
    final initializationSettings = InitializationSettings(
      android: const AndroidInitializationSettings('notification_icon_push'),
      iOS: DarwinInitializationSettings(
        onDidReceiveLocalNotification: (id, title, body, payload) =>
            _showNotification(title, body, payload),
      ),
    );

    await _localNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (_) => {});
  }

  /// Show flutter_local_notifications notification
  static Future<void> _showNotification(
    String? title,
    String? body,
    String? payload,
  ) async {
    var androidSpecifics = const AndroidNotificationDetails(
      'notifications',
      'notifications',
      // color: Colors.white,
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );
    var iOSSpecifics = const DarwinNotificationDetails();

    var platformChannelSpecifics = NotificationDetails(
      android: androidSpecifics,
      iOS: iOSSpecifics,
    );

    await _localNotificationsPlugin.show(
      Random().nextInt(2147483647),
      title,
      body,
      platformChannelSpecifics,
      payload: payload,
    );
  }
}

// final firebaseMessagingProvider =
//     Provider<FirebaseMessaging>((ref) => FirebaseMessaging.instance);

// final notificationsServiceProvider = Provider<NotificationsService>((ref) {
//   final messaging = ref.watch(firebaseMessagingProvider);
//   return NotificationsService(messaging);
// });
