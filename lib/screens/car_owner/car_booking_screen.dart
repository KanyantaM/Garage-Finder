import 'package:fixtex/features/car_owner/car_owner_bookings/car_owner_bookings.dart';

import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:fixtex/consts/colors.dart';
import 'package:flutter/material.dart';

class MyBookingScreen extends StatelessWidget {
  MyBookingScreen({Key? key}) : super(key: key);
  final List<String> tabs = ['All', 'Awaiting', 'Started', 'Completed'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: const Text(
          "My Bookings",
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black),
        ),
        elevation: 2,
        centerTitle: true,
      ),
      body: DefaultTabController(
        length: 4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(
              height: 20,
            ),
            Container(
              margin: const EdgeInsets.only(left: 15),
              child: ButtonsTabBar(
                // Customize the appearance and behavior of the tab bar
                backgroundColor: kmainBlue,
                // borderWidth: 2,
                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                unselectedBackgroundColor: Colors.white,
                // borderColor: Colors.black,
                labelStyle: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                unselectedLabelStyle: const TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
                // Add your tabs here
                tabs: [
                  Tab(
                    text: tabs[0],
                  ),
                  Tab(
                    text: tabs[1],
                  ),
                  Tab(
                    text: tabs[2],
                  ),
                  Tab(
                    text: tabs[3],
                  ),
                ],
              ),
            ),
            const Expanded(
              flex: 2,
              child: TabBarView(
                children: [
                  AllTabsPage(
                    screen: 0,
                  ),
                  AllTabsPage(
                    screen: 1,
                  ),
                  AllTabsPage(
                    screen: 2,
                  ),
                  AllTabsPage(
                    screen: 3,
                  ),
                ],
                // children: ...,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
