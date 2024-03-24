part of 'find_garage_bloc.dart';

abstract class FindGarageEvent extends Equatable {
  const FindGarageEvent();

  @override
  List<Object> get props => [];
}

class SearchByPostcode extends FindGarageEvent {
  final String postcode;

  const SearchByPostcode({required this.postcode,});

  @override
  List<Object> get props => [postcode];

  @override
  String toString() => 'SearchByPostcode { postcode: $postcode }';
}

class SearchByMapInteraction extends FindGarageEvent {
  final double latitude;
  final double longitude;
  final List<Garage> garages;

  const SearchByMapInteraction({
    required this.garages,
    required this.latitude,
    required this.longitude,
  });

  @override
  List<Object> get props => [latitude, longitude];

  @override
  String toString() =>
      'SearchByMapInteraction { latitude: $latitude, longitude: $longitude }';
}

class SearchByPhoneLocation extends FindGarageEvent {
  final double latitude;
  final double longitude;

  const SearchByPhoneLocation({
    required this.latitude,
    required this.longitude,
  });

  @override
  List<Object> get props => [latitude, longitude];

  @override
  String toString() =>
      'SearchByMapInteraction { latitude: $latitude, longitude: $longitude }';
}

