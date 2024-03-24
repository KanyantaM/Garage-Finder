import 'package:fixtex/features/find_garage/view/find_garage_page.dart';
import 'package:fixtex/screens/account_details_screen.dart';
import 'package:fixtex/widgets/booking_item.dart';
import 'package:fixtex/widgets/custom_calender.dart';
import 'package:fixtex/widgets/custom_titles.dart';
import 'package:fixtex/widgets/messages.dart';
import 'package:fixtex/widgets/no_data_quate.dart';
import 'package:fixtex/widgets/rectangle_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<BottomNav> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomePage(),
    const AppointmentScreen(
      isEmpty: true,
    ),
    const ChatScreen(),
    const UserProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: CupertinoTabBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.calendar),
            label: 'Appointments',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.chat_bubble),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

// class HomeScreen extends StatelessWidget {
//   const HomeScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: [
//           // Search Bar
//           const CustomSearchBar(),
//           const SizedBox(
//             height: 20,
//           ),
//           // Google Map
//           // Google Map
//           Expanded(
//               child: Container(
//                   // Replace this Container with Google Maps widget
//                   color: Colors.grey[300],
//                   child: const Center(
//                     child: Text('Google Map'),
//                   ))
//               // GoogleMap(
//               //   initialCameraPosition: CameraPosition(
//               //     target: LatLng(37.7749, -122.4194), // San Francisco coordinates
//               //     zoom: 12,
//               //   ),
//               //   onMapCreated: (GoogleMapController controller) {
//               //     setState(() {
//               //       mapController = controller;
//               //     });
//               //   },
//               //   markers: {
//               //     // You can add markers for auto shops here
//               //     Marker(
//               //       markerId: MarkerId('1'),
//               //       position: LatLng(37.7749, -122.4194), // San Francisco coordinates
//               //       infoWindow: InfoWindow(title: 'Auto Shop 1'),
//               //     ),
//               //   },
//               // ),
//               ),
//           // Scrollable List of Auto Shops
//           Expanded(
//             child: ListView.builder(
//               itemCount: 10, // Example count, replace with actual data
//               itemBuilder: (context, index) {
//                 return Column(
//                   children: [
//                     AutoServiceTile(
//                       name: 'Auto Shop $index',
//                       address: 'Address of Auto Shop $index',
//                       imagePath:
//                           'assets/images/dummy.png', // Replace with actual image path
//                       rating: 4.5, // Replace with actual rating
//                     ),
//                     const Divider(),
//                   ],
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

class AppointmentScreen extends StatelessWidget {
  final bool isEmpty;
  const AppointmentScreen({super.key, required this.isEmpty});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isEmpty
          ? Column(
              children: [
                const Center(child: CustomCalendar()),
                CustomTitles(),
                Expanded(
                  child: ListView.builder(
                    itemCount: 10, // Example count, replace with actual data
                    itemBuilder: (context, index) {
                      return const BookingData();
                    },
                  ),
                ),
              ],
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Center(
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/images/empty_calender.png', // Replace with your image path
                        width: 200,
                        height: 200,
                      ),
                      const SizedBox(height: 20),
                      const DiscoverAndBookAutoService(),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                const RectangleMain(type: 'Search Now'),
              ],
            ),
    );
  }
}

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: 1,
        itemBuilder: (context, index) {
          return BookingCard(
            garageName: "Auto Car Centre",
            sentTime: DateTime.now().subtract(const Duration(days: 0)),
            confirmationText: "Confirmed booking 12:00pm",
            isRecieved: true,
            isReade: true,
          );
        },
      ),
    );
  }
}

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Profile',
                  style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16.0),
                const Row(
                  children: [
                    Icon(Icons.account_circle, size: 40.0),
                    SizedBox(width: 16.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'User Name',
                          style: TextStyle(fontSize: 16.0),
                        ),
                        Text(
                          'user.name@email.com',
                          style: TextStyle(fontSize: 14.0, color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                const Divider(thickness: 1.0),
                const SizedBox(height: 16.0),
                InkWell(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const AccountingDetailsScreen(isSignUp: false)),
                    );
                  },
                  child: const ListTile(
                    title: Text('Account details'),
                    trailing: Icon(Icons.chevron_right),
                  ),
                ),
                const Divider(thickness: 1.0),
                const ListTile(
                  title: Text('Address'),
                  trailing: Icon(Icons.chevron_right),
                ),
                const Divider(thickness: 1.0),
                const ListTile(
                  title: Text('Settings'),
                  trailing: Icon(Icons.chevron_right),
                ),
                const Divider(thickness: 1.0),
              ],
            ),
            const SizedBox(height: 16.0),
            const RectangleMain(type: 'Log out')
          ],
        ),
      ),
    );
  }
}
