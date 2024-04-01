import 'package:cloud_storage_booking_api/cloud_storage_booking_api.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fixtex/consts/colors.dart';
import 'package:fixtex/features/car_owner/book_garage/booking_bloc/booking_bloc.dart';
import 'package:fixtex/features/car_owner/book_garage/booking_cubit/booking_cubit.dart';
import 'package:fixtex/helper.dart';
import 'package:fixtex/screens/car_owner/car_bottom_nav.dart.dart';
import 'package:fixtex/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garage_repository/garage_repository.dart';

class BookingView extends StatefulWidget {
  final Garage garage;
  // final double totalCost;
  final Map<String, double> servicesMap;
  final int totalTime;
  const BookingView({
    super.key,
    required this.garage,
    required this.servicesMap,
    // required this.totalCost,
    required this.totalTime,
  });

  @override
  State<BookingView> createState() => _BookingServiceScreenState();
}

class _BookingServiceScreenState extends State<BookingView> {
  final User? _currentUser = FirebaseAuth.instance.currentUser;
  Map<int, List<TimeOfDay>> _saloonSchedule = {};
  DateTime now = DateTime.now();
  List<DateTime> _disabledDays = [];
  List<DateTimeRange> _nonWorkPeriods = [];
  late ScheduleManipulator _scheduleManipulator;

  

  void _getNonWorkPeriods() async {
    _saloonSchedule = await _scheduleManipulator.fetchWorkingDaysAndHours();
    _nonWorkPeriods = _scheduleManipulator.generatePauseSlots(_saloonSchedule);
  }

  @override
  void initState() {
    super.initState();
    // hasBookedCubit.notYetBooked();
    _scheduleManipulator = ScheduleManipulator(garageId: widget.garage.id);
    _getNonWorkPeriods();
    getDisabledDays();
  }

  void getDisabledDays() async {
    _disabledDays = await _scheduleManipulator.fetchDisabledDates();
  }

   @override
  Widget build(BuildContext context) {
    final bookingBloc = BlocProvider.of<BookingBloc>(context);
    return WillPopScope(
      onWillPop: () async {
        bool shouldPop = await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Are you sure?"),
              content:
                  const Text("Leaving now will cancel your booking progress."),
              actions: [
                TextButton(
                  onPressed: () {
                    // Handle cancel action
                    Navigator.pop(context, false);
                  },
                  child: const Text("Cancel"),
                ),
                TextButton(
                  onPressed: () {
                    // Handle leave action
                    Navigator.pop(context, true);
                    // Additional logic for leaving
                  },
                  child: const Text("Leave"),
                ),
              ],
            );
          },
        );

        return shouldPop;
      },
      child: Scaffold(
        appBar: customAppBar('Select Booking Time'),
        body: BlocBuilder<BookingBloc, BookingState>(
          builder: (context, state) {
            if (state is BookingInitial) {
              //add the event taht will fetch the bookings
              bookingBloc.add(FetchBookings(garage: widget.garage));
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is BookingLoaded) {
              BookingService bookingService = BookingService(
                userName: _currentUser?.displayName ?? '',
                userEmail: _currentUser?.email,
                userPhoneNumber: _currentUser!.phoneNumber,
                userId: _currentUser!.uid,
                // servicePrice: widget.totalCost,
                bookingEnd: DateTime(now.year, now.month, now.day, 18),
                bookingStart: DateTime(now.year, now.month, now.day, 08),
                serviceName: formatMap(widget.servicesMap),
                servicProvider: widget.garage.name,
                serviceProviderId: widget.garage.id,
                serviceDuration: widget.totalTime,
                // serviceProviderIdList: widget.garage.serviceProviderList,
              );

              return BlocBuilder(
                  bloc: hasBookedCubit,
                  builder: (context, cubit) {
                    return Column(
                      children: [
                        Expanded(
                          child: (!hasBookedCubit.state)
                              ? BookingCalendar(
                                  lastDay: DateTime.now()
                                      .add(const Duration(days: 28)),
                                  uploadingWidget: const ImpressiveUploadWidget(),
                                  bookingService: bookingService,
                                  getBookingStream: state.getBookingStream,
                                  uploadBooking: state.uploadBooking,
                                  convertStreamResultToDateTimeRanges:
                                      state.convertStreamResultToDateTimeRanges,
                                  pauseSlots: _nonWorkPeriods,
                                  pauseSlotText: 'off',
                                  bookedSlotText: 'Booked',
                                  // pauseSlotColor:  ,
                                  wholeDayIsBookedWidget: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        "assets/time-check.png",
                                        height: 177,
                                        color: Colors.blueGrey,
                                      ),
                                      const SizedBox(
                                        height: 30,
                                      ),
                                      Text(                                        
                                            'Sorry, we are unable to attend to your\n ${widget.totalTime} min service on this day.',
                                        style: const TextStyle(fontSize: 20,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,),
                                        
                                      ),
                                    ],
                                  ),
                                  loadingWidget: const Center(
                                    child: LinearProgressIndicator(),
                                  ),
                                  bookingButtonColor: kmainBlue,
                                  selectedSlotColor: Colors.green,
                                  bookedSlotColor: kmainBlue,
                                  disabledDates: _disabledDays,
                                  day: now,
                                  onDayChanged: (selectedDate) {
                                    setState(() {
                                      now = selectedDate;
                                      // print(now.weekday);
                                    });
                                  },
                                )
                              : AlertDialog(
                                  title: const Text('Booking Registered'),
                                  content: const Text(
                                      'Would you like to make another appointment'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Helper.toRemoveUntiScreen(
                                          context,
                                          const BottomNav(
                                          ),
                                        );
                                      },
                                      child: const Text('No'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        setState(() {
                                          hasBookedCubit.notYetBooked();
                                        });

                                      },
                                      child: const Text('Yes'),
                                    ),
                                  ],
                                ),
                        ),
                      ],
                    );
                  });
            }
            return Container();
          },
        ),
      ),
    );
  }
}

String formatMap(Map<String, double> services) {
  String formatted = '';
  services.forEach((item, price) {
    formatted += '$item at K${price.toStringAsFixed(2)}\n';
  });
  return formatted;
}

class ImpressiveUploadWidget extends StatefulWidget {
  const ImpressiveUploadWidget({super.key});

  @override
  State<ImpressiveUploadWidget> createState() => _ImpressiveUploadWidgetState();
}

class _ImpressiveUploadWidgetState extends State<ImpressiveUploadWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _controller.repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey,
      child: Center(
        child: ScaleTransition(
          scale: _animation,
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Uploading...",
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16.0),
                CircularProgressIndicator(
                  strokeWidth: 5.0,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
