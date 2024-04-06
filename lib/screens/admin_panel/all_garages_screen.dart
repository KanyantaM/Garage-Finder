import 'package:cloud_storage_garage_api/cloud_storage_garage_api.dart';
import 'package:fixtex/screens/admin_panel/garage_detail_bottom_sheet.dart';
import 'package:fixtex/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:garage_repository/garage_repository.dart';

class GarageDetailsScreen extends StatelessWidget {
  final GarageRepository _garageRepository = GarageRepository(garageApi: CloudGarageApi());
  GarageDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar('Garage'),
      body: StreamBuilder<List<Garage>>(
        stream: _garageRepository.getGarages(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final List<Garage> garages = snapshot.data ?? <Garage>[];
          return ListView.builder(
            itemCount: garages.length,
            itemBuilder: (context, index) {
              Garage garage = garages[index];
              return InkWell(
                onTap: () async{
                  onGaragePressed(context, garage,);
                },
                child: ListTile(
                  title: Text(garage.name),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Contact: ${garage.phone}'),
                      Text('Rating: ${garage.rating}'),
                      Wrap(children: [
                        for(String service in garage.services.keys)
                        Chip(label: Center(child: Text(service)))
                      ],)
                      // You can add more fields here as required
                    ],
                  ),
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(garage.imageUrl),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}