import 'package:cloud_storage_booking_api/cloud_storage_booking_api.dart';
import 'package:fixtex/features/garage_owner/garage_bookings/bloc/my_bookings_bloc.dart';
import 'package:fixtex/widgets/garage_owner_booking_card.dart';
import 'package:fixtex/widgets/no_data_quate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GarageAllTabsView extends StatefulWidget {
  const GarageAllTabsView({Key? key, required this.screen}) : super(key: key);
  final int screen;

  @override
  State<GarageAllTabsView> createState() => _AllTabScreenState();
}

class _AllTabScreenState extends State<GarageAllTabsView> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<SaloonBookingBloc>(context)
        .add(FetchAllBookingsEvent(type: widget.screen, isCustomer: true));
  }

  @override
  Widget build(BuildContext context) {
    return
        // ... (rest of your build method)
        BlocBuilder<SaloonBookingBloc, SaloonBookingState>(
      builder: (context, state) {
        if (state is AllSaloonBookingInitialState) {
          BlocProvider.of<SaloonBookingBloc>(context).add(
              FetchAllBookingsEvent(type: widget.screen, isCustomer: false));
          return const Center(
            child: Text('Fetching Bookings'),
          );
        } else if (state is AllSaloonBookingLoadingState) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is AllSaloonBookingLoadedState) {
          List<BookingService> bookingList = state.saloonBookingStream;
          List<BookingService> filteredList = [];
          if (bookingList.isNotEmpty) {
            switch (widget.screen) {
              case 1:
                for (var booking in bookingList) {
                  if (booking.bookingStart.compareTo(DateTime.now()) > 0) {
                    filteredList.add(booking);
                  }
                }

                return ListView.builder(
                  itemBuilder: (context, index) {
                    final saloonBooking = filteredList[index];
                    return GarageOwnerBookingCard(
                      bookingService: saloonBooking,
                      onSwipe: () {
                        // BlocProvider.of<saloonBookingBloc>(context)
                        //     .add(DeleteBooking(saloonBooking.bookingStart.toIso8601String()));
                      },
                    );
                  },
                  itemCount: filteredList.length,
                );

              case 2:
                for (var booking in bookingList) {
                  if (booking.bookingStart.compareTo(DateTime.now()) < 0 &&
                      booking.bookingEnd.compareTo(DateTime.now()) > 0) {
                    filteredList.add(booking);
                  }
                }

                return ListView.builder(
                  itemBuilder: (context, index) {
                    final saloonBooking = filteredList[index];
                    return GarageOwnerBookingCard(
                      bookingService: saloonBooking,
                      onSwipe: () {
                        // BlocProvider.of<saloonBookingBloc>(context)
                        //     .add(DeleteBooking(saloonBooking.bookingStart.toIso8601String()));
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
                    final saloonBooking = filteredList[index];
                    return GarageOwnerBookingCard(
                      isCompleted: true,
                      bookingService: saloonBooking,
                      onSwipe: () {
                        // BlocProvider.of<saloonBookingBloc>(context)
                        //     .add(DeleteBooking(saloonBooking.bookingStart.toIso8601String()));
                      },
                    );
                  },
                  itemCount: filteredList.length,
                );

              default:
                return ListView.builder(
                  itemBuilder: (context, index) {
                    final saloonBooking = bookingList[index];
                    return GarageOwnerBookingCard(
                      bookingService: saloonBooking,
                      onSwipe: () {
                        // BlocProvider.of<saloonBookingBloc>(context)
                        //     .add(DeleteBooking(saloonBooking.bookingStart.toIso8601String()));
                      },
                    );
                  },
                  itemCount: bookingList.length,
                );
            }
          } else {
            return const DiscoverAndBookAutoService();
          }
        } else if (state is AllSaloonBookingErrorState) {}
        return const Center(
          child: Text('Error'),
        );
      },
    );
  }
}
