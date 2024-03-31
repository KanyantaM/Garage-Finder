import 'package:fixtex/features/garage_owner/garage_bookings/bloc/my_bookings_bloc.dart';
import 'package:fixtex/features/garage_owner/garage_bookings/view/garage_booking_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GarageBookingPage extends StatelessWidget {
  final int screen;
  const GarageBookingPage({super.key, required this.screen});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SaloonBookingBloc(),
      child: GarageAllTabsView(screen: screen,),
    );
  }
}