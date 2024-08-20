import 'package:date_formatter/date_formatter.dart';
import 'package:flutter/material.dart';

import '../database/database_service.dart';
import '../models/expense.dart';

final DatabaseService _databaseService = DatabaseService();

class ExpensesListScreen extends StatelessWidget {
  const ExpensesListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Transactions'),
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),
        body: FutureBuilder<List<Expense>>(
      future: _databaseService.expensesList(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final expense = snapshot.data![index];
              return _buildExpenseCard(expense, context);
            },
          ),
        );
      },
    )
    );
  }

  Widget getCategoryImage(String category){
    switch (category) {
      case "Shopping": {
      return Image.asset('assets/shopping.png');
      }
      case "Food": {
        return Image.asset('assets/food.png');
      }
      case "Transport": {
        return Image.asset('assets/transport.png');
      }
      case "Bills":
        {
          return Image.asset('assets/bills.png');
        }
      case "Groceries":
        {
          return Image.asset('assets/groceries.png');
        }
      case "Medical":
        {
          return Image.asset('assets/medical.png');
        }
      default: {
        return Image.asset('assets/shopping.png');
      }
    }
  }

  Widget _buildExpenseCard(Expense expense, BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Container(
              height: 40.0,
              width: 40.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey[300],
              ),
              alignment: Alignment.center,
              child: getCategoryImage(expense.category),
            ),
            SizedBox(width: 20.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${expense.category}",
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
              expense.description != null ? Text(expense.description?? "") : Text("empty")
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    DateFormatter.formatDateTime(
                      dateTime: DateTime.parse(expense.date),
                      outputFormat: 'dd-MM-yyyy',
                    ),
                  ),
                  SizedBox(height: 4.0),
                  Text("${expense.amount}",
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500,
                    ),),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

}
