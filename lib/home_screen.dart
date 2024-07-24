import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'bill_provider.dart';
import 'add_bill_screen.dart';
import 'bill.dart';
import 'edit_bill_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _showPaid = false;

  @override
  Widget build(BuildContext context) {
    final bills = Provider.of<BillProvider>(context).bills;
    final filteredBills =
        bills.where((bill) => bill.isPaid == _showPaid).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(_showPaid ? 'Paid Bills' : 'Upcoming Bills'),
        actions: [
          Switch(
            value: _showPaid,
            onChanged: (bool value) {
              setState(() {
                _showPaid = value;
              });
            },
            activeColor: Colors.green,
            inactiveThumbColor: Colors.red,
            inactiveTrackColor: Colors.redAccent,
            activeTrackColor: Colors.greenAccent,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: filteredBills.length,
        itemBuilder: (context, index) {
          final bill = filteredBills[index];
          return ListTile(
            title: Text(bill.description),
            subtitle: Text(
                'Amount: \$${bill.amount.toStringAsFixed(2)}\nDue Date: ${bill.dueDate.toLocal().toString().split(' ')[0]}'),
            trailing: Icon(
              bill.isPaid ? Icons.check_circle : Icons.warning,
              color: bill.isPaid ? Colors.green : Colors.red,
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditBillScreen(bill: bill),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddBillScreen()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
