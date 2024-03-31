import 'package:fixtex/features/garage_owner/booking_settings/view/booking_settings_page.dart';
import 'package:fixtex/screens/garage_owner/garage_booking_screen.dart';
import 'package:fixtex/screens/garage_owner/garage_profile_screen.dart';
import 'package:fixtex/widgets/messages.dart';
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
    GarageProfileScreen(garage: widget.garage),
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

