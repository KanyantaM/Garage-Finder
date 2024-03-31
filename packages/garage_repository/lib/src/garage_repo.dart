import 'package:garage_api/garage_api.dart';

/// {@template garage_repository}
/// A repository that handles `garage` related requests.
/// {@endtemplate}
class GarageRepository {
  /// {@macro todos_repository}
  const GarageRepository({
    required GarageApi garageApi,
  }) : _garageApi = garageApi;

  final GarageApi _garageApi;

  /// Provides a [Stream] of all Garages.
  Stream<List<Garage>> getGarages() => _garageApi.getGarages();

  /// Provides a [List] of all Garages ranked by distance to the given location.
  Future<List<Garage>> searchGarages(String? postcode, double? lat, double? lng,) => _garageApi.arrangeGarageByLocation(postcode, lat, lng,);

  /// Saves a [Garage].
  ///
  /// If a [Garage] with the same id already exists, it will be replaced.
  Future<void> saveGarages(Garage garage) => _garageApi.saveGarage(garage);

  /// Deletes the `Garage` with the given id.
  ///
  /// If no `Garage` with the given id exists, a [GarageNotFoundException] error is
  /// thrown.
  Future<void> deleteGarage(String id) => _garageApi.deleteGarage(id);


  Future<Garage> getAGarage(String id) => _garageApi.getGarage(id);
}