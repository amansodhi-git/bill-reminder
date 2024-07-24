import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'bill_provider.dart';
import 'bill.dart';

class EditBillScreen extends StatefulWidget {
  final Bill bill;

  EditBillScreen({required this.bill});

  @override
  _EditBillScreenState createState() => _EditBillScreenState();
}

class _EditBillScreenState extends State<EditBillScreen> {
  late TextEditingController _descriptionController;
  late TextEditingController _amountController;
  late DateTime _selectedDate;
  late Duration _reminderDuration;
  late bool _isPaid;

  @override
  void initState() {
    super.initState();
    _descriptionController =
        TextEditingController(text: widget.bill.description);
    _amountController =
        TextEditingController(text: widget.bill.amount.toString());
    _selectedDate = widget.bill.dueDate;
    _reminderDuration = widget.bill.reminderDuration;
    _isPaid = widget.bill.isPaid;
  }

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
        title: Text('Edit Bill'),
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
                final updatedBill = Bill(
                  id: widget.bill.id,
                  description: _descriptionController.text,
                  amount: double.parse(_amountController.text),
                  dueDate: _selectedDate,
                  reminderDuration: _reminderDuration,
                  isPaid: _isPaid,
                );
                Provider.of<BillProvider>(context, listen: false)
                    .updateBill(updatedBill);
                Navigator.pop(context);
              },
              child: Text('Save Changes'),
            ),
            ElevatedButton(
              onPressed: () {
                Provider.of<BillProvider>(context, listen: false)
                    .deleteBill(widget.bill.id);
                Navigator.pop(context);
              },
              child: Text('Delete Bill'),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(198, 255, 76, 63)),
            ),
          ],
        ),
      ),
    );
  }
}
