import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../Displays/TruncatedTiles.dart';
import '../Displays/bottom_navigation_bar.dart';
import '../Displays/detailed_receipt.dart';
import '../Displays/report.dart';
import '../Model/model_utils.dart';
import '../Request/NetManager.dart';

///Displays yearly expenditure report for user.
///User is able to select which year's report to display.
///Details displayed include line graph tracking monthly spending, total expenditure for the year, categorical breakdown of expenditure, list of top receipts.

class ReportYearlyPage extends StatefulWidget {
  ReportYearlyPage({Key? key}) : super(key: key);

  _ReportYearlyPageState createState() => _ReportYearlyPageState();
}

class _ReportYearlyPageState extends State<ReportYearlyPage> {
  MyNavigationBar bar = MyNavigationBar(selected_index: 1);
  ReportModel? reportModel;

  //Map the categories to the percentage it takes up of the total expenditure in the year.
  Map<String, double> categories = {};

  //list of [Monthlyspending] for plotting the graph.
  List<MonthlySpending> monthlySpending = [];

  //default month to display for the report is the previous year.
  //initalise year variable to make request from server.
  int year = DateTime.now().year.toInt() - 1;
  bool notloaded = true;
  //List of names of the months.
  List months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sept',
    'Oct',
    'Nov',
    'Dec'
  ];

  //dropdown options for selecting year.
  List<DropdownMenuItem<int>> get yeardropdownItems {
    List<DropdownMenuItem<int>> menuItems = [
      DropdownMenuItem(child: Text('Year'), value: 0),
      DropdownMenuItem(child: Text('2022'), value: 2022),
      DropdownMenuItem(child: Text('2021'), value: 2021),
      DropdownMenuItem(child: Text('2020'), value: 2020),
    ];
    return menuItems;
  }

  void initState() {
    super.initState();
    waitForServer(year);
  }

  //make request to server for report data.
  //initialise [categories] and [monthlyspending] to display categorical line indicator and line graph respectively.
  void waitForServer(int year) async {
    print(year.toString());
    await NetManager.makeGetYearReportModelRequest(year).then((val) {
      setState(() {
        reportModel = val as ReportModel;
        notloaded = false;
      });
    });
    if ((reportModel?.errorCode as int) < 0) {
      return;
    }
    setState(() {
      int numCategories = reportModel?.data?.categoricalExpenses!.length as int;
      print(numCategories.toString());
      double val = 0;
      double total = reportModel?.data?.totalExpenditure as double;
      reportModel?.data?.categoricalExpenses!.forEach((key, value) {
        print(value.toString());
        val = (value as double) / total * 100;
        categories.addAll({key: val});
      });

      monthlySpending.clear();
      int numMonths = reportModel?.data?.unitExpenses!.length as int;
      print(numMonths.toString());
      for (int i = 0; i < numMonths; i++) {
        monthlySpending.add(MonthlySpending(
            months[i], reportModel?.data?.unitExpenses![i] as double));
      }
      print(monthlySpending.length.toString());
    });
  }

  //build scaffold for yearly report.
  //components include: seleciion to display monthly/yearly report, year seleciton for displaying yearly report,main body.
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,

      //seleciion to display monthly/yearly report
      appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: buildMonthYearBar(context)),
      body: notloaded
          ? Center(
              child: CircularProgressIndicator(
                color: Colors.pinkAccent,
              ),
            )
          : Container(
              height: MediaQuery.of(context).size.height / 1.2,
              child: Column(
                children: [
                  //select month and year to display
                  Card(
                    child: buildYearSelection(context),
                  ),

                  //main report body
                  buildBody(context)
                ],
              )),
      bottomNavigationBar: bar,
    );
  }

  //build bar to select viewing monthly or yearly report.
  //if monthly is selected, will navigate to the Report page.
  Widget buildMonthYearBar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Container(
          decoration: BoxDecoration(
              border:
                  Border(bottom: BorderSide(color: Colors.white, width: 2))),
          child: TextButton(
            style: ElevatedButton.styleFrom(primary: Colors.white),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ReportPage(),
                  ));
            },
            child: Text(
              'Monthly',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(color: Colors.pinkAccent, width: 2))),
          child: TextButton(
            style: ElevatedButton.styleFrom(primary: Colors.white),
            child: Text(
              'Yearly',
              style: TextStyle(
                fontSize: 16,
                color: Colors.pinkAccent,
              ),
            ),
            onPressed: () {},
          ),
        ),
      ],
    );
  }

  //allows user to choose which year's report they want to view.
  Widget buildYearSelection(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width / 20,
        ),
        Container(
          height: MediaQuery.of(context).size.height / 25,
          width: MediaQuery.of(context).size.width / 6,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: Colors.black12)),
          child: DropdownButton(
            underline: SizedBox(),
            value: year,
            items: yeardropdownItems,
            onChanged: (int? newValue) {
              setState(() {
                year = newValue!;
              });
            },
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width / 20,
        ),
        ElevatedButton(
          onPressed: () {
            // update call the get report request again using month and year
            waitForServer(year);
          },
          child: Text(
            'Set',
            style: TextStyle(color: Colors.black),
          ),
          style: ElevatedButton.styleFrom(primary: Colors.white),
        )
      ],
      // )
    );
  }

  //if [errorCode] of [ReportModel] is negative, only the error message will be displayed.
  //else, the line graph, categorical line indicators and top receipts are displayed.
  Widget buildBody(BuildContext context) {
    if ((reportModel?.errorCode as int) < 0) {
      return Center(
        child: Text(reportModel?.errorMsg as String),
      );
    } else {
      return Expanded(
          child: Column(
        children: [
          //line graph for expenditure over month
          Expanded(
            flex: 5,
            child: buildLineGraph(context),
          ),

          //Categorical line bar
          Expanded(
            flex: 4,
            child: Card(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 20,
                      ),
                      Text(
                        'Categories',
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Expanded(child: buildCategoryIndicator('Groceries')),
                  Expanded(child: buildCategoryIndicator("Food")),
                  Expanded(child: buildCategoryIndicator("Electronics")),
                  Expanded(child: buildCategoryIndicator('Fashion')),
                ],
              ),
            ),
          ),

          //list of top receipts
          Expanded(
            flex: 3,
            child: buildTopReceipts(context),
          ),
        ],
      ));
    }
  }

  //build and plot line graph of amount spent against month.
  Widget buildLineGraph(BuildContext context) {
    return Card(
      child: SfCartesianChart(
        palette: [Colors.pinkAccent],
        title: ChartTitle(
          text: 'Expenditure : ' +
              '\$' +
              (reportModel?.data?.totalExpenditure!.toStringAsFixed(2)
                  as String),
          textStyle: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
          alignment: ChartAlignment.near,
        ),
        primaryXAxis: CategoryAxis(
            title: AxisTitle(text: 'Months', alignment: ChartAlignment.center)),
        primaryYAxis: NumericAxis(
            numberFormat: NumberFormat.simpleCurrency(decimalDigits: 2)),
        series: <ChartSeries<MonthlySpending, String>>[
          LineSeries<MonthlySpending, String>(
            dataSource: monthlySpending,
            xValueMapper: (MonthlySpending m, _) => m.month,
            yValueMapper: (MonthlySpending m, _) => m.spending,
          )
        ],
      ),
    );
  }

  //build indicator for specific category to show what percentage of the total amount is spent on this category.
  Widget buildCategoryIndicator(String category) {
    Map<String, Icon> icons = {
      'Groceries': Icon(
        Icons.local_grocery_store_outlined,
        color: Colors.black,
        size: MediaQuery.of(context).size.width / 12,
        semanticLabel: 'Text to announce in accessibility modes',
      ),
      'Food': Icon(
        Icons.fastfood_outlined,
        color: Colors.black,
        size: MediaQuery.of(context).size.width / 12,
        semanticLabel: 'Text to announce in accessibility modes',
      ),
      'Electronics': Icon(
        Icons.computer_outlined,
        color: Colors.black,
        size: MediaQuery.of(context).size.width / 12,
        semanticLabel: 'Text to announce in accessibility modes',
      ),
      'Fashion': Icon(
        Icons.shopping_bag_outlined,
        color: Colors.black,
        size: MediaQuery.of(context).size.width / 12,
        semanticLabel: 'Text to announce in accessibility modes',
      ),
    };
    return Row(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width / 20,
        ),
        icons[category] as Icon,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width / 30,
                ),
                Text(category,
                    style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.w400)),
              ],
            ),
            LinearPercentIndicator(
              percent: (categories.entries
                      .firstWhere((element) => element.key == category)
                      .value) /
                  100,
              width: MediaQuery.of(context).size.width / 1.25,
              animation: true,
              lineHeight: 12.0,
              animationDuration: 2000,
              center: Text(
                  (categories[category]?.toStringAsFixed(2) as String) + '%',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
              barRadius: Radius.circular(10),
              progressColor: Colors.pinkAccent,
              backgroundColor: Colors.blueGrey.shade100,
            )
          ],
        )
      ],
    );
  }

  //display list of top receipts for the year.
  Widget buildTopReceipts(BuildContext context) {
    return Card(
        child: Container(
            // decoration: boxDecoration,
            padding: const EdgeInsets.only(bottom: 5.0),
            height: MediaQuery.of(context).size.height / 5,
            width: MediaQuery.of(context).size.width / 1.02,
            child: Column(
              children: [
                Expanded(
                  flex: 1,
                  child: Row(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 20,
                      ),
                      Text(
                        'Top receipts',
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemCount: reportModel?.data?.topReceipts?.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DetailedReceiptPage(
                                        singleReceipt: reportModel
                                                ?.data!.topReceipts![index]
                                            as ReceiptData)));
                          },
                          child: Card(
                            child: TruncatedTiles.receipt(
                                merchantName: reportModel?.data
                                    ?.topReceipts?[index].merchant as String,
                                category: reportModel?.data?.topReceipts?[index]
                                    .category as String,
                                price: reportModel?.data?.topReceipts?[index]
                                    .totalPrice as double,
                                isMerchant: false,
                                dateTime: reportModel?.data?.topReceipts?[index]
                                    .dateTime as String),
                          ));
                    },
                  ),
                )
              ],
            )));
  }
}

///data used to plot the monthly expenditure line graph.
///the value of [spending] is the amount of money spent in that [month].
class MonthlySpending {
  final String month;
  final double spending;

  MonthlySpending(this.month, this.spending);
}
