import 'package:date_formatter/date_formatter.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../database/database_service.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({Key? key}) : super(key: key);

  @override
  _AddExpenseScreenState createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final TextEditingController _amtController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  final DatabaseService _databaseService = DatabaseService();

  DateTime selectedDate = DateTime.now();

  int _selectedIndex = 0;
  List<String> categories = [
    "Shopping",
    "Bills",
    "Transport",
    "Food",
    "Groceries",
    "Medical"
  ];

  Widget getCategoryImage(String category) {
    switch (category) {
      case "Shopping":
        {
          return Image.asset('assets/shopping.png');
        }
      case "Food":
        {
          return Image.asset('assets/food.png');
        }
      case "Transport":
        {
          return Image.asset('assets/transport.png');
        }
      default:
        {
          return Image.asset('assets/shopping.png');
        }
    }
  }

  Future<void> _onSave() async {
    final amount = _amtController.text;
    final description = _descController.text;
    final date = "${selectedDate.toLocal()}".split(' ')[0];
    final category = categories[_selectedIndex];

    await _databaseService.insertExpense(
      Expense(
          category: category,
          description: description,
          amount: int.parse(amount),
          date: date),
    );

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("Expense added successfully"),
    ));

    Navigator.pop(context, true);
  }

  _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add a new expense'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                    DateFormatter.formatDateTime(
                      dateTime: selectedDate,
                      outputFormat: 'dd-MM-yyyy',
                    ),
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
                SizedBox(width: 20),
                Wrap(
                  alignment: WrapAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () => _selectDate(context),
                      child: Text(
                        'Change Date',
                        style: TextStyle(
                          fontSize: 14.0,
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _amtController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter amount',
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _descController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter description(optional)',
              ),
            ),
            SizedBox(height: 20),
            Container(
                height: 60,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 6,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                        onTap: () => {
                              setState(() {
                                _selectedIndex = index;
                              })
                            },
                        child: Container(
                          height: 40.0,
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          margin: const EdgeInsets.only(right: 12.0),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            border: Border.all(
                              width: 3.0,
                              color: _selectedIndex == index
                                  ? Colors.teal
                                  : Colors.black,
                            ),
                          ),
                          child: Row(children: [
                            Container(
                              width: 40,
                              height:40,
                              child:getCategoryImage(categories[index])
                            ),
                            SizedBox(width: 10),
                            Text(categories[index])
                          ]),
                        ));
                  },
                )),
            SizedBox(height: 16.0),
            SizedBox(
              height: 45.0,
              child: ElevatedButton(
                onPressed: _onSave,
                child: Text("Add Expense"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
