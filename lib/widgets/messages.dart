import 'package:flutter/material.dart';

class BookingCard extends StatelessWidget {
  final String garageName;
  final DateTime sentTime;
  final String confirmationText;
  final bool isRecieved;
  final bool isReade;

  const BookingCard({
    Key? key,
    required this.garageName,
    required this.confirmationText,
    required this.sentTime, required this.isRecieved, required this.isReade,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CircleAvatar(
                radius: 35,
                backgroundImage: NetworkImage(
                    'https://placeimg.com/64/64/people'), // Replace with your avatar logic
              ),
              const SizedBox(
                width: 7,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        garageName,
                        style: const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 30,),
                      Text(
                        sentTime.day == DateTime.now().day
                            ? '${sentTime.hour}:${sentTime.minute.toString().padLeft(2, '0')}'
                            : '${sentTime.day}/${sentTime.month}/${sentTime.year}',
                        style:
                            const TextStyle(fontSize: 14.0, color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width*0.6,
                        child: Text(
                          confirmationText,
                          style: const TextStyle(fontSize: 14.0),
                        ),
                      ),
                      Image.asset( isRecieved ? ( isReade ? 'assets/images/read.png':'assets/images/recieved.png'): 'assets/images/not_recieved.png' , scale: 2.5,),
                    ],
                  ),
                ]
              ),
            ],
          ),
          const Divider(),
        ],
      ),
    );
  }
}
