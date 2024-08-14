import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/ui/add_expense_screen.dart';
import 'package:expense_tracker/ui/expenses_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

import '../database/database_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Tracker',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Expense Tracker'),
    );
  }
}

// Colors for each segment
// of the pie chart
List<Color> colorList = [
  const Color(0xffD95AF3),
  const Color(0xff3EE094),
  const Color(0xff3398F6),
  const Color(0xffFA4A42),
  const Color(0xffFE9539)
];

// List of gradients for the
// background of the pie chart
final gradientList = <List<Color>>[
  [
    Color.fromRGBO(223, 250, 92, 1),
    Color.fromRGBO(129, 250, 112, 1),
  ],
  [
    Color.fromRGBO(129, 182, 205, 1),
    Color.fromRGBO(91, 253, 199, 1),
  ],
  [
    Color.fromRGBO(175, 63, 62, 1.0),
    Color.fromRGBO(254, 154, 92, 1),
  ]
];

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();

}

class _MyHomePageState extends State<MyHomePage> {
  final DatabaseService _databaseService = DatabaseService();

  Future<Map<String, double>> _getExpensesData() async {
    final Map<String, double> list = await _databaseService.expensesGroupList();
    return list;
  }

  PieChart getPieChart(Map<String, double>? map) {
    return PieChart(
      dataMap: map ?? Map(),
      // Set the colors for the
      // pie chart segments
      colorList: colorList,
      // Set the radius of the pie chart
      chartRadius: MediaQuery.of(context).size.width / 2,
      // Set the center text of the pie chart
      centerText: "Budget",
      // Set the width of the
      // ring around the pie chart
      ringStrokeWidth: 24,
      // Set the animation duration of the pie chart
      animationDuration: const Duration(seconds: 3),
      // Set the options for the chart values (e.g. show percentages, etc.)
      chartValuesOptions: const ChartValuesOptions(
          showChartValues: true,
          showChartValuesOutside: true,
          showChartValuesInPercentage: true,
          showChartValueBackground: false),
      // Set the options for the legend of the pie chart
      legendOptions: const LegendOptions(
          showLegends: true,
          legendShape: BoxShape.rectangle,
          legendTextStyle: TextStyle(fontSize: 15),
          legendPosition: LegendPosition.bottom,
          showLegendsInRow: true),
      // Set the list of gradients for
      // the background of the pie chart
      gradientList: gradientList,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: FutureBuilder<Map<String, double>>(
                future: _getExpensesData(),
                builder: (context, snapshot) {
                  return snapshot.data!.isNotEmpty
                      ? Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: getPieChart(snapshot.data),
                        )
                      : Container(
                          width: 180,
                          height: 180,
                          alignment: Alignment.center,
                          margin: const EdgeInsets.all(20.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey,
                          ),
                          child: Text(
                            "No expenses added",
                            textAlign: TextAlign.center,
                          ),
                        );
                },
              ),
            ),
            Wrap(
              alignment: WrapAlignment.center,
                children: [
              ElevatedButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => ExpensesListScreen(),
                    fullscreenDialog: true,
                  ),
                ),
                child: Text(
                  'All Expenses',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold
                  ),
                ),
              )
            ]),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: "Add Expense",
        child: Image.asset('assets/coins.png'),
        onPressed: () async {
          bool result = await Navigator.push(context,
            MaterialPageRoute(
              builder: (_) => AddExpenseScreen(),
              fullscreenDialog: true,
            ),
          );
          if(result){setState((){});}
        },
      ),
    );
  }
}
