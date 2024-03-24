import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class PostcodeRepository {
  static const String _baseUrl = 'https://api.postcodes.io';

  Future<bool> validatePostcode(String postcode) async {
    final response =
        await http.get(Uri.parse('$_baseUrl/postcodes/$postcode/validate'));
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return jsonResponse['result'];
    } else {
      throw Exception('Failed to validate postcode');
    }
  }

  Future<Map<String, double>> lookupPostCodeCoordinates(String code) async {
    final response = await http.get(Uri.parse('$_baseUrl/postcodes/$code'));
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return <String, double>{
        'latitude': jsonResponse['result']['latitude'],
        'longitude': jsonResponse['result']['longitude']
      };
    } else {
      throw Exception('Failed to reverse geocode');
    }
  }

  Stream<List<String>> autocompletePostcodes(String query) async* {
  final controller = StreamController<List<String>>();
  
  try {
    final response = await http.get(Uri.parse('$_baseUrl/postcodes/$query/autocomplete'));
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final postcodeList = jsonResponse['result'];
      controller.add(List<String>.from(postcodeList));
    } else {
      throw Exception('Failed to suggest postcodes');
    }
  } catch (e) {
    controller.addError(e);
  }
  
  await controller.close();
}
}
