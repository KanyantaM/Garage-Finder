import 'package:fixtex/widgets/booking_item.dart';
import 'package:fixtex/widgets/custom_calender.dart';
import 'package:fixtex/widgets/custom_searchbar.dart';
import 'package:fixtex/widgets/custom_titles.dart';
import 'package:fixtex/widgets/no_data_quate.dart';
import 'package:fixtex/widgets/rectangle_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const AppointmentScreen(isEmpty: true,),
    const ChatScreen(),
    const UserProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: const Text('Bottom Navigation Demo'),
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: CupertinoTabBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          const BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.home),
            label: 'Home',
          ),
          const BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.calendar),
            label: 'Appointments',
          ),
          const BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.chat_bubble),
            label: 'Chat',
          ),
          const BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Search Bar
          const CustomSearchBar(),
          const SizedBox(height: 20,),
          // Google Map
          // Google Map
          Expanded(
            child: Container(
              // Replace this Container with Google Maps widget
              color: Colors.grey[300],
              child: const Center(
                child: Text('Google Map'),
))
            // GoogleMap(
            //   initialCameraPosition: CameraPosition(
            //     target: LatLng(37.7749, -122.4194), // San Francisco coordinates
            //     zoom: 12,
            //   ),
            //   onMapCreated: (GoogleMapController controller) {
            //     setState(() {
            //       mapController = controller;
            //     });
            //   },
            //   markers: {
            //     // You can add markers for auto shops here
            //     Marker(
            //       markerId: MarkerId('1'),
            //       position: LatLng(37.7749, -122.4194), // San Francisco coordinates
            //       infoWindow: InfoWindow(title: 'Auto Shop 1'),
            //     ),
            //   },
            // ),
          ),
          // Scrollable List of Auto Shops
          Expanded(
            child: ListView.builder(
              itemCount: 10, // Example count, replace with actual data
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('Auto Shop $index'),
                  subtitle: Text('Address of Auto Shop $index'),
                  onTap: () {
                    // Handle tapping on auto shop
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class AppointmentScreen extends StatelessWidget {
  final bool isEmpty;
  const AppointmentScreen({super.key, required this.isEmpty});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isEmpty? Column(
        children: [
          const Center(child: CustomCalendar()),
           CustomTitles(),
           Expanded(
            child: ListView.builder(
              itemCount: 10, // Example count, replace with actual data
              itemBuilder: (context, index) {
                return BookingData();
              },
            ),
          ),
        ],
      ) : Column(
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
    return const Center(
      child: Text('Chat Screen'),
    );
  }
}

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('User Profile Screen'),
    );
  }
}
