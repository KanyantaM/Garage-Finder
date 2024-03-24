import 'package:cloud_storage_garage_api/cloud_storage_garage_api.dart';
import 'package:fixtex/features/find_garage/bloc/find_garage_bloc.dart';
import 'package:fixtex/features/find_garage/view/find_garage_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garage_repository/garage_repository.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => FindGarageBloc(GarageRepository(garageApi: CloudGarageApi())),
      child: const FindGarageView(),
    );
  }
}