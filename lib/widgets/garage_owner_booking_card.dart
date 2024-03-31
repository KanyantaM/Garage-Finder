import 'package:cloud_storage_booking_api/cloud_storage_booking_api.dart';
import 'package:fixtex/consts/colors.dart';
import 'package:fixtex/features/garage_owner/garage_bookings/bloc/my_bookings_bloc.dart';
import 'package:fixtex/widgets/custome_text_field.dart';
import 'package:fixtex/widgets/rectangle_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class GarageOwnerBookingCard extends StatefulWidget {
  final BookingService bookingService;
  final void Function()? onSwipe;
  final bool? isCompleted;

  const GarageOwnerBookingCard({
    Key? key,
    required this.bookingService,
    required this.onSwipe,
    this.isCompleted,
  }) : super(key: key);

  @override
  State<GarageOwnerBookingCard> createState() => _BookingCardState();
}

class _BookingCardState extends State<GarageOwnerBookingCard>{
  bool _isCompleted = false;
  bool _isConfirmed = false;
    @override
    void initState() {
    super.initState();
    _isConfirmed = widget.bookingService.confirmed ?? false;
    _isCompleted = widget.isCompleted ?? false;
  }


  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key('${widget.bookingService.serviceId}'),
      background: Container(
        color: Colors.grey[700],
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: const Icon(Icons.delete_forever, size: 10,),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss:!_isCompleted? (direction) async {
        return await showDialog(
          context: context,
          builder: ((context) {
            return deleteBookingDialogue(context);
          }),
        );
      }:(direction) {
        return showDialog(context: context, builder: (context){
          return const AlertDialog(title: Text('You can\'t delete a confirmed bookings'),);
        });
      },
      onDismissed: !_isCompleted
          ? (direction) {
              widget.onSwipe?.call();
            }
          : (direction) {},
      child: Card(
        color: _isConfirmed ? Colors.green[200] : Colors.blue[200],
        elevation: 4,
        margin: const EdgeInsets.all(10),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Wrap(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      serviceDetailDialogue(context);
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                           'Time: ${widget.bookingService.bookingStart}',
                         style:const TextStyle(fontWeight: FontWeight.w600,
                          color: Colors.white,)
                        ),
                        Text(
                           'Service: ${widget.bookingService.serviceName}',
                           style: const TextStyle(fontWeight: FontWeight.w400,
                          color: Colors.white,),
                          
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  const Divider(
                    color: Colors.white,
                  ),
                  _isConfirmed
                      ? IconButton(
                          onPressed: () {
                            // showDialog(
                            //   context: context,
                            //   builder: (BuildContext context) {
                            //     return confirmedBookingDialogue(context);
                            //   },
                            // );
                          },
                          icon: const Icon(
                            Icons.cancel,
                          ),
                        )
                      : _isCompleted
                          ? IconButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return confirmedBookingDialogue(context);
                                  },
                                );
                              },
                              icon: const Icon(
                                Icons.check,
                              ))
                          : IconButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return deleteBookingDialogue(context);
                                  },
                                );
                              },
                              icon: const Icon(
                                Icons.delete_forever,
                                color: Colors.white,
                                size: 24,
                              ))
                ],
              ),
              _isConfirmed
                  ? RatingBarIndicator(
                      rating: widget.bookingService.rating?.toDouble() ?? 0.0,
                      itemBuilder: (context, index) => const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      itemCount: 5,
                    )
                  : const Wrap(),
            ],
          ),
        ),
      ),
    );
  }

  Future<dynamic> serviceDetailDialogue(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title:
           Text(
            'Booking Details\n'
            'Service: ${widget.bookingService.serviceName}\n'
            // 'Price: $widget.{bookingService.servicePrice}\n'
            'Duration: ${widget.bookingService.serviceDuration} minutes',
          ),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                  'Time: ${widget.bookingService.bookingStart} - ${widget.bookingService.bookingEnd}'),
            ],
          ),
          actions: [
            RectangleTopRight(text: 'OK', onTap: () {
                Navigator.of(context).pop();
              },),
            const SizedBox(
              height: 5,
            ),
            RectangleTopRight(text: 'Delete', onTap: () async {
                Navigator.of(context).pop();
                deleteBookingDialogue(context);
              },
              color: Colors.red,),
          ],
        );
      },
    );
  }

  AlertDialog deleteBookingDialogue(BuildContext context) {
    TextEditingController reasonController = TextEditingController();

    return AlertDialog(title:
       const Icon(Icons.delete_forever_outlined),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Are you sure you want to cancel this booking?'),
          const SizedBox(height: 10),
          TextField(
            controller: reasonController,
            decoration: const InputDecoration(labelText: 'Cancellation Reason'),
          ),
        ],
      ),
      actions: [
        RectangleTopRight(text: 'No', onTap: () {
            Navigator.of(context).pop(false);
          }, color: Colors.grey[400],),
        RectangleTopRight(
           text:'Yes',
          color: kmainBlue,
          onTap: () {
            Navigator.of(context).pop(true);

            // Pass the cancellation reason to the DeleteBooking event
            String cancellationReason = reasonController.text;
            BlocProvider.of<SaloonBookingBloc>(context).add(
                DeleteBooking(widget.bookingService.bookingStart, cancellationReason, widget.bookingService.serviceProviderId! ,widget.bookingService.userId! ));
          },
        ),
      ],
    );
  }

  AlertDialog confirmedBookingDialogue(BuildContext context) {
    TextEditingController confirmedBookingController = TextEditingController();
    confirmedBookingController.text =
        widget.bookingService.servicePrice!.toStringAsFixed(2);

    return AlertDialog(
      title:
       const Icon(Icons.delete_forever_outlined),
      content: Wrap(
        crossAxisAlignment: WrapCrossAlignment.start,
        children: [
          const Text(
              'You have marked the booking as complete.\nEnter the total charged to the customer?'),
          const SizedBox(height: 10),
          CustomTextField(
            controller: confirmedBookingController,
            hintText: '200.00',
          ),
        ],
      ),
      actions: [
        RectangleTopRight(
           text:'Cancel',
          color: Colors.grey[400],
          onTap: () {
            Navigator.of(context).pop(false);
          },
        ),
        RectangleTopRight(
           text:'Confirm',
          color: kmainBlue,
          onTap: () {
            Navigator.of(context).pop(true);

            // Pass the cancellation reason to the DeleteBooking event
            double charged = double.parse(confirmedBookingController.text);
           CloudStorageBookingApi(). confrimBookingInFirestore(
                bookingService: widget.bookingService, charged: charged);
                setState(() {
                  _isConfirmed = true;
                });
          },
        ),
      ],
    );
  }
}
