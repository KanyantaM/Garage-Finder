import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';

Future<Room> settingUpRoom(String otherId) async{
  List<types.User> otherUsers = await FirebaseChatCore.instance.users().first;
  types.User otherUser = otherUsers.firstWhere((element) => element.id == otherId);
  return await FirebaseChatCore.instance.createRoom(otherUser);
  }