import 'package:finance_tracker_app/provider/transaction_provider.dart';
import 'package:finance_tracker_app/widget/liner_chart.dart';
import 'package:finance_tracker_app/widget/spending_chart.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MonthlyBudgetScreen extends StatefulWidget {
  @override
  _MonthlyBudgetScreenState createState() => _MonthlyBudgetScreenState();
}

class _MonthlyBudgetScreenState extends State<MonthlyBudgetScreen> {
  TextEditingController _budgetController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F8F9),
      appBar: PreferredSize(child: getAppBar(), preferredSize: Size.fromHeight(60)),
      body: getBody(),
    );
  }

  Widget getAppBar() {
    return AppBar(
      backgroundColor: Color(0xFFF8F8F9),
      elevation: 0,
      actions: [
        Padding(
          padding: const EdgeInsets.only(top: 15, right: 15),
          child: GestureDetector(
            onTap: () {
              _showBudgetDialog();
            },
            child: Text(
              "Set budget",
              style: TextStyle(
                  color: Color(0xFF6864EC), fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
        ),
      ],
    );
  }

  // This function will calculate spending based on the category.
  Map<String, double> calculateCategorySpending(List<Map<String, dynamic>> transactions) {
    final categorySpending = <String, double>{
       'Food': 0.0,
      'Transport': 0.0,
      'Entertainment': 0.0,
      'Salary': 0.0,
      'Bonus': 0.0,
      'Interest': 0.0,
    };

    for (var transaction in transactions) {
      final category = transaction['category'];
      final amount = transaction['amount'];

      if (categorySpending.containsKey(category)) {
        categorySpending[category] = categorySpending[category]! + amount;
      } else {
        categorySpending[category] = amount;
      }
    }

    return categorySpending;
  }

  Widget getBody() {
    // Retrieving transactions from the provider.
    final provider = Provider.of<TransactionProvider>(context);
    final transactions = provider.transactions; // Fetch transactions from the provider.
    
    // Calculate spending per category
    final categorySpending = calculateCategorySpending(transactions);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          getBalance(provider),
          SizedBox(height: 20),
          getChartAndBalance(provider),
          SizedBox(height: 20),
          // Passing the calculated category spending to the chart.
          SpendingChart(categorySpending: categorySpending),
        ],
      ),
    );
  }

  void _showBudgetDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Set Monthly Budget"),
          content: TextField(
            controller: _budgetController,
            decoration: InputDecoration(labelText: "Enter your budget"),
            keyboardType: TextInputType.number,
          ),
          actions: <Widget>[
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Set"),
              onPressed: () {
                if (_budgetController.text.isNotEmpty) {
                  double budget = double.parse(_budgetController.text);
                  Provider.of<TransactionProvider>(context, listen: false).setMonthlyBudget(budget);
                  _budgetController.clear();
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  Widget getBalance(TransactionProvider provider) {
    return Center(
      child: Column(
        children: [
          Text(
            "Your balance is \$${provider.totalBalance.toStringAsFixed(0)}",
            style: TextStyle(fontSize: 20, color: Color(0xFF000000), fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 10),
          Text(
            "Total spent this month: \$${provider.totalExpense.toStringAsFixed(0)}",
            style: TextStyle(fontSize: 14, height: 1.6),
          ),
        ],
      ),
    );
  }

  Widget getChartAndBalance(TransactionProvider provider) {
    return Container(
      height: 200,
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            height: 150,
            child: LineChart(activityData()),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 100, left: 20, right: 20),
            child: Container(
              height: 100,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Color(0xFFFFFFFF),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFF000000).withOpacity(0.01),
                    spreadRadius: 10,
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.redAccent,
                            ),
                          ),
                          SizedBox(width: 15),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Spent",
                                style: TextStyle(fontSize: 14, color: Color(0xFF000000).withOpacity(0.5)),
                              ),
                              SizedBox(height: 3),
                              Text(
                                "\$${provider.totalExpense.toStringAsFixed(0)}",
                                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Flexible(
                      child: Row(
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFF6864EC),
                            ),
                          ),
                          SizedBox(width: 15),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Earned",
                                style: TextStyle(fontSize: 14, color: Color(0xFF000000).withOpacity(0.5)),
                              ),
                              SizedBox(height: 3),
                              Text(
                                "\$${provider.totalIncome.toStringAsFixed(0)}",
                                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
