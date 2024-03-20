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

  /// Provides a [Stream] of all todos.
  Stream<List<Garage>> getTodos() => _garageApi.getGarages();

  /// Saves a [Garage].
  ///
  /// If a [Garage] with the same id already exists, it will be replaced.
  Future<void> saveTodo(Garage garage) => _garageApi.saveGarage(garage);

  /// Deletes the `Garage` with the given id.
  ///
  /// If no `Garage` with the given id exists, a [GarageNotFoundException] error is
  /// thrown.
  Future<void> deleteGarage(String id) => _garageApi.deleteGarage(id);
}