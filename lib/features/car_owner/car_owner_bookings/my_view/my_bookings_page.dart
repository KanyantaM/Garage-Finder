import 'package:fixtex/features/car_owner/car_owner_bookings/my_bookings/my_bookings_bloc.dart';
import 'package:fixtex/features/car_owner/car_owner_bookings/my_view/my_bookings_tab.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AllTabsPage extends StatelessWidget {
  final int screen;
  const AllTabsPage({super.key, required this.screen});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MyBookingBloc(),
      child: AllTabScreen(screen: screen,),
    );
  }
}