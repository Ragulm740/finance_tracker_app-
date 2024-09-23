import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:finance_tracker_app/provider/transaction_provider.dart';

class CurrencyConversionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final transactionProvider = Provider.of<TransactionProvider>(context);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Currency Conversion',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          // You can add a dropdown here for currency selection and perform conversion
          Text('Total in USD: \$${transactionProvider.totalBalance}'),
        ],
      ),
    );
  }
}
