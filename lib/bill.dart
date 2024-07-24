class Bill {
  final String id;
  final String description;
  final double amount;
  final DateTime dueDate;
  final Duration reminderDuration;
  final bool isPaid;

  Bill({
    required this.id,
    required this.description,
    required this.amount,
    required this.dueDate,
    required this.reminderDuration,
    required this.isPaid,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'description': description,
      'amount': amount,
      'dueDate': dueDate.toIso8601String(),
      'reminderDuration': reminderDuration.inDays,
      'isPaid': isPaid ? 1 : 0,
    };
  }
}
