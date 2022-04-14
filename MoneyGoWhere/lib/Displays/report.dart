import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../Displays/TruncatedTiles.dart';
import '../Displays/bottom_navigation_bar.dart';
import '../Displays/detailed_receipt.dart';
import '../Displays/report_yearly.dart';
import '../Model/model_utils.dart';
import '../Request/NetManager.dart';

///Displays monthly expenditure report for user.
///User is able to select which month's report to display.
///Details displayed include line graph tracking daily spending, total expenditure for the month, categorical breakdown of expenditure, list of top receipts.

class ReportPage extends StatefulWidget {
  ReportPage({Key? key}) : super(key: key);

  _ReportPageState createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  MyNavigationBar bar = MyNavigationBar(selected_index: 1);
  ReportModel? reportModel;

  //Map the categories to the percentage it takes up of the total expenditure in the month.
  Map<String, double> categories = {};

  //list of [Dailyspending] for plotting the graph.
  List<DailySpending> dailySpending = [];

  //default month to display for the report is the previous month
  //initalise month, year variables to make request.
  int month = DateTime.now().month.toInt() - 1;
  int year = DateTime.now().year.toInt();

  bool notloaded = true;
  //dropdown options for selecting month.
  List<DropdownMenuItem<int>> get monthdropdownItems {
    List<DropdownMenuItem<int>> menuItems = [
      DropdownMenuItem(child: Text('Month'), value: 0),
      DropdownMenuItem(child: Text('Jan'), value: 1),
      DropdownMenuItem(child: Text('Feb'), value: 2),
      DropdownMenuItem(child: Text('Mar'), value: 3),
      DropdownMenuItem(child: Text('Apr'), value: 4),
      DropdownMenuItem(child: Text('May'), value: 5),
      DropdownMenuItem(child: Text('June'), value: 6),
      DropdownMenuItem(child: Text('July'), value: 7),
      DropdownMenuItem(child: Text('Aug'), value: 8),
      DropdownMenuItem(child: Text('Sept'), value: 9),
      DropdownMenuItem(child: Text('Oct'), value: 10),
      DropdownMenuItem(child: Text('Nov'), value: 11),
      DropdownMenuItem(child: Text('Dec'), value: 12),
    ];
    return menuItems;
  }

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
    waitForServer(month, year);
  }

  //make request to server for report data.
  //initialise [categories] and [dailyspending] to display categorical line indicator and line graph respectively.
  void waitForServer(int month, int year) async {
    await NetManager.makeGetMonthReportModelRequest(year, month).then((val) {
      setState(() {
        reportModel = val as ReportModel;
        notloaded = false;
      });
    });
    if ((reportModel?.errorCode as int) < 0) {
      return;
    }
    setState(() {
      double val = 0;
      double total = reportModel?.data?.totalExpenditure as double;
      reportModel?.data?.categoricalExpenses!.forEach((key, value) {
        val = (value as double) / total * 100;
        categories.addAll({key: val});
      });

      dailySpending.clear();
      if (!categories.containsKey('Groceries')) {
        categories.addAll({'Groceries': 0});
      }
      if (!categories.containsKey('Food')) {
        categories.addAll({'Food': 0});
      }
      if (!categories.containsKey('Fashion')) {
        categories.addAll({'Fashion': 0});
      }
      if (!categories.containsKey('Electronics')) {
        categories.addAll({'Electronics': 0});
      }

      int numDays = reportModel?.data?.unitExpenses!.length as int;
      for (int i = 0; i < numDays; i++) {
        dailySpending.add(DailySpending(
            i + 1, reportModel?.data?.unitExpenses![i] as double));
      }
    });
  }

  //build scaffold for report page.
  //components include: selection to display monthly/yearly report, month-year seleciton for displaying monthly report,main body.
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,

      //selection to display monthly/yearly report
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
                    child: buildMonthYearSelection(context),
                  ),

                  //main report body.
                  buildBody(context)
                ],
              )),
      bottomNavigationBar: bar,
    );
  }

  //build bar to select viewing monthly or yearly report.
  //if yearly is selected, will navigate to the ReportYearly page.
  Widget buildMonthYearBar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Container(
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(color: Colors.pinkAccent, width: 2))),
          child: TextButton(
            style: ElevatedButton.styleFrom(primary: Colors.white),
            onPressed: () {},
            child: Text(
              'Monthly',
              style: TextStyle(
                fontSize: 16,
                color: Colors.pinkAccent,
              ),
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
              border:
                  Border(bottom: BorderSide(color: Colors.white, width: 2))),
          child: TextButton(
            style: ElevatedButton.styleFrom(primary: Colors.white),
            child: Text(
              'Yearly',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ReportYearlyPage(),
                  ));
            },
          ),
        ),
      ],
    );
  }

  //allows user to choose which month and year's report they want to view.
  Widget buildMonthYearSelection(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width / 20,
        ),
        Container(
          height: MediaQuery.of(context).size.height / 25,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: Colors.black12)),
          alignment: Alignment.center,
          child: DropdownButton(
            underline: SizedBox(),
            value: month,
            items: monthdropdownItems,
            onChanged: (int? newValue) {
              setState(() {
                month = newValue!;
              });
            },
          ),
        ),
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
            setState(() {
              waitForServer(month, year);
            });
          },
          child: Text(
            'Set',
            style: TextStyle(color: Colors.black),
          ),
          style: ElevatedButton.styleFrom(primary: Colors.white),
        )
      ],
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
        ),
      );
    }
  }

  //build and plot line graph of amount spent against day.
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
        primaryXAxis: NumericAxis(
            title: AxisTitle(text: 'Days', alignment: ChartAlignment.center)),
        primaryYAxis: NumericAxis(
            numberFormat: NumberFormat.simpleCurrency(decimalDigits: 2)),
        series: <ChartSeries<DailySpending, int>>[
          LineSeries<DailySpending, int>(
            dataSource: dailySpending,
            xValueMapper: (DailySpending d, _) => d.day,
            yValueMapper: (DailySpending d, _) => d.spending,
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

  //display list of top receipts for that month.
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

///data used to plot the daily expenditure line graph.
///the value of [spending] is the amount of money spent in that [day].
class DailySpending {
  final int day;
  final double spending;

  DailySpending(this.day, this.spending);
}
