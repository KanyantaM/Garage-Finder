import 'package:cloud_storage_booking_api/cloud_storage_booking_api.dart';
import 'package:fixtex/consts/colors.dart';
import 'package:fixtex/features/car_owner/car_owner_bookings/my_bookings/my_bookings_bloc.dart';
import 'package:fixtex/widgets/rectangle_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class CarOwnerBookingCard extends StatelessWidget {
  final BookingService bookingService;
  final void Function()? onSwipe;

  const CarOwnerBookingCard({
    super.key,
    required this.bookingService,
    required this.onSwipe,
  });

  @override
  Widget build(BuildContext context) {
    int rating = bookingService.rating ?? 0;
    // If booking is confirmed, set isCompleted to true
    bool isConfirmed = bookingService.confirmed ?? false;
    bool tooLateToDelete = DateTime.now()
            .isAfter(bookingService.bookingStart) ||
        bookingService.bookingStart.difference(DateTime.now()).inHours.abs() <=
            2;

    return Dismissible(
      key: Key('${bookingService.serviceId}'),
      background: Container(
        color: Colors.blueGrey,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: const Icon(Icons.delete_forever),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (bookingService.confirmed ?? false)
          ? (direction) {
              return showDialog(
                  context: context,
                  builder: (context) {
                    return const AlertDialog(
                      title: Text('You can\'t delete a confirmed bookings'),
                    );
                  });
            }
          : (tooLateToDelete)
              ? (direction) {
                  return showDialog(
                      context: context,
                      builder: (context) {
                        return const AlertDialog(
                          title: Text(
                              'You can only delete a booking 2 hours before it starts'),
                        );
                      });
                }
              : (direction) async {
                  return await showDialog(
                    context: context,
                    builder: ((context) {
                      return deleteBookingDialogue(context);
                    }),
                  );
                },
      onDismissed: bookingService.confirmed ?? false
          ? (direction) {
              onSwipe?.call();
            }
          : (direction) {},
      child: Card(
        color: isConfirmed ? Colors.green : Colors.lightBlue[300],
        elevation: 4,
        margin: const EdgeInsets.all(10),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      serviceDetailDialogue(context);
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Time: ${bookingService.bookingStart}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Service: ${bookingService.serviceName}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  const Divider(
                    color: Colors.white,
                  ),
                  isConfirmed
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
              isConfirmed
                  ? (rating != 0
                      ? RatingBarIndicator(
                          rating: bookingService.rating!.toDouble(),
                          itemBuilder: (context, index) => const Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          itemCount: 5,
                          direction: Axis.horizontal,
                        )
                      : RectangleTopRight(
                          text: 'Rate',
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    actionsAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    title: const Text('Rate the service'),
                                    content: RatingBar(
                                        ratingWidget: RatingWidget(
                                            full: const Icon(
                                              Icons.star,
                                              color: Colors.amber,
                                            ),
                                            half: const Icon(Icons.star_half,
                                                color: Colors.amber),
                                            empty: const Icon(Icons.star_border,
                                                color: Colors.amber)),
                                        onRatingUpdate: (value) {
                                          rating = value.round();
                                        }),
                                    actions: [
                                      IconButton(
                                          onPressed: () async {
                                            await CloudStorageBookingApi()
                                                .rateBookingInFirestore(
                                                    bookingService:
                                                        bookingService,
                                                    rating: rating);
                                          },
                                          icon: const Icon(Icons.check)),
                                      IconButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          icon: const Icon(Icons.cancel))
                                    ],
                                  );
                                });
                          },
                        ))
                  : const Wrap(),
            ],
          ),
        ),
      ),
    );
  }

  Future<dynamic> serviceDetailDialogue(BuildContext context) {
    bool isConfirmed = bookingService.confirmed ?? false;
    bool tooLateToDelete = DateTime.now()
            .isAfter(bookingService.bookingStart) ||
        bookingService.bookingStart.difference(DateTime.now()).inHours.abs() <=
            2;
    if (isConfirmed) {
      return showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(
              title: Text('You can\'t delete a confirmed bookings'),
            );
          });
    } else if (tooLateToDelete) {
      return showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(
              title: Text(
                  'You can only delete a booking 2 hours before it starts'),
            );
          });
    } else {
      return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              'Booking Details\n'
              'Service: ${bookingService.serviceName}\n'
              // 'Price: ${bookingService.servicePrice!.toStringAsFixed(2)}\n'
              'Duration: ${bookingService.serviceDuration} minutes',
            ),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                    'Time: ${bookingService.bookingStart} - ${bookingService.bookingEnd}'),
              ],
            ),
            actions: [
              RectangleTopRight(
                text: 'OK',
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
              const SizedBox(
                height: 5,
              ),
              RectangleTopRight(
                text: 'Delete',
                onTap: () async {
                  Navigator.of(context).pop();
                  deleteBookingDialogue(context);
                },
                color: Colors.red,
              ),
            ],
          );
        },
      );
    }
  }

  AlertDialog deleteBookingDialogue(BuildContext context) {
    TextEditingController reasonController = TextEditingController();

    return AlertDialog(
      title: const Icon(Icons.delete_forever_outlined),
      content: Wrap(
        // crossAxisAlignment: CrossAxisAlignment.start,
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
        RectangleTopRight(
          text: 'No',
          onTap: () {
            Navigator.of(context).pop(false);
          },
          color: Colors.blueGrey,
        ),
        RectangleTopRight(
          text: 'Yes',
          onTap: () {
            Navigator.of(context).pop(true);

            // Pass the cancellation reason to the DeleteBooking event
            String cancellationReason = reasonController.text;
            BlocProvider.of<MyBookingBloc>(context).add(DeleteBooking(
                bookingService.bookingStart,
                cancellationReason,
                bookingService.serviceProviderId!));
          },
          color: kmainBlue,
        ),
      ],
    );
  }
}
