import 'package:fixtex/features/car_owner/find_garage/find_baber.dart';
import 'package:fixtex/features/chat/rooms.dart';
import 'package:fixtex/screens/car_owner/account_details_screen.dart';
import 'package:fixtex/screens/car_owner/car_booking_screen.dart';
import 'package:fixtex/widgets/custom_app_bar.dart';
import 'package:fixtex/widgets/messages.dart';
import 'package:fixtex/widgets/rectangle_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:user_api_firebase/user_api_firebase_auth.dart';
import 'package:user_repository/user_repository.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<BottomNav> {
  int _currentIndex = 0;
  final UserRepository _userRepository = UserRepository(userApi: UserApiFirebase());
  List<Widget> _screens = [];

  @override
  void initState() {
    super.initState();
    _initializeScreens();
  }

  void _initializeScreens() async {
    Owner owner = _userRepository.fetchOwnerCred()!;
    setState(() {
      _screens = [
        const HomePage(),
        MyBookingScreen(),
        const RoomsPage(isGarage: false,),
        UserProfileScreen(owner: owner),
      ];
    });
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
  final Owner owner;
  const UserProfileScreen({super.key, required this.owner});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar('Profile'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.account_circle, size: 40.0),
                    const SizedBox(width: 16.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          owner.name,
                          style: const TextStyle(fontSize: 16.0),
                        ),
                        Text(
                          owner.email,
                          style: const TextStyle(fontSize: 14.0, color: Colors.grey),
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
                  title: Text('Settings'),
                  trailing: Icon(Icons.chevron_right),
                ),
                const Divider(thickness: 1.0),
                const ListTile(
                  title: Text('Contact'),
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
