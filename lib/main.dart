// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, unused_import

import 'package:flutter/material.dart';
import 'package:temp_app/pages/error_page.dart';
import 'package:temp_app/pages/expense_page.dart';
import 'package:temp_app/pages/new_transaction_page.dart';
import 'package:temp_app/widgets/balance_card.dart';
import 'package:temp_app/widgets/bottom_nav_bar.dart';
import 'package:temp_app/widgets/expense_tracker.dart';
import 'package:temp_app/widgets/recent_transactions.dart';
import 'widgets/overall_expense.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ExpenseTracker(),
      debugShowCheckedModeBanner: false,
    );
  }
}
