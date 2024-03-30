import 'package:cloud_storage_garage_api/cloud_storage_garage_api.dart';
import 'package:fixtex/features/book_garage/booking_view/booking_view.dart';
import 'package:fixtex/features/find_garage/bloc/find_garage_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garage_repository/garage_repository.dart';

class BookingPage extends StatelessWidget {
  final Garage garage;
  final Map<String, double> selectedServices;
  const BookingPage({super.key, required this.garage, required this.selectedServices});

  @override
  Widget build(BuildContext context) {
    int totalTime = 0;
    for (double time in selectedServices.values.toList()) {
      totalTime += time.round();
    }
    return BlocProvider(
      create: (_) => FindGarageBloc(GarageRepository(garageApi: CloudGarageApi())),
      child: BookingView(garage: garage, servicesMap: selectedServices, totalTime: totalTime,),
    );
  }
}