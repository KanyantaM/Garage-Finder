import 'package:cloud_storage_booking_api/cloud_storage_booking_api.dart';
import 'package:fixtex/features/car_owner/book_garage/booking_bloc/booking_bloc.dart';
import 'package:fixtex/features/car_owner/book_garage/booking_view/bottom_sheet/show_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garage_repository/garage_repository.dart';

class ShowServicesBottomPage extends StatelessWidget {
  final Garage garage;
  const ShowServicesBottomPage({super.key, required this.garage,});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BookingBloc(CloudStorageBookingApi()),
      child: ShowServiceBottomSheetsWidget(garage: garage),
    );
  }
}