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
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    _showDeleteConfirmationDialog(context, billProvider, bill);
                  },
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
          );
        },
      ),
    );
  }

  void _showDeleteConfirmationDialog(
      BuildContext context, BillProvider billProvider, Bill bill) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Bill'),
          content: Text('Are you sure you want to delete this bill?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () {
                billProvider.deleteBill(bill.id);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
