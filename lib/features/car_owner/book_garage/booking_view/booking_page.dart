import 'package:cloud_storage_booking_api/cloud_storage_booking_api.dart';
import 'package:fixtex/features/car_owner/book_garage/booking_bloc/booking_bloc.dart';
import 'package:fixtex/features/car_owner/book_garage/booking_view/booking_view.dart';
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
      create: (_) => BookingBloc(CloudStorageBookingApi()),
      child: BookingView(garage: garage, servicesMap: selectedServices, totalTime: totalTime,),
    );
  }
}