import 'package:fixtex/features/garage_owner/booking_settings/view/booking_settings_page.dart';
import 'package:fixtex/screens/account_details_screen.dart';
import 'package:fixtex/screens/garage_owner/garage_booking_screen.dart';
import 'package:fixtex/widgets/messages.dart';
import 'package:fixtex/widgets/rectangle_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:garage_repository/garage_repository.dart';

class GarageBottomNav extends StatefulWidget {
  final Garage garage;
  const GarageBottomNav({super.key, required this.garage});

  @override
  State<GarageBottomNav> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<GarageBottomNav> {
  int _currentIndex = 0;

  late List<Widget> _screens;

  @override
  void initState() {
    _screens = [
    
    GarageBookingScreen(
    ),
    BookingSettingsPage(garage: widget.garage),
    const ChatScreen(),
    const UserProfileScreen(),
  ];
    super.initState();
  }

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
            icon: Icon(CupertinoIcons.clock),
            label: 'Appointments',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.calendar),
            label: 'Schedule',
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
            RectangleMain(type: 'Log out', onTap: () {  },)
          ],
        ),
      ),
    );
  }
}