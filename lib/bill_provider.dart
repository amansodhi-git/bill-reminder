import 'package:flutter/material.dart';
import 'bill.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class BillProvider with ChangeNotifier {
  List<Bill> _bills = [];

  List<Bill> get bills => _bills;

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  BillProvider() {
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: AndroidInitializationSettings('@mipmap/ic_launcher'));
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void addBill(Bill bill) {
    _bills.add(bill);
    scheduleNotification(bill);
    notifyListeners();
  }

  void updateBill(Bill updatedBill) {
    final index = _bills.indexWhere((bill) => bill.id == updatedBill.id);
    if (index != -1) {
      _bills[index] = updatedBill;
      flutterLocalNotificationsPlugin.cancel(updatedBill.hashCode);
      scheduleNotification(updatedBill);
      notifyListeners();
    }
  }

  void scheduleNotification(Bill bill) {
    final scheduledNotificationDateTime =
        bill.dueDate.subtract(bill.reminderDuration);

    final androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'bill_reminder_channel', // channel ID
      'Bill Reminders', // channel name
      channelDescription: 'Reminders for upcoming bills', // channel description
      importance: Importance.max,
      priority: Priority.high,
    );

    final platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    flutterLocalNotificationsPlugin.schedule(
      bill.hashCode,
      'Bill Reminder',
      'Your bill "${bill.description}" is due on ${bill.dueDate}',
      scheduledNotificationDateTime,
      platformChannelSpecifics,
    );
  }
}
