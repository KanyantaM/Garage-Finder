import 'package:cloud_storage_booking_api/cloud_storage_booking_api.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fixtex/features/car_owner/book_garage/booking_bloc/booking_bloc.dart';
import 'package:fixtex/features/car_owner/book_garage/booking_view/booking_page.dart';
import 'package:fixtex/helper/helper.dart';
import 'package:fixtex/widgets/rectangle_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garage_repository/garage_repository.dart';

class ShowServiceBottomSheetsWidget extends StatefulWidget {
  final Garage garage;

  const ShowServiceBottomSheetsWidget(
      {super.key, required this.garage,});

  @override
  State<ShowServiceBottomSheetsWidget> createState() =>
      _ShowServiceBottomSheetsWidgetState();
}

class _ShowServiceBottomSheetsWidgetState
    extends State<ShowServiceBottomSheetsWidget> {
  double _totalCost = 0;
  Map<String, double> _selectedServices = {};
  User currentUser = FirebaseAuth.instance.currentUser!;
  int _totalTime = 0;
  Map<String, int> _totalCustomersForService = {};
  // bool _checked = false;
  Map<String, bool> selectedServicesstate = {};

  void _initializeCustomersList() {
    for (var service in widget.garage.services.keys) {
      _totalCustomersForService[service] = 0;
      selectedServicesstate[service] = false;
    }
  }

  @override
  void initState() {
    super.initState();
    _totalCustomersForService = {};
    _initializeCustomersList();
    _totalCost = 0;
    _selectedServices = {};
    currentUser = FirebaseAuth.instance.currentUser!;
    BlocProvider(create: ((context) => BookingBloc(CloudStorageBookingApi())));
  }

  @override
  void dispose() {
    _totalCost;
    _selectedServices;
    _totalCustomersForService;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BookingBloc, BookingState>(
      builder: (context, state) {
        if (state is BookingInitial) {
          return ListView(
            shrinkWrap: true,
            children: [
              const SizedBox(
                height: 10,
              ),
              ListTile(
                leading: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(Icons.arrow_back)),
                title: Center(
                  child: Container(
                    margin: const EdgeInsets.only(right: 40),
                    child: Text(
                      
                          "Select Services\nEstimated Time: ${_totalCost.toStringAsFixed(2)}",
                          style: const TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,),
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Column(
                      children: [
                        for (var entry in widget.garage.services.entries)
                          Column(
                            children: [
                              ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      leading: Checkbox(
                                        checkColor: Colors.green,
                                        value: _selectedServices
                                            .containsKey(entry.key),
                                        onChanged: (value) {
                                          setState(() {
                                            if (value!) {
                                              _totalTime += 
                                                  entry.value.round();
                                                _selectedServices[entry.key] = entry.value;
                                            } else {
                                              _totalTime -= 
                                                  entry.value.round();
                                              _selectedServices.removeWhere((key, value) => key == entry.key);
                                            }
                                          });
                                        },
                                      ),
                                      title: Text(
                                          entry.key),
                                      trailing: Text(
                                        'Duration: ${entry.value.toStringAsFixed(2)} min',
                                        textAlign: TextAlign.end,
                                      ),
                                    ),
                              const Divider(
                                thickness: 0.5,
                              ),
                            ],
                          ),
                      ],
                    ),
                    RectangleMain(type: 'Book Now', onTap: () { BlocProvider.of<BookingBloc>(context)
                            .add(AddServices(_selectedServices, widget.garage)); },),
                    
                  ],
                ),
              )
            ],
          );
        } else if (state is VerficationServicesError) {
          return AlertDialog(
            title: const Text('Failed to book Services'),
            content: Text(state.errorMessage),
            actions: [
              RectangleTopRight(text: 'OK', onTap: () {
                  BlocProvider.of<BookingBloc>(context).add(BookingCancelled());
                  Navigator.of(context).pop();
                },)
            ],
          );
        } else if (state is VerifiedSelectedServices) {
          int numberOfServices = _selectedServices.length;
          return AlertDialog(
            title: numberOfServices != 1
                ? Text(
                    'You have successfully selected $numberOfServices services')
                : Text(
                    'You have successfully selected $numberOfServices service'),
            content:
                Text('Your approximate duration: $_totalTime mins'),
            actions: [
              RectangleTopRight(text: 'Cancel', onTap: () {
                  _selectedServices = {};
                  BlocProvider.of<BookingBloc>(context).add(BookingCancelled());
                  Navigator.of(context).pop();
                },
                color: Colors.blueGrey,),
              const SizedBox(
                height: 10,
              ),
              RectangleTopRight(text: 'Book', onTap: () {
                  BlocProvider.of<BookingBloc>(context).add(
                      FowardFinalServices(_selectedServices, widget.garage));
                  Helper.toReplacementScreenLeft(
                      context,
                      BookingPage(
                          garage: widget.garage,
                          selectedServices: _selectedServices,
                          // totalCost: _totalCost,
                          // totalTime: _totalTime
                          ));
                }),
              
            ],
          );
        } else if (state is BookingLoaded) {
          BlocProvider.of<BookingBloc>(context).add(ResetBookings());
          return const Center(
            child: Text(
              'Loading....',
            ),
          );
        }
        return const Center(child: Text('Error'));
      },
      listener: (context, state) {},
    );
  }
}

