import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'db_helper.dart';
import 'bill.dart';

class BillProvider with ChangeNotifier {
  List<Bill> _bills = [];
  final DBHelper _dbHelper = DBHelper();

  List<Bill> get bills => _bills;

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  BillProvider() {
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: AndroidInitializationSettings('@mipmap/ic_launcher'));
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
    _loadBills();
  }

  Future<void> _loadBills() async {
    _bills = await _dbHelper.getBills();
    notifyListeners();
  }

  Future<void> addBill(Bill bill) async {
    await _dbHelper.insertBill(bill);
    _bills.add(bill);
    scheduleNotification(bill);
    notifyListeners();
  }

  Future<void> updateBill(Bill updatedBill) async {
    await _dbHelper.updateBill(updatedBill);
    final index = _bills.indexWhere((bill) => bill.id == updatedBill.id);
    if (index != -1) {
      _bills[index] = updatedBill;
      flutterLocalNotificationsPlugin.cancel(updatedBill.hashCode);
      scheduleNotification(updatedBill);
      notifyListeners();
    }
  }

  Future<void> deleteBill(String id) async {
    await _dbHelper.deleteBill(id);
    _bills.removeWhere((bill) => bill.id == id);
    flutterLocalNotificationsPlugin.cancel(id.hashCode);
    notifyListeners();
  }

  void scheduleNotification(Bill bill) {
    final scheduledNotificationDateTime =
        bill.dueDate.subtract(bill.reminderDuration);

    final androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'bill_reminder_channel',
      'Bill Reminders',
      channelDescription: 'Reminders for upcoming bills',
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
