import 'package:flutter/material.dart';

import 'notification_service.dart';
import '../flutter_local_notifications/seconds_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    NotificationService.initialize(initScheduled: true);
    listenNotifications();
  }

  void listenNotifications() =>
      NotificationService.onNotifications.stream.listen(onClickedNotification);

  void onClickedNotification(String? payload) =>
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => SecondScreen(payload: payload),
      ));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Flutter Local Notifications'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => NotificationService.sendNotification(
                  title: 'Dimas Fahrul',
                  body: 'Do we have everything need for the lunch today?',
                  payload: 'dimas.fahrul',
                ),
                child: const Text('Trigger Notification'),
              ),
              ElevatedButton(
                onPressed: () => NotificationService.sendScheduledNotification(
                        title: 'Dimas Fahrul',
                        body: 'Do we have everything need for the lunch today?',
                        payload: 'dimas.fahrul',
                        scheduleDate:
                            DateTime.now().add(const Duration(seconds: 10)))
                    .then(
                  (_) => showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Secheduled Notification'),
                      content: const Text(
                          'You will be send notification after 10 second'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Ok'),
                        ),
                      ],
                    ),
                  ),
                ),
                child: const Text('Trigger Notification in 10 seconds'),
              ),
              ElevatedButton(
                onPressed: () => NotificationService.sendDailyNotification(
                  title: 'Dimas Fahrul',
                  body: 'Do we have everything need for the lunch today?',
                  payload: 'dimas.fahrul',
                  scheduleTime: const TimeOfDay(hour: 10, minute: 0),
                ).then(
                  (_) => showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Daily Notification'),
                      content: const Text(
                          'You will be send notification everyday at 10:00 AM'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Ok'),
                        ),
                      ],
                    ),
                  ),
                ),
                child: const Text('Trigger Notification daily at 10:00 AM'),
              ),
            ],
          ),
        ));
  }
}
