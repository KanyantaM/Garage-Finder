import 'package:fixtex/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';

import 'chat.dart';
import 'util.dart';

class UsersPage extends StatelessWidget {
  final bool isGarage;
  final bool isAdmin;
  const UsersPage({super.key, required this.isGarage, this.isAdmin = false});

  Widget _buildAvatar(types.User user) {
    final color = getUserAvatarNameColor(user);
    final hasImage = user.imageUrl != null;
    final name = getUserName(user);

    return Container(
      margin: const EdgeInsets.only(right: 16),
      child: CircleAvatar(
        backgroundColor: hasImage ? Colors.transparent : color,
        backgroundImage: hasImage ? NetworkImage(user.imageUrl!) : null,
        radius: 20,
        child: !hasImage
            ? Text(
                name.isEmpty ? '' : name[0].toUpperCase(),
                style: const TextStyle(color: Colors.white),
              )
            : null,
      ),
    );
  }

  void _handlePressed(types.User otherUser, BuildContext context) async {
    final navigator = Navigator.of(context);
    final room = await FirebaseChatCore.instance.createRoom(otherUser);

    navigator.pop();
    await navigator.push(
      MaterialPageRoute(
        builder: (context) => ChatPage(
          room: room,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: customAppBar(
            isAdmin ? 'AppUsers' : (isGarage ? 'Car Owners' : 'Garage Owners')),
        body: StreamBuilder<List<types.User>>(
          stream: FirebaseChatCore.instance.users(),
          initialData: const [],
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.only(
                  bottom: 200,
                ),
                child: Text(
                    'No ${isAdmin ? 'AppUsers' : (isGarage ? 'Car Owners' : 'Garage Owners')}'),
              );
            }
            List<types.User> owners = [];
            for (types.User user in snapshot.data!) {
              if (!isAdmin) {
                if (isGarage) {
                  if (user.role == types.Role.user) {
                    owners.add(user);
                  }
                } else {
                  if (user.role == types.Role.agent) {
                    owners.add(user);
                  }
                }
              } else {
                owners.add(user);
              }
            }
            return ListView.builder(
              itemCount: owners.length,
              itemBuilder: (context, index) {
                final user = owners[index];

                return GestureDetector(
                  onTap: () {
                    _handlePressed(user, context);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Row(
                      children: [
                        _buildAvatar(user),
                        Text(getUserName(user)),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      );
}
