import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:fixtex/consts/colors.dart';
import 'package:fixtex/features/garage_owner/garage_bookings/view/view.dart';
import 'package:fixtex/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';

class GarageBookingScreen extends StatelessWidget {
  GarageBookingScreen({Key? key}) : super(key: key);
  final List<String> tabs = ['All', 'Awaiting', 'Started', 'Done',];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar('Bookings'),
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
                  color: Colors.blueGrey,
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
                  GarageBookingPage(screen: 0,),
                  GarageBookingPage(screen: 1,),
                  GarageBookingPage(screen: 2,),
                  GarageBookingPage(screen: 3,),
                ],
                // children: ...,
              ),
            ),
            // const SizedBox(height: 72,)
          ],
        ),
      ),
    );
  }
}
