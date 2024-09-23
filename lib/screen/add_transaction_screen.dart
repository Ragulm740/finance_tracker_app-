import 'package:finance_tracker_app/provider/transaction_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddTransactionScreen extends StatefulWidget {
  @override
  _AddTransactionScreenState createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  String _selectedCategory = 'Food';
  String _transactionType = 'Expense'; // Add this for expense/income

  List<String> expenseCategories = ['Food', 'Transport', 'Entertainment'];
  List<String> incomeCategories = ['Salary', 'Bonus', 'Interest'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Transaction'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Radio Buttons for selecting Income/Expense
              Row(
                children: [
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text('Expense'),
                      value: 'Expense',
                      groupValue: _transactionType,
                      onChanged: (value) {
                        setState(() {
                          _transactionType = value!;
                          _selectedCategory = expenseCategories.first;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text('Income'),
                      value: 'Income',
                      groupValue: _transactionType,
                      onChanged: (value) {
                        setState(() {
                          _transactionType = value!;
                          _selectedCategory = incomeCategories.first;
                        });
                      },
                    ),
                  ),
                ],
              ),
              
              // Amount Field
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Amount'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an amount';
                  }
                  return null;
                },
              ),

              // Category Dropdown based on Income/Expense selection
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                items: (_transactionType == 'Expense'
                        ? expenseCategories
                        : incomeCategories)
                    .map((category) => DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value!;
                  });
                },
              ),
              
              // Submit Button
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    double amount = double.parse(_amountController.text);
                    Provider.of<TransactionProvider>(context, listen: false)
                        .addTransaction(
                          amount,
                          _selectedCategory,
                          _transactionType,  // Pass the transaction type here
                        );
                    Navigator.pop(context);
                  }
                },
                child: Text('Add Transaction'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
