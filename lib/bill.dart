class Bill {
  String id;
  String description;
  double amount;
  DateTime dueDate;
  Duration reminderDuration;

  Bill({
    required this.id,
    required this.description,
    required this.amount,
    required this.dueDate,
    required this.reminderDuration,
  });
}
