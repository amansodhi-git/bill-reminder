import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'bill_provider.dart';
import 'bill.dart';

class AddBillScreen extends StatefulWidget {
  @override
  _AddBillScreenState createState() => _AddBillScreenState();
}

class _AddBillScreenState extends State<AddBillScreen> {
  final _descriptionController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  Duration _reminderDuration = Duration(days: 1);
  bool _isPaid = false;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate)
      setState(() {
        _selectedDate = picked;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Bill'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            TextField(
              controller: _amountController,
              decoration: InputDecoration(labelText: 'Amount'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Text('Due Date: '),
                TextButton(
                  onPressed: () => _selectDate(context),
                  child: Text("${_selectedDate.toLocal()}".split(' ')[0]),
                ),
              ],
            ),
            Row(
              children: [
                Text('Reminder: '),
                DropdownButton<Duration>(
                  value: _reminderDuration,
                  onChanged: (Duration? newValue) {
                    setState(() {
                      _reminderDuration = newValue!;
                    });
                  },
                  items: <Duration>[
                    Duration(days: 1),
                    Duration(days: 2),
                    Duration(days: 3),
                    Duration(days: 7),
                  ].map<DropdownMenuItem<Duration>>((Duration value) {
                    return DropdownMenuItem<Duration>(
                      value: value,
                      child: Text('${value.inDays} days before'),
                    );
                  }).toList(),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Paid:'),
                Switch(
                  value: _isPaid,
                  onChanged: (bool value) {
                    setState(() {
                      _isPaid = value;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final newBill = Bill(
                  id: Uuid().v4(),
                  description: _descriptionController.text,
                  amount: double.parse(_amountController.text),
                  dueDate: _selectedDate,
                  reminderDuration: _reminderDuration,
                  isPaid: _isPaid,
                );
                print('Adding bill: $newBill');
                Provider.of<BillProvider>(context, listen: false)
                    .addBill(newBill);
                Navigator.pop(context);
              },
              child: Text('Add Bill'),
            ),
          ],
        ),
      ),
    );
  }
}
