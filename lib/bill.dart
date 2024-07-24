class Bill {
  final String id;
  final String description;
  final double amount;
  final DateTime dueDate;
  final Duration reminderDuration;

  Bill({
    required this.id,
    required this.description,
    required this.amount,
    required this.dueDate,
    required this.reminderDuration,
  });

  // Convert a Bill object into a map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'description': description,
      'amount': amount,
      'dueDate': dueDate.toIso8601String(),
      'reminderDuration': reminderDuration.inDays,
    };
  }

  // Create a Bill object from a map
  factory Bill.fromMap(Map<String, dynamic> map) {
    return Bill(
      id: map['id'],
      description: map['description'],
      amount: map['amount'],
      dueDate: DateTime.parse(map['dueDate']),
      reminderDuration: Duration(days: map['reminderDuration']),
    );
  }
}
