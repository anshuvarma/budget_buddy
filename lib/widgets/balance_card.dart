// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace

import 'package:flutter/material.dart';

class BalanceCard extends StatelessWidget {
  const BalanceCard({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Padding(
      padding: EdgeInsets.all(screenWidth * 0.02),
      child: Container(
        height: screenHeight * 0.5, // Adjust height relative to screen height
        child: Card(
          color: const Color.fromARGB(255, 241, 229, 245),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 4,
          child: Padding(
            padding: EdgeInsets.symmetric(
                vertical: screenWidth * 0.05, horizontal: screenWidth * 0.04),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Balance',
                  style: TextStyle(
                      fontSize: screenWidth * 0.05,
                      fontWeight: FontWeight.bold),
                ),
                // SizedBox(height: screenWidth * 0.04),
                Flexible(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        height: screenWidth * 0.45, // Reduced size
                        width: screenWidth * 0.45,
                        child: CircularProgressIndicator(
                          value: 0.65,
                          strokeWidth: 9.0,
                          backgroundColor: Colors.grey[300],
                          valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.lightBlueAccent),
                          semanticsLabel: 'Balance Progress',
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '65%',
                            style: TextStyle(
                                fontSize: 22,
                                // fontSize: screenWidth * 0.06,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue),
                          ),
                          SizedBox(height: screenWidth * 0.01),
                          Text('Amount spent',
                              style: TextStyle(
                                  fontSize: 15,
                                  // fontSize: screenWidth * 0.035,
                                  color: Colors.black)),
                          SizedBox(height: screenWidth * 0.01),
                          Text('₹40000',
                              style: TextStyle(
                                  fontSize: 25,
                                  // fontSize: screenWidth * 0.07,
                                  fontWeight: FontWeight.bold)),
                          SizedBox(height: screenWidth * 0.01),
                          Text('of ₹70000',
                              style: TextStyle(
                                  fontSize: 15,
                                  // fontSize: screenWidth * 0.035,
                                  color: Colors.black)),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: screenWidth * 0.05),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: screenWidth * 0.250,
                        decoration: BoxDecoration(
                          color: Colors.green.shade100,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding:
                            EdgeInsets.symmetric(vertical: screenWidth * 0.03),
                        child: Column(
                          children: [
                            // SizedBox(height: screenWidth * 0.02),
                            Icon(
                              Icons.arrow_upward_outlined,
                              color: Colors.green,
                            ),
                            Text('Income',
                                style: TextStyle(
                                    fontSize: screenWidth * 0.035,
                                    color: Colors.grey.shade700)),
                            Text('₹5500',
                                style: TextStyle(
                                    fontSize: screenWidth * 0.04,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.02),
                    Expanded(
                      child: Container(
                        height: screenWidth * 0.250,
                        decoration: BoxDecoration(
                          color: Colors.red.shade200,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding:
                            EdgeInsets.symmetric(vertical: screenWidth * 0.03),
                        child: Column(
                          children: [
                            // SizedBox(height: screenWidth * 0.02),
                            Icon(
                              Icons.arrow_downward_outlined,
                              color: Colors.redAccent,
                            ),
                            Text('Expense',
                                style: TextStyle(
                                    fontSize: screenWidth * 0.035,
                                    color: Colors.grey.shade700)),
                            Text('₹500',
                                style: TextStyle(
                                    fontSize: screenWidth * 0.04,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
