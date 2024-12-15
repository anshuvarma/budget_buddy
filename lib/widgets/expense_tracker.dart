// ignore_for_file: prefer_const_constructors, unused_local_variable, avoid_print

import 'package:flutter/material.dart';
import 'package:temp_app/pages/expense_page.dart';
import 'package:temp_app/pages/new_transaction_page.dart';
import 'package:temp_app/widgets/bottom_nav_bar.dart';
import 'package:temp_app/widgets/overall_expense.dart';
import 'package:temp_app/widgets/recent_transactions.dart';
import 'package:flutter/services.dart';
import '../db_helper.dart';

class ExpenseTracker extends StatefulWidget {
  static const MethodChannel _channel =
      MethodChannel('com.example.coin_check/transaction');

  const ExpenseTracker({super.key});

  @override
  State<ExpenseTracker> createState() => _ExpenseTrackerState();
}

class _ExpenseTrackerState extends State<ExpenseTracker> {
  int currentIndex = 0;
  final GlobalKey<RecentTransactionsState> recentTransactionsKey =
      GlobalKey<RecentTransactionsState>();
  final GlobalKey<OverallExpensesState> overallExpenseKey =
      GlobalKey<OverallExpensesState>();
  final TextEditingController _amountController = TextEditingController();
  bool isExpense = true;
  String selectedCategory = '';
  String selectedSource = '';
  DateTime selectedDate = DateTime.now();
  String selectedAccount = '';

  @override
  void initState() {
    super.initState();

    // Listen for method calls from Android (native side)
    ExpenseTracker._channel.setMethodCallHandler((call) async {
      if (call.method == 'addTransaction') {
        // Extract transaction details from the native call arguments
        final Map<String, dynamic> transactionDetails = call.arguments;
        print(
            "Received addTransaction method with details: $transactionDetails");
        // Display a prompt to the user to confirm adding the transaction
        _promptTransaction(transactionDetails);
      }
    });
  }

  // Display a dialog to confirm adding the transaction
  void _promptTransaction(Map<String, dynamic> transactionDetails) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Add Transaction?"),
          content: Text(
            "We detected a payment notification:\n"
            "Amount: ${transactionDetails['amount']}\n"
            "Description: ${transactionDetails['description'] ?? 'N/A'}",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
                _handleTransaction(transactionDetails); // Add transaction
              },
              child: Text("Add"),
            ),
          ],
        );
      },
    );
  }

  // Method to handle the incoming transaction data
  void _handleTransaction(Map<String, dynamic> transactionDetails) {
    // Parse transaction details
    final type = isExpense ? 'Expense' : 'Income';
    final amount = _amountController.text;
    final date =
        '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}';
    final account = isExpense ? selectedAccount : 'N/A';
    final categoryOrSource = isExpense ? selectedCategory : selectedSource;

    // Save the transaction (this is where you integrate with your DBHelper class)
    // Example:
    final dbHelper = DBHelper();
    dbHelper.insertTransaction({
      'name': type,
      'category': categoryOrSource,
      'amount': amount,
      'date': date,
      'isExpense': isExpense ? 1 : 0,
    });

    // Refresh the transactions in the app
    refreshTransactions();
  }

  void onItemTapped(int index) {
    setState(() {
      currentIndex = index;
    });

    if (index == 1) {
      // Navigate to ExpensePage when "Expense" is tapped
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ExpensePage()),
      );
    }
  }

  void refreshTransactions() {
    recentTransactionsKey.currentState?.refreshTransactionList();
    overallExpenseKey.currentState
        ?.fetchTransactions(); // Refresh the overall expenses
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 250, 189, 241),
        elevation: 2,
        centerTitle: true,
        title: Text(
          "Coin Check",
          style: TextStyle(color: Colors.black, fontSize: 20),
        ),
      ),
      body: Container(
        color: const Color.fromARGB(1, 153, 159, 198),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              OverallExpenses(
                key: overallExpenseKey,
                onTransactionUpdated:
                    refreshTransactions, // Pass the update callback
              ),
              SizedBox(height: screenWidth * 0.04),
              Padding(
                padding: const EdgeInsets.only(left: 12.5),
                child: Text(
                  'Recent Expenses',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0),
                ),
              ),
              SizedBox(height: screenWidth * 0.02),
              RecentTransactions(
                key: recentTransactionsKey,
                onTransactionDeleted: refreshTransactions,
              ), // Refresh pie chart on deletion),
            ],
          ),
        ),
      ),
      bottomNavigationBar:
          BottomNavBar(currentIndex: currentIndex, onItemTapped: onItemTapped),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromARGB(255, 250, 189, 241),
        foregroundColor: Colors.black,
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NewTransactionPage(
                onUpdate:
                    refreshTransactions, // Pass the callback to NewTransactionPage
              ),
            ),
          );
          if (result == true) {
            refreshTransactions(); // Refresh the transactions if a new one was added
          }
        },
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
    );
  }
}
