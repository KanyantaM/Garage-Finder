import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:fixtex/app/app.dart';
import 'package:fixtex/app/app_bloc_observer.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garage_api/garage_api.dart';
import 'package:garage_repository/garage_repository.dart';

void bootstrap({required GarageApi garageApi}) {
  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  Bloc.observer = const AppBlocObserver();

  final garageRepository = GarageRepository(garageApi: garageApi);

  runZonedGuarded(
    () => runApp(App(garageRepository: garageRepository)),
    (error, stackTrace) => log(error.toString(), stackTrace: stackTrace),
  );
}