import 'dart:developer';

import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:cloud_storage_booking_api/cloud_storage_booking_api.dart';
import 'package:fixtex/consts/colors.dart';
import 'package:fixtex/widgets/admin_booking_card.dart';
import 'package:fixtex/widgets/custom_app_bar.dart';
import 'package:fixtex/widgets/no_data_quate.dart';
import 'package:flutter/material.dart';
import 'package:garage_repository/garage_repository.dart';

class GarageBookingScreen extends StatelessWidget {
  final Garage garage;
  GarageBookingScreen({Key? key, required this.garage}) : super(key: key);
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
            Expanded(
              flex: 2,
              child: TabBarView(
                children: [
                  AdminGarageBooking(screen: 0, garageId: garage.id),
                  AdminGarageBooking(screen: 1, garageId: garage.id),
                  AdminGarageBooking(screen: 2, garageId: garage.id),
                  AdminGarageBooking(screen: 3, garageId: garage.id),
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



class AdminGarageBooking extends StatefulWidget {
  const AdminGarageBooking({Key? key, required this.screen, required this.garageId}) : super(key: key);
  final int screen;
  final String garageId;

  @override
  State<AdminGarageBooking> createState() => _AllTabScreenState();
}

class _AllTabScreenState extends State<AdminGarageBooking> {
  CloudStorageBookingApi bookingApi = CloudStorageBookingApi();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return
        // ... (rest of your build method)
        StreamBuilder(
      builder: (context, state) {
         if (state.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state.connectionState == ConnectionState.active) {
          List<BookingService> bookingList = state.data ?? <BookingService>[];
          List<BookingService> filteredList = <BookingService>[];
          if (bookingList.isNotEmpty) {
            switch (widget.screen) {
              case 1:
                for (var booking in bookingList) {
                  if (booking.bookingStart.compareTo(DateTime.now()) > 0) {
                    filteredList.add(booking);
                  }
                }

                return ListView.builder(
                  itemBuilder: (context, index) {
                    final saloonBooking = filteredList[index];
                    return AdminBookingCard(
                      bookingService: saloonBooking,
                    );
                  },
                  itemCount: filteredList.length,
                );

              case 2:
                for (var booking in bookingList) {
                  if (booking.bookingStart.compareTo(DateTime.now()) < 0 &&
                      booking.bookingEnd.compareTo(DateTime.now()) > 0) {
                    filteredList.add(booking);
                  }
                }

                return ListView.builder(
                  itemBuilder: (context, index) {
                    final saloonBooking = filteredList[index];
                    return AdminBookingCard(
                      bookingService: saloonBooking,
                    );
                  },
                  itemCount: filteredList.length,
                );

              case 3:
                for (var booking in bookingList) {
                  if (booking.bookingEnd.compareTo(DateTime.now()) < 0) {
                    filteredList.add(booking);
                  }
                }

                return ListView.builder(
                  itemBuilder: (context, index) {
                    final saloonBooking = filteredList[index];
                    return AdminBookingCard(
                      isCompleted: true,
                      bookingService: saloonBooking,
                    );
                  },
                  itemCount: filteredList.length,
                );

              default:
                return ListView.builder(
                  itemBuilder: (context, index) {
                    final saloonBooking = bookingList[index];
                    return AdminBookingCard(
                      bookingService: saloonBooking,
                    );
                  },
                  itemCount: bookingList.length,
                );
            }
          } else {
            return const DiscoverAndBookAutoService();
          }
        } else if (state.hasError) {
          return Center(
          child: Text('Error: ${state.error}'),
        );
        }
        log(state.connectionState.toString());
        return const Center(
          child: Text('Kaya'),
        );
      },
      stream: bookingApi.getBookingServicesStream(garageToLookUp: widget.garageId),
    );
  }
}
