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
  bool _sortByDueDate = false;

  @override
  Widget build(BuildContext context) {
    final bills = Provider.of<BillProvider>(context).bills;
    var filteredBills =
        bills.where((bill) => bill.isPaid == _showPaid).toList();

    if (_sortByDueDate) {
      filteredBills.sort((a, b) => a.dueDate.compareTo(b.dueDate));
    }

    final totalAmount =
        filteredBills.fold(0.0, (sum, bill) => sum + bill.amount);

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
      body: Column(
        children: [
          SwitchListTile(
            title: Text('Sort by Due Date'),
            value: _sortByDueDate,
            onChanged: (bool value) {
              setState(() {
                _sortByDueDate = value;
              });
            },
            secondary: Icon(Icons.sort),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredBills.length,
              itemBuilder: (context, index) {
                final bill = filteredBills[index];
                return ListTile(
                  title: Text(bill.description),
                  subtitle: Text(
                    'Amount: \$${bill.amount.toStringAsFixed(2)}\nDue Date: ${bill.dueDate.toLocal().toString().split(' ')[0]}',
                  ),
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
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddBillScreen()),
          );
        },
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 6.0,
        child: Container(
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.blue,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Amount Due:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                '\$${totalAmount.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
