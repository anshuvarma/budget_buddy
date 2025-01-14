// ignore_for_file: use_build_context_synchronously, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:temp_app/constants.dart';
import 'package:temp_app/db_helper.dart';
import 'package:temp_app/main.dart';
import 'package:temp_app/pages/new_transaction_page.dart';
import 'package:temp_app/widgets/bottom_nav_bar.dart';
import 'package:temp_app/widgets/recent_transactions.dart';

class ExpensePage extends StatefulWidget {
  const ExpensePage({super.key});

  @override
  State<ExpensePage> createState() => _ExpensePageState();
}

class _ExpensePageState extends State<ExpensePage> {
  final TextEditingController _searchController = TextEditingController();
  final GlobalKey<RecentTransactionsState> recentTransactionsKey =
      GlobalKey<RecentTransactionsState>();

  String? selectedCategory;
  String searchQuery = '';
  int currentIndex = 1;
  List<Map<String, dynamic>> newTransactions = [];

  void onItemTapped(int index) {
    setState(() {
      currentIndex = index;
    });

    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MyApp()),
      );
    }
  }

  final dbHelper = DBHelper();

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    final data = await dbHelper.fetchTransactions();
    setState(() {
      newTransactions = data.reversed.toList();
    });
  }

  void refreshTransactions() {
    recentTransactionsKey.currentState?.refreshTransactionList();
    _loadTransactions();
  }

  Future<void> _deleteTransaction(int id) async {
    await dbHelper.deleteTransaction(id);
    refreshTransactions();
    deleteDialog(context);
  }

  List<Map<String, dynamic>> getFilteredTransactions() {
    return newTransactions.where((transaction) {
      bool isExpense = transaction['name'] == 'Expense';
      bool matchesCategory = selectedCategory == null ||
          transaction['category'] == selectedCategory;
      bool matchesSearch = transaction['name']
              .toLowerCase()
              .contains(searchQuery.toLowerCase()) ||
          transaction['category']
              .toLowerCase()
              .contains(searchQuery.toLowerCase());
      return isExpense && matchesCategory && matchesSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredTransactions = getFilteredTransactions();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 250, 189, 241),
        elevation: 1,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Expense',
          style: TextStyle(color: Colors.black, fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 241, 229, 245),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Search for any expense',
                  hintStyle: TextStyle(color: Colors.blueGrey.shade200),
                  icon: Icon(Icons.search, color: Colors.blueGrey.shade200),
                ),
              ),
            ),
            SizedBox(height: 20),
            // Category Filter
            Text('Category',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black)),
            Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(10)),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: expenseCategories.map((category) {
                    bool isSelected = selectedCategory == category;
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
                      child: ChoiceChip(
                        label: Text(
                          category,
                          style: TextStyle(
                              color:
                                  isSelected ? Colors.white : Colors.grey[700],
                              fontWeight: FontWeight.bold),
                        ),
                        selected: isSelected,
                        onSelected: (bool selected) {
                          setState(() {
                            selectedCategory = selected ? category : null;
                          });
                        },
                        selectedColor: Colors.purple,
                        showCheckmark: false,
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            SizedBox(height: 15),
            Text(
              'All Expenses',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            SizedBox(height: 10),

            // Transaction List
            Expanded(
                child: newTransactions.isNotEmpty
                    ? ListView.builder(
                        itemCount: filteredTransactions.length,
                        itemBuilder: (context, index) {
                          final transaction = filteredTransactions[index];
                          final category = transaction['category'];
                          final color = categoryColors[category] ?? Colors.cyan;

                          return Dismissible(
                            key: ValueKey(transaction['id']),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              alignment: Alignment.centerRight,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              color: Colors.red,
                              child:
                                  const Icon(Icons.delete, color: Colors.white),
                            ),
                            confirmDismiss: (direction) => showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text("Delete Transaction"),
                                content: Text(
                                    "Are you sure you want to delete this transaction?"),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(false),
                                    child: Text("Cancel"),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(true),
                                    child: Text("Delete"),
                                  ),
                                ],
                              ),
                            ),
                            onDismissed: (direction) {
                              _deleteTransaction(transaction['id']);
                            },
                            child: Card(
                              // ignore: deprecated_member_use
                              color: color.withOpacity(0.6),
                              child: ListTile(
                                leading: Icon(Icons.account_balance_wallet,
                                    color: Colors.black),
                                title: Text(transaction['category'],
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(transaction['date']),
                                  ],
                                ),
                                trailing: Text(
                                  transaction['amount'].toString(),
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ),
                            ),
                          );
                        },
                      )
                    : Center(child: Text('No transactions yet!'))),
          ],
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
                onUpdate: refreshTransactions,
              ),
            ),
          );
          if (result == true) refreshTransactions();
        },
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
    );
  }
}
