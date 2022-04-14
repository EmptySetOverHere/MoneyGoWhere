//used to build the truncated versions of the receipt and merchant summaries

import 'package:flutter/material.dart';

///TruncatedTiles will build the children for the ListView when displaying list of merchant summaries or truncated receipts.
///[merchantName]
///[category]  : category this purchase/merchant belongs to
///[price] : total price of the receipt or the total amt of money spent at the merchant
///[isMerchant] : flag to indicate whether the tile should be in the merchant or receipt format.
///[address] : address of merchant, only for merchant tiles.
///[dateTime] : date time of the purchase, only for receipt tiles.
class TruncatedTiles extends StatefulWidget{
  //variables required for the class
  String merchantName = '';
  String category = '';
  double price = 0.0;
  bool isMerchant = false;
  String? address;
  String? dateTime;

  // constructors for truncated tiles

  ///constructor for merchants
  TruncatedTiles.merchant({
    Key? key,
    required this.merchantName,
    required this.category,
    required this.price,
    required this.isMerchant,
    required this.address,
  }) : super(key: key);

  ///constructor for receipts
  TruncatedTiles.receipt({
    Key? key,
    required this.merchantName,
    required this.category,
    required this.price,
    required this.isMerchant,
    required this.dateTime
  }) : super(key: key);

  @override
  _TruncatedTilesState createState() =>_TruncatedTilesState();
}


class _TruncatedTilesState extends State<TruncatedTiles>{
  //builds the individual tiles.
  @override
  Widget build(BuildContext context){
    return Padding(
        padding: EdgeInsets.all(1.0),
        child: SizedBox(
          height: MediaQuery.of(context).size.height/8,
          width: MediaQuery.of(context).size.width,
          child:
              Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex:1,
                        child: widget.isMerchant?Text(widget.merchantName, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),softWrap: true,)
                              :Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                          Text(widget.merchantName, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),softWrap: true,),
                          Text('\$'+widget.price.toStringAsFixed(2), style: TextStyle(fontSize: 15))
                        ],)),
                      Expanded(
                        flex:1,
                        child: widget.isMerchant? Text(widget.address as String, style: TextStyle(fontSize: 15),softWrap:true,)
                            :Text(widget.category, style: TextStyle(fontSize: 15),softWrap:true,),
                      ),
                      Expanded(
                          flex:1,
                          child:widget.isMerchant? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                            Text(widget.category + ' | Total amount spent: ', style: TextStyle(fontSize: 15),),
                            Text('\$'+widget.price.toStringAsFixed(2), style: TextStyle(fontSize: 15),)
                            ],)
                              :Text(widget.dateTime as String, style: TextStyle(fontSize: 15),
                          )
                      ),
                    ],
                  ),
          ),
    );
  }
}