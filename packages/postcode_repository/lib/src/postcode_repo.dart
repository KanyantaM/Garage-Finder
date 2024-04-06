import 'dart:async';
import 'dart:convert';
import 'dart:developer';
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
    try {
      final response = await http.get(Uri.parse('$_baseUrl/postcodes/$code'));
      log(json.decode(response.body).toString());
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        return <String, double>{
          'latitude':
              double.parse(jsonResponse['result']['latitude'].toString()),
          'longitude':
              double.parse(jsonResponse['result']['longitude'].toString())
        };
      } else if (response.statusCode == 404) {
        final jsonResponse = json.decode(response.body);
        throw Exception(jsonResponse['error']);
      } else {
        log('Request failed with status: ${response.statusCode}');
        throw Exception('Failed to reverse geocode');
      }
    } catch (e) {
      log('Error in lookupPostCodeCoordinates: $e');
      rethrow; // Rethrow the caught error for external handling
    }
  }

  Future<List<String>> autocompletePostcodes(String query) async {
    final List<String> controller = <String>[];

    try {
      if (query.isEmpty) {
        return <String>[];
      }
      final response =
          await http.get(Uri.parse('$_baseUrl/postcodes/$query/autocomplete'));
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final postcodeList = jsonResponse['result'];
        // log(postcodeList.toString());
        controller.addAll(List<String>.from(postcodeList));
        log(controller.toString());
      } else if (response.statusCode == 404) {
        final jsonResponse = json.decode(response.body);
        throw Exception(jsonResponse['error']);
      } else {
        throw Exception('Failed to suggest postcodes');
      }
    } catch (e) {
      return Future.error(e);
    }

    return controller;
  }
}
