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
    this.isPaid = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'description': description,
      'amount': amount,
      'dueDate': dueDate.toIso8601String(),
      'reminderDuration': reminderDuration.inMilliseconds,
      'isPaid': isPaid ? 1 : 0,
    };
  }

  static Bill fromMap(Map<String, dynamic> map) {
    return Bill(
      id: map['id'],
      description: map['description'],
      amount: map['amount'],
      dueDate: DateTime.parse(map['dueDate']),
      reminderDuration: Duration(milliseconds: map['reminderDuration']),
      isPaid: map['isPaid'] == 1,
    );
  }
}
