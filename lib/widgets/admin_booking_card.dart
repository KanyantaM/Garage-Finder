import 'package:cloud_storage_booking_api/cloud_storage_booking_api.dart';
import 'package:fixtex/widgets/rectangle_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class AdminBookingCard extends StatefulWidget {
  final BookingService bookingService;
  final bool? isCompleted;

  const AdminBookingCard({
    Key? key,
    required this.bookingService,
    this.isCompleted,
  }) : super(key: key);

  @override
  State<AdminBookingCard> createState() => _BookingCardState();
}

class _BookingCardState extends State<AdminBookingCard>{
  bool _isConfirmed = false;
    @override
    void initState() {
    super.initState();
    _isConfirmed = widget.bookingService.confirmed ?? false;
  }


  @override
  Widget build(BuildContext context) {
    return Card(
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
          ],
        );
      },
    );
  }
}
