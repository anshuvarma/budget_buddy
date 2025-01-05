// ignore_for_file: prefer_const_constructors, unused_local_variable, avoid_print, unused_field, unused_element

import 'package:flutter/material.dart';
import 'package:temp_app/pages/expense_page.dart';
import 'package:temp_app/pages/new_transaction_page.dart';
import 'package:temp_app/widgets/bottom_nav_bar.dart';
import 'package:temp_app/widgets/overall_expense.dart';
import 'package:temp_app/widgets/recent_transactions.dart';

class ExpenseTracker extends StatefulWidget {
  const ExpenseTracker({super.key});

  @override
  State<ExpenseTracker> createState() => _ExpenseTrackerState();
}

class _ExpenseTrackerState extends State<ExpenseTracker>
    with WidgetsBindingObserver {
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
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void onItemTapped(int index) async {
    if (index == 1) {
      // Navigate to ExpensePage and await result
      final result = await Navigator.push<bool>(
        context,
        MaterialPageRoute(builder: (context) => ExpensePage()),
      );

      // If any changes were made on ExpensePage, refresh transactions
      if (result == true) {
        refreshTransactions();
      }
    } else {
      setState(() {
        currentIndex = index;
      });
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Refresh transactions when returning to the app
      refreshTransactions();
    }
  }

  void refreshTransactions() {
    print("Refreshing transactions...");
    recentTransactionsKey.currentState?.refreshTransactionList();
    overallExpenseKey.currentState
        ?.fetchTransactions(); // Refresh the overall expenses
    print("Transactions refreshed.");
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
          final result = await Navigator.push<bool>(
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
