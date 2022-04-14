import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../Displays/bottom_navigation_bar.dart';
import '../Displays/TruncatedTiles.dart';
import '../Displays/home.dart';
import '../Model/model_utils.dart';
import '../Request/NetManager.dart';

///SingleMerchantMap displays the map and truncated tile for one merchant.
///This display page can be accessed from the Map page when the user taps on one of the tiles in the listView or from DetailedReceipt page.
///[merchantName] is the name of the merchant used to get the merchant's data from the server.

class SingleMerchantMapPage extends StatefulWidget {
  SingleMerchantMapPage({Key? key, required this.merchantName}) : super(key: key);
  String merchantName = '';

  @override
  _SingleMerchantMapPage createState() => _SingleMerchantMapPage();
}

class _SingleMerchantMapPage extends State<SingleMerchantMapPage> {
  MyNavigationBar navigation_bar = MyNavigationBar(selected_index: 2);
  GoogleMapController? _controller;
  MerchantsModel? singleMerchant;

  //marker used to display the location of the merchant.
  final Set<Marker> marker = new Set();

  //default center position to initialise the map to.
  LatLng singleLL = LatLng(1.290270, 103.851959);
  bool notloaded =true;
  @override
  void initState(){
    waitforServer();
  }

  //makes request for [MerchantModel].
  void waitforServer() async{
    print(widget.merchantName);
    await NetManager.makeMerchantsRequest(widget.merchantName).then((val) {
      setState(() {
        singleMerchant = val as MerchantsModel;
        notloaded =false;
      });
    });
  }

  //Get the latitude-longitude of the merchant's location from its postal code.
  //initialise [marker] with the merchant's LatLng
  //Animate the map to be centered at the merchant's location.
  void _onMapCreated(GoogleMapController controller) async {
    setState(() {
      _controller = controller;});

    await NetManager.getLatLong(singleMerchant?.data?[0].postalCode as int)
        .then((val) {
      setState(() {
        marker.add(Marker(
            markerId: MarkerId('Prime'),
            position: val,
            infoWindow: InfoWindow(
              title: 'Prime',
              snippet: singleMerchant?.data?[0].address as String,
            )));
      });

      //animate map to center on the markers
      _controller?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: val, zoom:15)));
    });
  }



  Widget buildSingleMerchant(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 1.2,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          //map with the marker for the merchant.
          Container(
            padding: EdgeInsets.fromLTRB(
                MediaQuery.of(context).size.width / 60,
                MediaQuery.of(context).size.height / 50,
                MediaQuery.of(context).size.width / 60,
                MediaQuery.of(context).size.height / 50),
            height: MediaQuery.of(context).size.height * 2 / 3,
            child: GoogleMap(
              onMapCreated: (c) => _onMapCreated(c),
              initialCameraPosition: CameraPosition(
                target: singleLL,
                zoom: 20,
              ),
              markers: marker,
            ),
          ),

          //merchant summary
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: GestureDetector(
                onTap: () {
                  print(
                      'from single merchant map, go to home page and search for merchant name.');
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => HomePage(
                              filter: SearchFilter.fromParams(
                                  content: widget.merchantName))));
                },
                child: Padding(
                  padding: EdgeInsets.all(0.3),
                  child: TruncatedTiles.merchant(
                    isMerchant: true,
                    merchantName: singleMerchant?.data?[0].name as String,
                    address: singleMerchant?.data?[0].address as String,
                    category: singleMerchant?.data?[0].category as String,
                    price: singleMerchant?.data?[0].totalExpense as double,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }


  //build scaffold for SingleMerchantMao.
  //components include: map centered on the merchant chosen to display and merchant details.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,

      //back button to return to previous page.
      appBar: AppBar(
        leading: BackButton(
        onPressed: (){Navigator.pop(context);},
        color: Colors.black,
        ),
        backgroundColor: Colors.white,
      ),
      body: notloaded?Center(child: CircularProgressIndicator(color: Colors.pinkAccent,),)
          :buildSingleMerchant(context),
      bottomNavigationBar: navigation_bar,
    );
  }
}
