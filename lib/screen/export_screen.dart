import 'package:csv/csv.dart';
import 'package:finance_tracker_app/provider/transaction_provider.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

import 'package:provider/provider.dart';

class ExportScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () async {
          await _exportCSV(context);
        },
        child: const Text('Export Transactions as CSV'),
      ),
    );
  }

  Future<void> _exportCSV(BuildContext context) async {
    final transactionProvider = Provider.of<TransactionProvider>(context, listen: false);
    List<List<dynamic>> rows = [];

    // Add headers
    rows.add(["Category", "Amount", "Date"]);

    // Add transactions
    for (var transaction in transactionProvider.transactions) {
      List<dynamic> row = [];
      row.add(transaction['category']);
      row.add(transaction['amount']);
      row.add(transaction['date']);
      rows.add(row);
    }

    String csv = const ListToCsvConverter().convert(rows);
    final directory = await getApplicationDocumentsDirectory();
    final path = "${directory.path}/transactions.csv";
    final file = File(path);
    await file.writeAsString(csv);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('CSV file saved at $path')),
    );
  }
}
