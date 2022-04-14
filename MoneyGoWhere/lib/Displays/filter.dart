import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../Model/Receipt_Model.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import '../Displays/bottom_navigation_bar.dart';
import 'package:intl/intl.dart';

/// Select filter choices on price range, date range and categories to include.
/// Takes in [SearchFilter] to edit and be passed back to Home() when the user clicks the back button.

class FilterPage extends StatefulWidget {
  FilterPage({Key? key, required this.filter}) : super(key: key);
  SearchFilter filter;

  @override
  _FilterPageState createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  //To select the date range.
  DateRangePickerController _dateRangePickerController =
      DateRangePickerController();

  //Boolean variables to indicate whether the categories have been selected or not.
  bool isGroceries = false;
  bool isFashion = false;
  bool isFood = false;
  bool isElectronics = false;

  //Boolean variable to indicate whether the user has decided on a price range to filter by.
  bool setPriceRange = false;

  //To vary price range.
  SfRangeValues priceRange = SfRangeValues(0, 0);

  MyNavigationBar navigation_bar = MyNavigationBar(selected_index: 0);

  //Initialise state of the filter by reflecting the [SearchFilter] values passed to this page from Home().
  void initState() {
    super.initState();
    if(widget.filter.startDate!= null && widget.filter.endDate != null){
      _dateRangePickerController.selectedRange = PickerDateRange(DateTime.tryParse(widget.filter.startDate as String), DateTime.tryParse(widget.filter.endDate as String));
    }
    if (widget.filter.priceUpper != null && widget.filter.priceLower != null) {
      priceRange = SfRangeValues(widget.filter.priceLower as double,
          widget.filter.priceUpper as double);
    }
    if (widget.filter.category != null) {
      if (widget.filter.category?.contains('Groceries') != null &&
          widget.filter.category?.contains('Groceries') == true) {
        isGroceries = true;
      }
      if (widget.filter.category?.contains('Food') != null &&
          widget.filter.category?.contains('Food') == true) {
        isFood = true;
      }
      if (widget.filter.category?.contains('Fashion') != null &&
          widget.filter.category?.contains('Fashion') == true) {
        isFashion = true;
      }
      if (widget.filter.category?.contains('Electronics') != null &&
          widget.filter.category?.contains('Electronics') == true) {
        isElectronics = true;
      }
    }
  }

  //Handle the updates to [SearchFilter] before returning to Home().
  void backButton() {

    //check whether any category is selected.
    if(isGroceries || isFood || isFashion || isElectronics){
      //If category list passed into Filter() is null, assign an empty list to category.
      if(widget.filter.category == null) {widget.filter.category = [];}

      //for each filter category,
      //if selected, if this filter is not inside category[], add into the list.
      //otherwise, if this filter category is inside category[], remove from the list.
      if (isGroceries == true) {
        if(widget.filter.category?.indexOf('Groceries') == -1){
          widget.filter.category
              ?.add('Groceries');
        }
      } else {
        if(widget.filter.category?.indexOf('Groceries') != -1){
          widget.filter.category
              ?.remove('Groceries');
        }
      }
      if (isFood == true) {
        if(widget.filter.category?.indexOf('Food') == -1){
          widget.filter.category
              ?.add('Food');
        }
      } else {
        if(widget.filter.category?.indexOf('Food') != -1){
          widget.filter.category
              ?.remove('Food');
        }
      }

      if (isFashion == true) {
        if(widget.filter.category?.indexOf('Fashion') == -1){
          widget.filter.category
              ?.add('Fashion');
        }
      } else {
        if(widget.filter.category?.indexOf('Fashion') != -1){
          widget.filter.category
              ?.remove('Fashion');
        }
      }

      if (isElectronics == true) {
        if(widget.filter.category?.indexOf('Electronics') == -1){
          widget.filter.category
              ?.add('Electronics');
        }
      } else {
        print(widget.filter.category?.indexOf('Electronics').toString());
        if(widget.filter.category?.indexOf('Electronics') != -1){
          widget.filter.category
              ?.remove('Electronics');
        }
      }
    }
    else{widget.filter.category?.clear();}
    //return to Home() with the updated filter.
      Navigator.pop(context, widget.filter);
    }

    //When user submits date range, update values in the SearchFilter.
  void onSubmitDateRange(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      print(args.value.toString());

      widget.filter.startDate = DateFormat('dd-MM-yyyy').format(args.value.startDate);
      if(args.value.endDate!=null){
      widget.filter.endDate = DateFormat('dd-MM-yyyy').format(args.value.endDate);}
    });
  }

  //When user clears price range selector,
  //clear the SearchFilter price values and
  //reset the price range in slider to default value of 0,0.
  void _onClear(){
    if(setPriceRange == true){
      setState(() {
        setPriceRange = false;
        widget.filter.priceUpper = null;
        widget.filter.priceLower = null;
        priceRange = SfRangeValues(0, 0);
      });
    }
  }

  //build scaffold for filter page.
  //main components are back button, price range selector, category selector, date range selector and navigation bar.
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            extendBodyBehindAppBar: false,

            //search bar
            appBar: AppBar(
              leading: BackButton(
                onPressed: backButton,
                color: Colors.black,
              ),
              backgroundColor: Colors.white,
            ),
            body: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

              //get price inputs
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                    height: MediaQuery
                        .of(context)
                        .size
                        .height / 6.5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                            padding: EdgeInsets.symmetric(horizontal: 5),
                            child: Row(
                                children: [
                                  //Title for price section
                                  Text(
                                    'PRICE',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Expanded(flex: 6, child: SizedBox(),),

                                  //button to set price range
                                  Expanded(flex: 3, child: ElevatedButton(
                                      style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty
                                            .all(Colors.white),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          setPriceRange = true;
                                          widget.filter.priceLower = priceRange.start.toDouble();
                                          widget.filter.priceUpper = (priceRange.end == 1000)? null:priceRange.end.toDouble();
                                        });
                                      },
                                      child: Text('Set', style: TextStyle(
                                        color: Colors.black,),)
                                  )),
                                  Expanded(flex: 1, child: SizedBox(),),

                                  //button to clear prize range
                                  Expanded(flex: 3, child: ElevatedButton(
                                      style: ButtonStyle(
                                          backgroundColor: MaterialStateProperty
                                              .all(Colors.white)),
                                      onPressed: _onClear,
                                      child: Text('Clear', style: TextStyle(
                                        color: Colors.black,),)
                                  ))
                                ])
                        ),

                        //price range slider
                        Padding(
                            padding: EdgeInsets.symmetric(horizontal: 5),
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black54),
                                  borderRadius: BorderRadius.circular(10)),
                              child: SfRangeSlider(
                                  min: 0.0,
                                  max: 1000.0,
                                  values: priceRange,
                                  showLabels: true,
                                  labelFormatterCallback:
                                      (dynamic actualval,
                                      String formattedText) {
                                    if(actualval == 0){return '\$$formattedText';}
                                    else {return '>=\$1000';}

                                  },
                                  enableTooltip: true,
                                  tooltipTextFormatterCallback:
                                      (dynamic actualVal,
                                      String formattedText) {
                                    return '$formattedText';
                                  },
                                  onChanged: (SfRangeValues newRange) {
                                    setState(() {
                                      priceRange = newRange;
                                    });
                                  }),
                            ))
                      ],
                    )),
              ),

              //build category selector
              Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    //Title for category selector.
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      child: Text(
                        'CATEGORIES',
                        textAlign: TextAlign.left,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),

                    //gridview to select categories.
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black54),
                              borderRadius: BorderRadius.circular(10)),
                          height: MediaQuery
                              .of(context)
                              .size
                              .height / 6,
                          child: GridView.count(
                            crossAxisCount: 2,
                            childAspectRatio:
                            (MediaQuery
                                .of(context)
                                .size
                                .width / 2) /
                                (MediaQuery
                                    .of(context)
                                    .size
                                    .height /
                                    10),
                            children: [
                              Row(children: [
                                Expanded(
                                    child: Text(
                                      'Groceries',
                                      textAlign: TextAlign.center,
                                    )),
                                Checkbox(
                                    value: isGroceries,
                                    onChanged: (bool? newVal) {
                                      setState(() {
                                        isGroceries = newVal as bool;
                                      }
                                      );
                                    })
                              ]),
                              Row(children: [
                                Expanded(
                                    child: Text('Food',
                                        textAlign: TextAlign.center)),
                                Checkbox(
                                    value: isFood,
                                    onChanged: (bool? newVal) {
                                      setState(() {
                                        isFood = newVal as bool;
                                      });
                                    })
                              ]),
                              Row(children: [
                                Expanded(
                                    child: Text('Fashion',
                                        textAlign: TextAlign.center)),
                                Checkbox(
                                    value: isFashion,
                                    onChanged: (bool? newVal) {
                                      setState(() {
                                        isFashion = newVal as bool;
                                      });
                                    })
                              ]),
                              Row(children: [
                                Expanded(
                                    child: Text('Electronics',
                                        textAlign: TextAlign.center)),
                                Checkbox(
                                    value: isElectronics,
                                    onChanged: (bool? newVal) {
                                      setState(() {
                                        isElectronics = newVal as bool;
                                      });
                                    })
                              ])
                            ],
                          )),
                    )
                  ]),

              //build date selector
              Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //title for date selector.
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      child: Text(
                        'DATE RANGE',
                        textAlign: TextAlign.left,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),

                    //calendar for date selector
                    Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black54),
                              borderRadius: BorderRadius.circular(10)),
                          child: SfDateRangePicker(
                            view: DateRangePickerView.month,
                            onSelectionChanged: onSubmitDateRange,
                            monthViewSettings:
                            DateRangePickerMonthViewSettings(
                                firstDayOfWeek: 7),
                            selectionMode:
                            DateRangePickerSelectionMode.range,
                            showActionButtons: true,
                            controller: _dateRangePickerController,
                            onSubmit: (Object? val) {
                              // print(args.visibleDateRange.startDate as String);
                              onSubmitDateRange;
                            },
                            onCancel: () {
                              _dateRangePickerController.selectedRanges =
                              null;
                              setState(() {
                                widget.filter.startDate = null;
                                widget.filter.endDate = null;
                              });
                            },
                          ),
                        ))
                  ])
            ]),
          bottomNavigationBar: navigation_bar,
        )
    );
  }
}
