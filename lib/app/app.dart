import 'package:fixtex/screens/starting_screen.dart';
import 'package:fixtex/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garage_repository/garage_repository.dart';

class App extends StatelessWidget {
  const App({required this.garageRepository, super.key});

  final GarageRepository garageRepository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: garageRepository,
      child: const AppView(),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: GarageFinderTheme.light,
      darkTheme: GarageFinderTheme.dark,
      // localizationsDelegates: AppLocalizations.localizationsDelegates,
      // supportedLocales: AppLocalizations.supportedLocales,
      home: StartingScreen(),
      // const BottomNav(),
    );
  }
}