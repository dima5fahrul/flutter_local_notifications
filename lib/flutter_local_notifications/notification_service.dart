import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

import 'utils.dart';

class NotificationService {
  static final _notifications = FlutterLocalNotificationsPlugin();
  static final onNotifications = BehaviorSubject<String?>();

  static Future initialize({bool initScheduled = false}) async {
    const initSettingsAndroid = AndroidInitializationSettings('logo');
    const initSettings = InitializationSettings(android: initSettingsAndroid);

    // final details = await _notifications.getNotificationAppLaunchDetails();
    // if (details != null && details.didNotificationLaunchApp) {
    //   onNotifications.add(details.payload);
    // }

    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse payload) async {
        onNotifications.add(payload.toString());
      },
    );

    if (initScheduled) {
      tz.initializeTimeZones();
      final locationName = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(locationName));
    }
  }

  static Future notificationDetails() async {
    final largeIconPath = await Utils.downloadFile(
      'https://images.unsplash.com/photo-1688202408403-b0053d377d37?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=764&q=80',
      'largeIcon',
    );

    final bigPicturePath = await Utils.downloadFile(
        'https://images.unsplash.com/photo-1688141585146-1fb4a1358c87?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1170&q=80',
        'bigPicture');

    final styleInformation = BigPictureStyleInformation(
      FilePathAndroidBitmap(bigPicturePath),
      largeIcon: FilePathAndroidBitmap(largeIconPath),
    );

    return NotificationDetails(
      android: AndroidNotificationDetails(
        'channel id',
        'channel name',
        channelShowBadge: true,
        icon: 'logo',
        largeIcon: const DrawableResourceAndroidBitmap('logo'),
        importance: Importance.max,
        styleInformation: styleInformation,
      ),
    );
  }

  static Future sendNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
  }) async =>
      _notifications.show(
        id,
        title,
        body,
        await notificationDetails(),
        payload: payload,
      );

  static Future sendScheduledNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
    required DateTime scheduleDate,
  }) async =>
      _notifications.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.from(scheduleDate, tz.local),
        await notificationDetails(),
        // ignore: deprecated_member_use
        androidAllowWhileIdle: true,
        payload: payload,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );

  static Future<void> sendDailyNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
    required TimeOfDay scheduleTime,
  }) async {
    final now = DateTime.now();
    final scheduleDate = DateTime(
        now.year, now.month, now.day, scheduleTime.hour, scheduleTime.minute);
    final tzScheduleDate = tz.TZDateTime.from(scheduleDate, tz.local);

    await _notifications.zonedSchedule(
      id,
      title,
      body,
      tzScheduleDate,
      await notificationDetails(),
      // ignore: deprecated_member_use
      androidAllowWhileIdle: true,
      payload: payload,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  static Future<void> sendWeeklyNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
  }) async {
    final now = DateTime.now();
    final nextTuesday = now.add(Duration(days: DateTime.tuesday - now.weekday));
    final nextSaturday =
        now.add(Duration(days: DateTime.saturday - now.weekday));

    final scheduleDates = [
      DateTime(nextTuesday.year, nextTuesday.month, nextTuesday.day, 11, 0),
      DateTime(nextSaturday.year, nextSaturday.month, nextSaturday.day, 11, 0),
    ];

    for (final scheduleDate in scheduleDates) {
      final tzScheduleDate = tz.TZDateTime.from(scheduleDate, tz.local);

      await _notifications.zonedSchedule(
        id,
        title,
        body,
        tzScheduleDate,
        await notificationDetails(),
        // ignore: deprecated_member_use
        androidAllowWhileIdle: true,
        payload: payload,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
      );
    }
  }
}
