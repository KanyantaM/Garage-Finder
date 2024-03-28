import 'package:cloud_storage_garage_api/cloud_storage_garage_api.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fixtex/bootstrap.dart';
import 'package:fixtex/firebase_options.dart';
import 'package:flutter/widgets.dart';

Future<void> main() async {
WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);

  final CloudGarageApi garageApi = CloudGarageApi();
  bootstrap(garageApi: garageApi);
}