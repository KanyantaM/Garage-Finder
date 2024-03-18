import 'package:garage_api/src/models/garage_model.dart';

abstract class GarageApi {
  const GarageApi();

  /// Provides a [Stream] of Garages
  Stream<List<Garage>> getGarages();

  /// Saves a [Garage].
  ///
  /// If a [Garage] with the same id already exists, it will be replaced.
  Future<void> saveGarage(Garage garage);

  /// Deletes the `Garage` with the given id.
  ///
  /// If no `Garage` with the given id exists, a [GarageNotFoundException] error is
  /// thrown.
  Future<void> deleteGarage(String id);
}

/// Error thrown when a [Garage] with a given id is not found.
class GarageNotFoundException implements Exception {}