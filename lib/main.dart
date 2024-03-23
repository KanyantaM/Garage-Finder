import 'package:cloud_storage_garage_api/cloud_storage_garage_api.dart';
import 'package:fixtex/bootstrap.dart';
import 'package:flutter/widgets.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final CloudGarageApi garageApi = CloudGarageApi();

  bootstrap(garageApi: garageApi);
}