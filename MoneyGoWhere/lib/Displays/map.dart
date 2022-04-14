
import 'dart:async';
import 'package:flutter/material.dart';
import 'TruncatedTiles.dart';
import 'single_merchant_map.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../Model/Merchant_Model.dart';
import 'package:flutter/widgets.dart';
import '../Request/NetManager.dart';
import '../Displays/bottom_navigation_bar.dart';

///MerchantMap displays a map with the locations where the user has previously purchased from,
///along with a list of these merchants.
///[searh] is the search term used to request for [MerchantModel] from server.
class MerchantMapPage extends StatefulWidget{
  MerchantMapPage({Key? key, required this.search}): super(key:key);
  String search;
  @override
  _MerchantMapPageState createState() => _MerchantMapPageState();
}


class _MerchantMapPageState extends State<MerchantMapPage> {
  //search bar and navigation bar variables
  MyNavigationBar navigation_bar = MyNavigationBar(selected_index: 2);
  TextEditingController _searchController = TextEditingController();

  MerchantsModel? mer;
  int numOfMerchants = 0;
  //list of markers to be displayed on google map rendered.
  var marker = <Marker>[];

  //default center location to initialise map to.
  LatLng centre = LatLng(1.290270, 103.851959);

  //list of LatLng of merchants to use.
  List<LatLng> ll = [];

  //controller for google map.
  GoogleMapController? _MapController;
  bool notloaded = true;


  @override
  void initState(){
      waitforServer();
  }

  //makes request for [MerchantModel].
  void waitforServer() async{
    await NetManager.makeMerchantsRequest(widget.search).then((val) {
      setState(() {
        mer = val as MerchantsModel;
        notloaded = false;
        _createMapAgain();
      });
    });
  }

  void _createMapAgain() {
    _onMapCreated(_MapController as GoogleMapController);
  }

  //Populate [ll] with LatLng of merchant locations.
  //populate [markers] for display on the map.
  //Animate the map camera to be positioned over the center location of the markers.
  void _onMapCreated(GoogleMapController controller) async {
    //get number of merchants and set controller
    setState(() {
      numOfMerchants = mer?.data?.length as int;
      _MapController = controller;

      });


    //get the latitude and longitude values of each merchant, converted from postal codes.
    for (int i = 0; i < numOfMerchants; i++) {
      await NetManager.getLatLong(mer?.data?[i].postalCode as int).then((value) {
        setState(() {
          ll.add(value as LatLng );
        });
      });
    }

    //get marker for each merchant
    setState(() {
      for(int i=0;i<numOfMerchants;i++){
        final m = Marker(
            markerId: MarkerId(mer?.data?[i].name as String),
            position: ll[i],
            infoWindow: InfoWindow(
              title: mer?.data?[i].name as String,
              snippet: mer?.data?[i].address as String,
            )
        );
        marker.add(m);
      }
    });

    //compute center position for map as the average of all the lat and long
    double latitude = 0;
    double longitude = 0;
    for (int i = 0; i < numOfMerchants; i++) {
      latitude += ll[i].latitude as double;
      longitude += ll[i].longitude as double;
    }
    var newcentre = LatLng(latitude/numOfMerchants, longitude/numOfMerchants);

    //animate map to center on the markers
    _MapController?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: newcentre, zoom:10)));
  }

  //handle search for merchant by making request to server for matching list of merchants.
  //if [_searchController] is empty, search query is set to null string.
  //else, search text is updated and request to server is made again.
  void _onPressSearch () {
    setState(() {
      if(_searchController.text.isEmpty)
      { widget.search = '';}
      else {
        print('updated search');
        widget.search = _searchController.text;
        ll.clear();
        marker.clear();
        waitforServer();

      }
    }
    );
  }

  //build the scaffold for map.
  //components are search bar, map with markers for each merchant, list of merchants and navigation bar.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,

      //search bar.
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
              hintStyle: TextStyle(color: Colors.black54)
          ),
        ),
      ),
      body: notloaded?Center(child: CircularProgressIndicator(color: Colors.pinkAccent,),)
          :buildMapAndList(context),
    bottomNavigationBar: navigation_bar,);

  }

  //build map and list combination column
  //if [errorCode] in [MerchantModel] is negative, only the error message is displayed.
  //else the map and list of merchants are built and displayed.
  Widget buildMapAndList(BuildContext context){
    if (mer?.errorCode as int <0){
      return
        Center(
          child: Text(mer?.errorMsg as String, style: TextStyle(color: Colors.black),)
      );
    }
    else{
      return Container(
        height: MediaQuery.of(context).size.height/1.2,
        child:  Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              //map with markers for each merchant.
              Expanded(
                flex: 3,
                child:  Container(
                  padding: EdgeInsets.fromLTRB(MediaQuery
                      .of(context)
                      .size
                      .width / 60, MediaQuery
                      .of(context)
                      .size
                      .height / 60, MediaQuery
                      .of(context)
                      .size
                      .width / 60, MediaQuery
                      .of(context)
                      .size
                      .height / 60),

                  child: GoogleMap(
                    onMapCreated: (GoogleMapController c) {
                      _onMapCreated(c);
                    },
                    initialCameraPosition: CameraPosition(
                      target: centre,
                      zoom: 12,
                    ),
                    markers: Set<Marker>.of(marker),
                  ),
                ),
              ),

              //list of merchant summaries
              Expanded(
                flex: 1,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child:
                  Container(
                    height: MediaQuery
                        .of(context)
                        .size
                        .height / 5,
                    child:
                    _buildMerchantSummary(),
                  ),
                ),
              ),
            ]),
      );

    }
  }

  //list of merchant summaries using ListView.builder and list items are TruncatedTiles.
  //each tile can be pressed to be directed to SingleMerchantMap page for that merchant.
  Widget _buildMerchantSummary() {
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: mer?.data?.length as int,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            print(mer?.data?[index].name);
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context)=> SingleMerchantMapPage(merchantName: mer?.data?[index].name as String)));
          },
          child: Card(
              child: TruncatedTiles.merchant(isMerchant: true,
                  merchantName: mer?.data?[index].name as String,
                  price: mer?.data?[index].totalExpense as double,
                  category: mer?.data?[index].category as String,
                  address: mer?.data?[index].address as String)
          ),
        );
      },
    );
  }
}