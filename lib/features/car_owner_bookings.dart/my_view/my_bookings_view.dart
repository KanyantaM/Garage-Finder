import 'dart:developer';

import 'package:cloud_storage_booking_api/cloud_storage_booking_api.dart';
import 'package:fixtex/features/car_owner_bookings.dart/my_bookings/my_bookings_bloc.dart';
import 'package:fixtex/widgets/car_owner_booking_card.dart';
import 'package:fixtex/widgets/no_data_quate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AllTabScreen extends StatefulWidget {
  const AllTabScreen({Key? key, required this.screen}) : super(key: key);
  final int screen;

  @override
  State<AllTabScreen> createState() => _AllTabScreenState();
}

class _AllTabScreenState extends State<AllTabScreen> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<MyBookingBloc>(context).add(FetchAllBookingsEvent(type: widget.screen, isCustomer: true));
  }

  @override
  Widget build(BuildContext context) {
    return 
        // ... (rest of your build method)
         BlocBuilder<MyBookingBloc, MyBookingState>(
      builder: (context, state) {
        log(state.toString());
        if (state is AllMyBookingInitialState) {

          BlocProvider.of<MyBookingBloc>(context).add(FetchAllBookingsEvent(type: widget.screen,  isCustomer: true));
          return const Center(
            child: Text('Fetching Bookings'),
          );
        } else if (state is AllMyBookingLoadingState) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is AllMyBookingLoadedState) {
          List<BookingService> bookingList = state.myBookingStream;
          List<BookingService> filteredList = [];
          if(bookingList.isNotEmpty) {
            switch (widget.screen) {
  case 1:
    for (var booking in bookingList) {
      if (booking.bookingStart.compareTo(DateTime.now()) > 0) {
        filteredList.add(booking);
      }
    }

    return ListView.builder(
      itemBuilder: (context, index) {
        final myBooking = filteredList[index];
        return BookingCard(
          bookingService: myBooking,
          onSwipe: () {
            // BlocProvider.of<MyBookingBloc>(context)
            //     .add(DeleteBooking(myBooking.bookingStart.toIso8601String()));
          },
        );
      },
      itemCount: filteredList.length,
    );

  case 2:
    for (var booking in bookingList) {
      if (booking.bookingStart.compareTo(DateTime.now()) < 0 && booking.bookingEnd.compareTo(DateTime.now()) > 0) {
        filteredList.add(booking);
      }
    }

    return ListView.builder(
      itemBuilder: (context, index) {
        final myBooking = filteredList[index];
        return BookingCard(
          bookingService: myBooking,
          onSwipe: () {
            // BlocProvider.of<MyBookingBloc>(context)
            //     .add(DeleteBooking(myBooking.bookingStart.toIso8601String()));
          },
        );
      },
      itemCount: filteredList.length,
    );

  case 3:
    for (var booking in bookingList) {
      if (booking.bookingEnd.compareTo(DateTime.now()) < 0) {
        filteredList.add(booking);
      }
    }

    return ListView.builder(
      itemBuilder: (context, index) {
        final myBooking = filteredList[index];
        return BookingCard(
          bookingService: myBooking,
          onSwipe: () {
            // BlocProvider.of<MyBookingBloc>(context)
            //     .add(DeleteBooking(myBooking.bookingStart.toIso8601String()));
          },
        );
      },
      itemCount: filteredList.length,
    );

  default:
    return ListView.builder(
      itemBuilder: (context, index) {
        final myBooking = bookingList[index];
        return BookingCard(
          bookingService: myBooking,
          onSwipe: () {
            // BlocProvider.of<MyBookingBloc>(context)
            //     .add(DeleteBooking(myBooking.bookingStart.toIso8601String()));
          },
        );
      },
      itemCount: bookingList.length,
    );
}}else{
            return const DiscoverAndBookAutoService();
          }
          } else if (state is AllMyBookingErrorState) {
          log(state.message);
        }
        return const Center(
          child: Text( 'Error'),
        );
      },
    );
  
      }
  }

