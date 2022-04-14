import 'package:cz2006/Model/model_utils.dart';
import 'package:flutter/material.dart';

import '../Displays/account.dart';
import '../Displays/home.dart';
import '../Displays/map.dart';
import '../Displays/report.dart';

/// widget for bottom navigation bar for the application.
/// to navigate around the different pages of the application.
/// [selected_index] determines which icon in the bar to be highlighted as selected.

class MyNavigationBar extends StatefulWidget {
  MyNavigationBar({Key? key, required this.selected_index}) : super(key: key);
  int selected_index;
  @override
  _MyNavigationBarState createState() => _MyNavigationBarState();
}

class _MyNavigationBarState extends State<MyNavigationBar> {
  //Text style for the icons in the bar
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  //Handles the navigation between pages when the corresponding icon is selected.
  void _onNavigationBarTapped(int index) {
    setState(
      () {
        widget.selected_index = index;
        if (index == 0) {
          print('Home button pressed');
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      HomePage(filter: SearchFilter.empty())));
        }
        if (index == 1) {
          print('Expenditure button pressed');
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => ReportPage()));
        }
        if (index == 2) {
          print('Map button pressed');
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MerchantMapPage(search: '')));
        }
        if (index == 3) {
          print('Account button pressed');
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AccountPage()));
        }
      },
    );
  }

  //build navigation bar.
  //components are the icons for Home, Report, Map and Account, and the corresponding labels.
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.money),
          label: 'Report',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.map),
          label: 'Map',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Account',
        ),
      ],
      currentIndex: widget.selected_index,
      unselectedItemColor: Colors.grey,
      selectedItemColor: Colors.pinkAccent,
      showUnselectedLabels: true,
      onTap: _onNavigationBarTapped,
      type: BottomNavigationBarType.fixed,
    );
  }
}
