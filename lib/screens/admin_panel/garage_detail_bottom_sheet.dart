import 'package:fixtex/features/chat/chat.dart';
import 'package:fixtex/screens/admin_panel/view_garage_bookings.dart';
import 'package:fixtex/utilities/getting_room.dart';
import 'package:fixtex/widgets/rectangle_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:garage_repository/garage_repository.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void onGaragePressed(
  BuildContext context,
  Garage garage,
) {
  showModalBottomSheet(
    // backgroundColor: kMainColor,
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(25),
        topRight: Radius.circular(25),
      ),
    ),
    builder: (BuildContext _) {
      return FutureBuilder<Room>(
        future: settingUpRoom(garage.id),
        builder: (context, snapshot) {
          // if (snapshot.connectionState == ConnectionState.waiting) {
          //   return const Center(
          //     child: CircularProgressIndicator(),
          //   );
          // } else
           if (snapshot.connectionState == ConnectionState.done || snapshot.connectionState == ConnectionState.waiting) {
            if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            }
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                // height: 400,
                margin: const EdgeInsets.only(top: 10),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                  // color: kMainColor,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Column(
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              foregroundImage: (garage.imageUrl.isNotEmpty)
                                  ? NetworkImage(garage.imageUrl)
                                  : null,
                              child: (garage.imageUrl.isNotEmpty)
                                  ? const Icon(Icons.account_circle, size: 40.0)
                                  : null,
                            ),
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
                        SizedBox(
                          height: 200,
                          child: GoogleMap(
                            initialCameraPosition: CameraPosition(
                              target: LatLng(garage.lat, garage.lng),
                              zoom: 17.5,
                            ),
                            onMapCreated: (GoogleMapController controller) {},
                            markers: {
                              Marker(
                                markerId: MarkerId(garage.address),
                                position: LatLng(garage.lat, garage.lng),
                                infoWindow: InfoWindow(title: garage.name),
                              ),
                            },
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        const Divider(thickness: 1.0),
                        const Text('Bio'),
                        Text(garage.bio),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        RectangleTopRight(
                            text: 'Chat',
                            onTap: (){
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => ChatPage(
                                    room: snapshot.data!,
                                  ),
                                ),
                              );
                            }),
                        RectangleTopRight(
                            text: 'Activity',
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => GarageBookingScreen(
                                    garage: garage,
                                  ),
                                ),
                              );
                            }),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }

          return const Center(
            child: Text('Something Went Wrong'),
          );
        },
      );
    },
    isScrollControlled: true,
  );
}
