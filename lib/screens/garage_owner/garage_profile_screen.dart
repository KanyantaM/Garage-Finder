import 'package:fixtex/features/garage_owner/edit_garage/edit_garage_view/edit_garage_page.dart';
import 'package:fixtex/widgets/custom_app_bar.dart';
import 'package:fixtex/widgets/rectangle_button.dart';
import 'package:flutter/material.dart';
import 'package:garage_repository/garage_repository.dart';
import 'package:user_api_firebase/user_api_firebase_auth.dart';

import '../../features/authentication/auth/auth_page.dart';

class GarageProfileScreen extends StatelessWidget {
  final Garage garage;
  const GarageProfileScreen({super.key, required this.garage});

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
                 Text(
                  garage.name,
                  style:const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16.0),
                Row(
                  children: [
                    const Icon(Icons.account_circle, size: 40.0),
                    const SizedBox(width: 16.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          garage.name,
                          style: const TextStyle(fontSize: 16.0),
                        ),
                        Text(
                          garage.address,
                          style: const TextStyle(
                              fontSize: 14.0, color: Colors.grey),
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EditGaragePage(
                                garage: garage,
                              )),
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
                  title: Text('Contact Us'),
                  trailing: Icon(Icons.chevron_right),
                ),
                const Divider(thickness: 1.0),
              ],
            ),
            const SizedBox(height: 16.0),
            RectangleMain(
              type: 'Log out',
              onTap: () {
                UserApiFirebase().signOut();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const AuthPage()),
                  (route) =>
                      false, // This will remove all routes from the stack
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
