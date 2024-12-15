// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

import '../main.dart';

class ExpensePage extends StatefulWidget {
  const ExpensePage({super.key});

  @override
  State<ExpensePage> createState() => _ExpensePageState();
}

class _ExpensePageState extends State<ExpensePage> {
  final TextEditingController _searchController = TextEditingController();

  // List of transactions
  final List<Map<String, dynamic>> transactions = [
    {
      'icon': Icons.fastfood,
      'name': 'Netmeds',
      'category': 'Health',
      'amount': '-₹150',
      'time': '02:10 pm',
      'color': Colors.deepOrange.shade200,
    },
    {
      'icon': Icons.account_balance_wallet,
      'name': 'Fuel',
      'category': 'Transport',
      'amount': '-₹150',
      'time': '02:09 pm',
      'color': Colors.blue.shade100,
    },
    {
      'icon': Icons.shopping_cart,
      'name': 'D-mart',
      'category': 'Grocery',
      'amount': '-₹150',
      'time': '02:08 pm',
      'color': Colors.teal.shade100,
    },
    {
      'icon': Icons.fastfood,
      'name': 'Netflix',
      'category': 'Entertainment',
      'amount': '-₹150',
      'time': '02:07 pm',
      'color': Colors.brown.shade100,
    },
    {
      'icon': Icons.fastfood,
      'name': 'Amazon',
      'category': 'Shopping',
      'amount': '-₹150',
      'time': '02:07 pm',
      'color': Colors.blue.shade100,
    },
    {
      'icon': Icons.fastfood,
      'name': 'Zomato',
      'category': 'Food',
      'amount': '-₹150',
      'time': '02:07 pm',
      'color': Colors.deepOrange.shade200,
    },
  ];

  final List<String> categories = [
    'Food',
    'Health',
    'Entertainment',
    'Transport',
    'Shopping',
    'Grocery',
    'Others'
  ];

  String? selectedCategory;
  String searchQuery = '';
  int currentIndex = 1;

  void onItemTapped(int index) {
    setState(() {
      currentIndex = index;
    });

    if (index == 0) {
      // Navigate to ExpensePage when "Expense" is tapped
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MyApp()),
      );
    }
  }

  // Function to filter transactions based on the selected category and search query
  List<Map<String, dynamic>> getFilteredTransactions() {
    return transactions.where((transaction) {
      // Filter by category if selected
      bool matchesCategory = selectedCategory == null ||
          transaction['category'] == selectedCategory;
      // Filter by search query (ignores case)
      bool matchesSearch = transaction['name']
              .toLowerCase()
              .contains(searchQuery.toLowerCase()) ||
          transaction['category']
              .toLowerCase()
              .contains(searchQuery.toLowerCase());

      return matchesCategory && matchesSearch;
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
            // Search bar
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
                    searchQuery = value; // Update search query
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

            Text(
              'Category',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: categories.map((category) {
                    bool isSelected = selectedCategory == category;
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
                      child: ChoiceChip(
                        label: Text(
                          category,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.grey[700],
                            fontWeight: FontWeight.bold,
                          ),
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

            // Expenses title
            SizedBox(height: 15),
            Text(
              'Expenses',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 10),

            // Expenses list
            Expanded(
              child: filteredTransactions.isNotEmpty
                  ? ListView.builder(
                      itemCount: filteredTransactions.length,
                      itemBuilder: (context, index) {
                        final transaction = filteredTransactions[index];
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: transaction['color'],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.white,
                                  child: Icon(transaction['icon'],
                                      color: Colors.black),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            transaction['name'],
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                          ),
                                          Text(
                                            transaction['category'],
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey[700],
                                            ),
                                          ),
                                          Text(
                                            transaction['time'],
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey[700],
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        transaction['amount'],
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    )
                  : Center(
                      child: Text(
                          'No transactions found for the selected category or search term'),
                    ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        selectedItemColor: Colors.lightBlueAccent,
        unselectedItemColor: Colors.grey,
        onTap: onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.money),
            label: 'Expense',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromARGB(255, 250, 189, 241),
        foregroundColor: Colors.black,
        onPressed: () {
          Navigator.pushNamed(context, '/newtransaction');
          // Navigator.pushNamed(context, '/temp');
        },
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
    );
  }
}
