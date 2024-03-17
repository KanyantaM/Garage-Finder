import 'package:fixtex/widgets/custom_calender.dart';
import 'package:fixtex/widgets/rectangle_button.dart';
import 'package:flutter/material.dart';

class ConfrimBookingScreen extends StatelessWidget {
  const ConfrimBookingScreen({super.key,});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          
          Center(child: CustomCalendar()),

           Padding(
             padding: EdgeInsets.all(8.0),
             child: Column(
              children: [Row(
             children: [
               Expanded(
                 child: Text(
                   'Bookings',
                   style: TextStyle(fontSize: 24.0),
                 ),
               ),
             ],
           ),
           SizedBox(height: 20,),
           Row(
             children: [
               Expanded(
                 child: Text(
                   'Richard Jhonson',
                   style: TextStyle(fontSize: 18.0),
                 ),
               ),
             ],
           ),
           Row(
             children: [
               Expanded(
                 child: Text(
                   'Thursday 18th of May 11:00AM',
                   style: TextStyle(fontSize: 16.0),
                 ),
               ),
             ],
           ),
           SizedBox(height: 20,),
           Row(
             children: [
               Expanded(
                 child: Text(
                   'The car takes ages to start and makes a funny noise when twisting the key',
                   style: TextStyle(fontSize: 14.0),
                 ),
               ),
             ],
           ),
           
           ],
             ),
           ),
           Padding(
             padding: EdgeInsets.all(20.0),
             child: Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: [
                 RectangleTopRight(text: 'Confirm'),
                 RectangleTopRight(text: 'Reject'),
               ],
             ),
           )
        ],
      ) 
    );
  }
}