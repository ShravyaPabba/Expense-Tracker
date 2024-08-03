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
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
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

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();

}

class _MyHomePageState extends State<MyHomePage> {
  final DatabaseService _databaseService = DatabaseService();
  int _counter = 0;

  Future<void> _onSave() async {
    await _databaseService.insertExpense(
        Expense(id: 1, category: "Shopping", amount: 100, date: "today"));

    await _databaseService.insertExpense(
        Expense(id: 2, category: "Max", amount: 100, date: "today"));
  }

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
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
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
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
