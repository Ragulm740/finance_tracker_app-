import 'package:finance_tracker_app/helper/_dp_helper.dart';
import 'package:flutter/material.dart';

class TransactionProvider extends ChangeNotifier {
  final DBHelper dbHelper = DBHelper();
  double totalBalance = 0.0;
  double totalIncome = 0.0; // Track total income
  double totalExpense = 0.0; // Track total expense
   double monthlyBudget = 0.0; // New property
  List<Map<String, dynamic>> transactions = [];

  Map<String, double> categorySpending = {
    'Food': 0.0,
    'Transport': 0.0,
    'Entertainment': 0.0,
    'Salary': 0.0,
    'Bonus': 0.0,
    'Interest': 0.0,
  };


  void loadTransactions() {
  // Fetch or initialize transactions from a data source
 transactions = [

  ];
  notifyListeners();
}


  TransactionProvider() {
    fetchTransactions();
  }

  void fetchTransactions() async {
    transactions = await dbHelper.getTransactions();

    totalIncome = 0.0;
    totalExpense = 0.0;

    categorySpending = {
      'Food': 0.0,
      'Transport': 0.0,
      'Entertainment': 0.0,
      'Salary': 0.0,
      'Bonus': 0.0,
      'Interest': 0.0,
    };

    // Calculate total income and expense
    for (var transaction in transactions) {
      double amount = transaction['amount'];
      if (amount > 0) {
        totalIncome += amount; // Income is positive
      } else {
        totalExpense += amount.abs(); // Expense is negative, convert to positive
      }
    }

    totalBalance = totalIncome - totalExpense; // Net balance
    notifyListeners();
  }

  void addTransaction(double amount, String category, String type) async {
    double adjustedAmount = type == 'Expense' ? -amount : amount; // Adjust based on type
    await dbHelper.addTransaction(adjustedAmount, category, DateTime.now().toString());
    fetchTransactions();
  }

  void deleteTransaction(int id) async {
    await dbHelper.deleteTransaction(id);
    fetchTransactions();
  }

  void setMonthlyBudget(double budget) {
    monthlyBudget = budget;
    // Save the budget to the database if needed
    // await dbHelper.saveMonthlyBudget(budget);
    notifyListeners();
  }

  void updateTransaction(int id, double amount) {
  final index = transactions.indexWhere((transaction) => transaction['id'] == id);
  if (index != -1) {
    transactions[index] = {
      'id': id,
      'amount': amount,
      // Include other fields if necessary
    };
    notifyListeners(); // Notify listeners to update the UI
  }
}


}
