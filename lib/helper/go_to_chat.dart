import 'package:fixtex/features/chat/chat.dart';
import 'package:fixtex/utilities/getting_room.dart';
import 'package:fixtex/widgets/rectangle_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

Widget chatWithOther(String otherId) {return FutureBuilder<types.Room>(
        future: settingUpRoom(otherId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              // child: CircularProgressIndicator(),
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return const Center(
                // child: Text('Error: ${snapshot.error}'),
              );
            }
            return Container(
              // height: 400,
              margin: const EdgeInsets.only(top: 10),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
                // color: kMainColor,
              ),
              child: RectangleTopRight(
                  text: 'Chat',
                  onTap: (){
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ChatPage(
                          room: snapshot.data!,
                        ),
                      ),
                    );
                  }),
            );
          }

          return const Center(
            child: Text('Something Went Wrong'),
          );
        },
      );
    }