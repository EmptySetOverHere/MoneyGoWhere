import 'package:cz2006/Displays/detailed_receipt.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../Model/Receipt_Model.dart';
import '../Displays/filter.dart';
import 'TruncatedTiles.dart';
import '../Request/NetManager.dart';
import '../Displays/bottom_navigation_bar.dart';

///Displays the list of receipts belonging to the user.
///List of receipts can be sorted by date or price and filtered.
///Takes in [SearchFilter] as an argument which is used to request for receipts.

class HomePage extends StatefulWidget {
  HomePage({Key? key, required this.filter}) : super(key: key);
  SearchFilter filter;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //variables for searching function.
  TextEditingController _searchController = TextEditingController();
  String searchQuery = '';

  MyNavigationBar navigation_bar = MyNavigationBar(selected_index: 0);

  ReceiptsModel? receiptsModel;
  // Default ordering of receipts is in descending order for date (most recent first).
  // User can choose to order receipts by date or price.
  bool dateIsDescending = true;
  bool priceIsDescending = true;
  bool notloaded =true;
  //initialise state of the page.
  @override
  void initState() {
    waitforServer();


    print(receiptsModel?.data.toString());
  }

  //This function handles the selection of filters.
  //Users will be directed to the filter page and the current search filter applied is passed over.
  //Users will change their filter choices and will be redirected back to the home page with an updated [SearchFilter].
  //A request is made to the server to get receipts that match the filter choices.
  void getFilter(BuildContext context) async {
    print('filter pressed');
    SearchFilter result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FilterPage(
          filter: widget.filter,
        ),
      ),
    );
    setState(() {
      if (result.priceUpper != null) {
        widget.filter.priceUpper = result.priceUpper;
        print('max price set');
        print(widget.filter.priceUpper.toString());
      }
      if (result.priceLower != null) {
        widget.filter.priceLower = result.priceLower;
        print('min price set');
      }
      if (result.category != null) {
        widget.filter.category = result.category;
        print('categories set');
        print(widget.filter.category.toString());
      }
      if (result.endDate != null) {
        widget.filter.endDate = result.endDate;
        print('end date set');
      }
      if (result.startDate != null) {
        widget.filter.startDate = result.startDate;
        print('startdate set');
      }
    });
    waitforServer();
  }

  //This function will make a request to the server for receipts that match the user's search query.
  void _onPressSearch() {
      if (_searchController.text.isEmpty) {
        setState(() {searchQuery = '';});
      } else {
        print('updated search');
        widget.filter.content = _searchController.text;
        waitforServer();
        }
  }

  //Makes a request to the server for receipts by passing in [SearchFilter].
  //When null is passed to makeReceiptRequest, default list of all receipts is returned.
  void waitforServer() async{
    await NetManager.makeReceiptsRequest(widget.filter).then((val) {
      setState(() {
        receiptsModel = val;
          notloaded = false;
      });
    });
  }

  //sort by price in ascending order first.
  //if user wants in descending order, reverse the list.
  void sortPrice(bool isDescending){
    setState(() {
      print(isDescending.toString());
      if(isDescending){
        receiptsModel?.data?.sort((a,b) => b.totalPrice!.compareTo(a.totalPrice!));
      }
      else{
        receiptsModel?.data?.sort((a,b) => a.totalPrice!.compareTo(b.totalPrice!));
      }
    });
  }

  //sort by date in ascending order first.
  //if user wants in descending order, reverse the list.
  void sortDate(bool mostRecentFirst){
    setState(() {
          print(mostRecentFirst.toString());
          if (mostRecentFirst){ receiptsModel?.data?.sort((a,b) => b.dateTime!.compareTo(a.dateTime!)); }
          else{
            receiptsModel?.data?.sort((a,b) => a.dateTime!.compareTo(b.dateTime!));
          }
        });
    }

  //Build the scaffold for the home page.
  //Main components are the search bar, filter and sorting selections, list of truncated receipts and the navigation bar.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,

      //Search bar
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          color: Colors.black,
          icon: Icon(Icons.search),
          onPressed: _onPressSearch,
        ),
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
              hintText: 'Enter search',
              hintStyle: TextStyle(color: Colors.black54)),
        ),
      ),
      body: notloaded?Center(child: CircularProgressIndicator(color: Colors.pinkAccent,),)
          :Column(
        children: [
          //sort and filter.
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width / 20,
              ),
              ElevatedButton.icon(
                  onPressed: (){
                    setState(() {
                      dateIsDescending = !dateIsDescending;
                      print(dateIsDescending.toString());
                      sortDate(dateIsDescending);
                    });
                  },
                  icon: RotatedBox(
                    quarterTurns: 1,
                    child: Icon(
                      Icons.compare_arrows,
                      color: Colors.pink.shade200,
                    ),
                  ),
                  label:Text(
                    'Date',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                style: ButtonStyle(backgroundColor: MaterialStateProperty
                    .all(Colors.white)),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 20,
              ),
              ElevatedButton.icon(
                  onPressed: (){
                    setState(() {
                      priceIsDescending = !priceIsDescending;
                      print(priceIsDescending.toString());
                      sortPrice(priceIsDescending);
                    });
                  },
                  icon: RotatedBox(
                    quarterTurns: 1,
                    child: Icon(
                      Icons.compare_arrows,
                      color: Colors.pink.shade200,
                    ),
                  ),
                  label:Text(
                    'Price',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                style: ButtonStyle(backgroundColor: MaterialStateProperty
                    .all(Colors.white)),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 20,
              ),

              MaterialButton(
                    onPressed: () {
                      getFilter(context);
                    },
                    child: const Text(
                      'Filter',
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'OpenSans',
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
          ),

          //list of receipts.
          Container(
            height: MediaQuery.of(context).size.height / 1.4,
            width: MediaQuery.of(context).size.width / 1.1,
            child: (receiptsModel?.errorCode as int < 0)
                ? Center(child: Text(receiptsModel?.errorMsg as String,
                style: TextStyle(color: Colors.black)),)
                : ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: receiptsModel?.data?.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder:
                          (context) =>
                              DetailedReceiptPage(singleReceipt: receiptsModel?.data![index] as ReceiptData)));
                        },
                        child: Card(
                          child: TruncatedTiles.receipt(
                            isMerchant: false,
                            merchantName:
                                receiptsModel?.data?[index].merchant as String,
                            price: receiptsModel?.data?[index].totalPrice
                                as double,
                            category:
                                receiptsModel?.data?[index].category as String,
                            dateTime:
                                receiptsModel?.data?[index].dateTime as String,
                          ),
                        ),
                      );
                    },
                  ),
          )
        ],
      ),
      bottomNavigationBar: navigation_bar,
    );
  }
}
