import 'package:finance_tracker_app/provider/transaction_provider.dart';
import 'package:finance_tracker_app/screen/add_transaction_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required TransactionProvider transactionProvider});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
     final transactionProvider = Provider.of<TransactionProvider>(context);

     return Scaffold(
      backgroundColor:Color(0xFFF8F8F9),
      body: getBody(transactionProvider),
       floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Define the action when FAB is pressed (e.g., navigate to add transaction screen)
          _navigateToAddTransaction(context);
        },
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
    
        
  }


  void _navigateToAddTransaction(BuildContext context) {
    // Navigate to add transaction screen or open a dialog
    // For example:
   Navigator.push(context, MaterialPageRoute(builder: (_) => AddTransactionScreen()));
  }
  Widget getBody(TransactionProvider transactionProvider) {
  return SingleChildScrollView(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 260,
          child: Stack(
            children: [
              appBarCurve(transactionProvider),
              appBarBalance(transactionProvider),
            ],
          ),
        ),
        SizedBox(height: 10),
        _buildRecentTransactionsTitle(),
        SizedBox(
          height:1500,
          child: ListView.builder(
            itemCount: transactionProvider.transactions.length,
            itemBuilder: (context, index) {
              final transaction = transactionProvider.transactions[index];
              return Slidable(
                key: Key(transaction['id'].toString()),
                endActionPane: ActionPane(
                  motion: const ScrollMotion(),
                  children: [
                    SlidableAction(
                      onPressed: (context) =>
                          _showEditDialog(context, transactionProvider, transaction),
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      icon: Icons.edit,
                      label: 'Edit',
                    ),
                    SlidableAction(
                      onPressed: (context) =>
                          _showDeleteDialog(context, transactionProvider, transaction),
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      icon: Icons.delete,
                      label: 'Delete',
                    ),
                  ],
                ),
                child: _buildTransactionTile(transaction),
              );
            },
          ),
        ),
      ],
    ),
  );
}


   Widget appBarCurve(TransactionProvider transactionProvider) {
    var size = MediaQuery.of(context).size;
    return ClipPath(
      clipper: OvalBottomBorderClipper(),
      child: Container(
        width: size.width,
        height: size.height * 0.25,
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [Color(0xFF6864EC), Color(0xFFAC7EF8)]),
            boxShadow: [
              BoxShadow(
                color: Color(0xFFF8F8F9).withOpacity(0.1),
                spreadRadius: 10,
                blurRadius: 10,
                // changes position of shadow
              ),
            ]),
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 15),
          child: SafeArea(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "\$",
                          style: TextStyle(fontSize: 22, color: Color(0xFFFFFFFF)),
                        ),
                        Text(
                          transactionProvider.totalBalance.toStringAsFixed(0),
                          style: TextStyle(fontSize: 30, color: Color(0xFFFFFFFF)),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 2,
                    ),
                    Text(
                      "Available balance",
                      style: TextStyle(color: Color(0xFFFFFFFF).withOpacity(0.8)),
                    )
                  ],
                ),
                Stack(
                  children: [
                    Container(
                      width: 45,
                      height: 45,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(
                                  "https://images.unsplash.com/photo-1663431512297-993006b0098b?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHw2M3x8fGVufDB8fHx8&auto=format&fit=crop&w=800&q=60"),
                              fit: BoxFit.cover),
                          borderRadius: BorderRadius.circular(15)),
                    ),
                    Positioned(
                      top: 35,
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                            color: Color(0xFFFFFFFF),
                            shape: BoxShape.circle,
                            border: Border.all(color:Color(0xFF6864EC))),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget appBarBalance(TransactionProvider transactionProvider) {
    var size = MediaQuery.of(context).size;
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Container(
          height: 110,
          width: size.width,
          decoration: BoxDecoration(
              color: Color(0xFFFFFFFF),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color:Color(0xFF000000).withOpacity(0.01),
                  spreadRadius: 10,
                  blurRadius: 10,
                  // changes position of shadow
                ),
              ]),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Row(
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.redAccent),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Spent",
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF000000).withOpacity(0.5)),
                              ),
                              SizedBox(
                                height: 3,
                              ),
                              Text(
                                 "\$${transactionProvider.totalExpense.toStringAsFixed(0)}",
                                style: TextStyle(
                                    fontSize: 22, fontWeight: FontWeight.w500),
                              ),
                            ],
                          )
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
                                shape: BoxShape.circle, color: Color(0xFF6864EC)),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Earned",
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF000000).withOpacity(0.5)),
                              ),
                              SizedBox(
                                height: 3,
                              ),
                              Text(
                                 "\$${transactionProvider.totalIncome.toStringAsFixed(0)}",
                                style: TextStyle(
                                    fontSize: 22, fontWeight: FontWeight.w500),
                              ),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
               
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCard(String title, double amount) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF3b67b5),
        borderRadius: BorderRadius.circular(32),
      ),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(color: Color(0xFFF7F7F7)),
          ),
          const SizedBox(width: 32),
          Text(
            "\$${amount.toStringAsFixed(0)}",
            style: const TextStyle(color: Color(0xFFF7F7F7)),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentTransactionsTitle() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      height: 30,
      child: const Text(
        'Recent Transactions',
        style: TextStyle(
          color: Color(0xff5a5d85),
          fontWeight: FontWeight.bold,
          fontSize: 22,
        ),
      ),
    );
  }

  Widget _buildTransactionTile(Map<String, dynamic> transaction) {
    return SizedBox(
      height: 90,
      child: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
        child: Container(
          height: 90,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                blurRadius: 22,
                color: const Color.fromARGB(115, 97, 96, 96),
                spreadRadius: -8,
              ),
            ],
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      transaction['category'],
                      style: const TextStyle(
                        color: Color(0xFF3b67b5),
                        fontSize: 20,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    Text(
                      transaction['date'],
                      style: const TextStyle(
                        color: Colors.black45,
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
                Text(
                  '\$${transaction['amount']}',
                  style: const TextStyle(
                    color: Colors.amber,
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

void _showEditDialog(BuildContext context, TransactionProvider transactionProvider, Map<String, dynamic> transaction) {
  final TextEditingController _amountController = TextEditingController(text: transaction['amount'].toString());
  final TextEditingController _categoryController = TextEditingController(text: transaction['category']);

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Edit Transaction"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _amountController,
              decoration: InputDecoration(labelText: "Amount"),
              keyboardType: TextInputType.number,
            ),
           
          ],
        ),
        actions: <Widget>[
          TextButton(
            child: Text("Cancel"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text("Save"),
            onPressed: () {
            // transactionProvider.updateTransaction(transaction['id'],
            //         double.parse(_amountController.text));
                Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}


  void _showDeleteDialog(
    BuildContext context,
    TransactionProvider transactionProvider,
    Map<String, dynamic> transaction,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Transaction'),
          content: const Text('Are you sure you want to delete this transaction?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Delete the transaction
                transactionProvider.deleteTransaction(transaction['id']);
                Navigator.of(context).pop();
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

}