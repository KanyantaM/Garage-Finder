import 'package:cloud_storage_garage_api/cloud_storage_garage_api.dart';
import 'package:fixtex/features/garage_owner/booking_settings/view/booking_settings_view.dart';
import 'package:fixtex/features/garage_owner/edit_garage/create_garage_bloc/edit_garage_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garage_repository/garage_repository.dart';

class BookingSettingsPage extends StatelessWidget {
  final Garage garage;
  const BookingSettingsPage({super.key, required this.garage});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => EditGarageBloc(GarageRepository(garageApi: CloudGarageApi())),
      child: const BookingSettingsView(),
    );
  }
}