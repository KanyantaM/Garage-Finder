abstract class UserApi {
  const UserApi();

  /// Provides a [Stream] of Garages
  Stream<List<Garage>> getGarages();

  /// Fetches a particular [Garage] by [String] garageID
  Future<Garage> getGarage(String garageID);

  /// Saves a [Garage].
  ///
  /// If a [Garage] with the same id already exists, it will be replaced.
  Future<void> saveGarage(Garage garage);

  /// Deletes the `Garage` with the given id.
  ///
  /// If no `Garage` with the given id exists, a [GarageNotFoundException] error is
  /// thrown.
  Future<void> deleteGarage(String id);

  /// Searches for a [Garage] by postcode/location
  /// 
  /// Provides a [List] of Garages ranked in order of distance to the desired postcode/location
  Future<List<Garage>> arrangeGarageByLocation(String? postcode,double? lat, double? lng,);
}

/// Error thrown when a [Garage] with a given id is not found.
class GarageNotFoundException implements Exception {}