import 'package:cz2006/Displays/bottom_navigation_bar.dart';
import 'package:cz2006/Displays/single_merchant_map.dart';
import 'package:cz2006/Model/model_utils.dart';
import 'package:cz2006/Request/NetManager.dart';
import 'package:flutter/material.dart';

import 'home.dart';

///View details of a particular receipt.
///Details include merchant name, category of purchase, date and time of purchase, details of products purchased, total price and additional information.
///Users can navigate to a SingleMerchantMap page related to the merchant in the receipt.
///[ReceiptData] is passed from Home() when user presses a receipt from the list.

class DetailedReceiptPage extends StatefulWidget {
  DetailedReceiptPage({Key? key, required this.singleReceipt})
      : super(key: key);
  ReceiptData singleReceipt;
  @override
  _DetailedReceiptPageState createState() => _DetailedReceiptPageState();
}

class _DetailedReceiptPageState extends State<DetailedReceiptPage> {
  MyNavigationBar navigation_bar = MyNavigationBar(selected_index: 0);

  //Convert list of products to list of datarows to display products in a table.
  List<DataRow> getProductList() {
    List<DataRow> ls = [];
    for (Product i in widget.singleReceipt.products!) {
      ls.add(DataRow(cells: <DataCell>[
        DataCell(Text(i.quantity.toString())),
        DataCell(Text(
          i.pname,
          softWrap: true,
        )),
        DataCell(Text('\$' + i.unitPrice.toStringAsFixed(2))),
      ]));
    }
    return ls;
  }

  //build scaffold for detailed receipt page.
  //components are the back button to return to Home(), contents of receipt, button to navigate to SingleMerchantMap page and navigation bar.
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      //back button
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.grey),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor:
            Colors.white.withOpacity(0), //You can make this transparent
        elevation: 0.0, //No shadow
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildReceiptCard(context),
            //button to navigate to SingleMerchantMap page.
            Align(
              alignment: FractionalOffset.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 3.7,
                  ),
                  Container(
                    child: ElevatedButton(
                      style:
                          ElevatedButton.styleFrom(primary: Colors.pinkAccent),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SingleMerchantMapPage(
                                    merchantName: widget.singleReceipt.merchant
                                        as String)));
                      },
                      child: Text(
                        "View Merchant",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width / 6),
                    child: Container(
                      child: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                content: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          primary: Colors.white,
                                        ),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                          'Go Back',
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ),
                                      ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            primary: Colors.red,
                                          ),
                                          onPressed: () {
                                            Future<MessageModel> future =
                                                NetManager
                                                    .makeDeleteReceiptRequest(
                                                        widget.singleReceipt);
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => HomePage(
                                                  filter: SearchFilter.empty(),
                                                ),
                                              ),
                                            );
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  content: Text(
                                                      'Receipt has been deleted!'),
                                                );
                                              },
                                            );
                                            future.then((value) {
                                              if (value.errorCode! >= 0) {
                                                print(
                                                    'receipt has been deleted');
                                              } else {
                                                showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return AlertDialog(
                                                      content: Text(
                                                          'Receipt unable to be deleted'),
                                                    );
                                                  },
                                                );
                                              }
                                            });
                                          },
                                          child: Text(
                                            'Confirm Delete',
                                            style:
                                                TextStyle(color: Colors.white),
                                          )),
                                    ]),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: navigation_bar,
    ));
  }

  //build the detailed receipt in a Card().
  Widget buildReceiptCard(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 1.5,
      child: Card(
        child: Column(
          children: [
            //merchant name and category of purchase.
            Expanded(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 20,
                    ),
                    Text(widget.singleReceipt.merchant as String),
                  ],
                ),
                Row(
                  children: [
                    Text(widget.singleReceipt.category as String),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 20,
                    )
                  ],
                ),
              ],
            )),

            //address of merchant
            Expanded(
              child: Row(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 20,
                  ),
                  Expanded(
                    child: Text(
                      widget.singleReceipt.address as String,
                      softWrap: true,
                    ),
                  )
                ],
                mainAxisAlignment: MainAxisAlignment.start,
              ),
            ),

            //date and time of purchase
            Expanded(
              child: Row(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 20,
                  ),
                  Text(widget.singleReceipt.dateTime as String),
                ],
                mainAxisAlignment: MainAxisAlignment.start,
              ),
            ),

            //table of product details.
            //The columns of the table are quantity purchased, name of product and price of the product per unit quantity.
            Expanded(
              flex: 5,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: DataTable(
                  columnSpacing: 10,
                  columns: <DataColumn>[
                    DataColumn(
                        label: Container(
                            width: MediaQuery.of(context).size.width / 15,
                            child: Text('Qty',
                                style:
                                    TextStyle(fontStyle: FontStyle.italic)))),
                    DataColumn(
                        label: Container(
                            width: MediaQuery.of(context).size.width / 2,
                            child: Text('Description',
                                style:
                                    TextStyle(fontStyle: FontStyle.italic)))),
                    DataColumn(
                        label: Container(
                            width: MediaQuery.of(context).size.width / 6,
                            child: Text('Unit Price',
                                style: TextStyle(fontStyle: FontStyle.italic))))
                  ],
                  rows: getProductList(),
                ),
              ),
            ),

            // total price of receipt.
            Expanded(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(width: MediaQuery.of(context).size.width/20,),
                    Expanded(flex: 1,child: Row(children: [Text('Total Price')],mainAxisAlignment: MainAxisAlignment.start)),
                    Expanded(flex: 1,child: Row(children: [Text('\$' + (widget.singleReceipt.totalPrice as double).toStringAsFixed(2))],mainAxisAlignment: MainAxisAlignment.end,)),
                    SizedBox(width: MediaQuery.of(context).size.width/20,)
                  ]),
            ),
      Divider(
              height: 10,
              color: Colors.black,
              indent: MediaQuery.of(context).size.width / 20,
              endIndent: MediaQuery.of(context).size.width / 20,),

            //additional information.
            Expanded(
              child: Row(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 20,
                  ),
                  Expanded(
                    child: Text(
                      widget.singleReceipt.content as String,
                      softWrap: true,
                    ),
                  ),
                ],
                mainAxisAlignment: MainAxisAlignment.start,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
