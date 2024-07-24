import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'bill_provider.dart';
import 'bill.dart';
import 'add_bill_screen.dart';
import 'edit_bill_screen.dart';

class BillListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bill Reminder'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddBillScreen()),
              );
            },
          ),
        ],
      ),
      body: Consumer<BillProvider>(
        builder: (context, billProvider, child) {
          return ListView.builder(
            itemCount: billProvider.bills.length,
            itemBuilder: (context, index) {
              final bill = billProvider.bills[index];
              return ListTile(
                title: Text(bill.description),
                subtitle:
                    Text('Amount: \$${bill.amount}, Due: ${bill.dueDate}'),
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
          );
        },
      ),
    );
  }
}
