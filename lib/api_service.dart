

import 'dart:developer';

import 'package:http/http.dart' as http;

import 'dart:convert';

class ApiService {
  final String baseUrl = "https://mmhomes.in/tennis_buddy/webservices/api";

  // fetch country list
  Future<List<Map<String, dynamic>>> fetchCountries() async {
    final url = Uri.parse('$baseUrl/country_list');
    final headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    };

    log('GET $url');
    log('Headers: $headers');

    final response = await http.get(url, headers: headers);

    log('Response status: ${response.statusCode}');
    log('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final dynamic data = jsonDecode(response.body);
      if (data['status'] == 1) {
        final List<dynamic> countriesData = data['result'];
        return countriesData.map((country) {
          return {
            'id': country['id'],
            'name': country['name'],
          };
        }).toList();
      } else {
        throw Exception('Failed to load countries: ${data['message']}');
      }
    } else {
      throw Exception('Failed to load countries');
    }
  }

// fetch state list
  Future<List<Map<String, dynamic>>> fetchStates(String countryId) async {
    final url = Uri.parse('$baseUrl/state_list');
    final headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    };
    final body = jsonEncode(<String, String>{
      'country_id': countryId,
    });

    log('POST $url');
    log('Headers: $headers');
    log('Body: $body');

    final response = await http.post(url, headers: headers, body: body);

    log('Response status: ${response.statusCode}');
    log('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final dynamic data = jsonDecode(response.body);
      if (data['status'] == 1) {
        final List<dynamic> statesData = data['result'];
        return statesData.map((state) {
          return {
            'id': state['id'],
            'name': state['name'],
          };
        }).toList();
      } else {
        throw Exception('Failed to load states: ${data['message']}');
      }
    } else {
      throw Exception('Failed to load states');
    }
  }

// fetch city list
  Future<List<Map<String, dynamic>>> fetchCities(
      String countryId, String stateId) async {
    final url = Uri.parse('$baseUrl/city_list');
    final headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    };
    final body = jsonEncode(<String, String>{
      'country_id': countryId,
      'state_id': stateId,
    });

    log('POST $url');
    log('Headers: $headers');
    log('Body: $body');

    final response = await http.post(url, headers: headers, body: body);

    log('Response status: ${response.statusCode}');
    log('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final dynamic data = jsonDecode(response.body);
      if (data['status'] == 1) {
        final List<dynamic> citiesData = data['result'];
        return citiesData.map((city) {
          return {
            'id': city['id'],
            'name': city['name'],
          };
        }).toList();
      } else {
        throw Exception('Failed to load cities: ${data['message']}');
      }
    } else {
      throw Exception('Failed to load cities');
    }
  }

  // Register a new user
  Future<http.Response> registerUser(
      String name,
      String mobile,
      String email,
      String countryId,
      String stateId,
      String cityId,
      String pincode,
      String password,
      String birthDate,
      String playHand) async {
    final url = Uri.parse('$baseUrl/user_register');
    final headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    };
    final body = jsonEncode(<String, String>{
      'name': name,
      'mobile': mobile,
      'email': email,
      'country_id': countryId,
      'state_id': stateId,
      'city_id': cityId,
      'pincode': pincode,
      'password': password,
      'birth_date': birthDate,
      'play_hand': playHand,
    });

    // Log the request
    log('POST $url');
    log('Headers: $headers');
    log('Body: $body');

    final response = await http.post(
      url,
      headers: headers,
      body: body,
    );

    // Log the response
    log('Response status: ${response.statusCode}');
    log('Response body: ${response.body}');

    return response;
  }

  //   User login
  Future<http.Response> loginUser(String mobile, String password) async {
    final url = Uri.parse('$baseUrl/user_login');
    final headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    };
    final body = jsonEncode(<String, String>{
      'mobile': mobile,
      'password': password,
      'token':
          '1234567', // Assuming 'token' is required and static for simplicity.
    });

    // Log the request
    log('POST $url');
    log('Headers: $headers');
    log('Body: $body');

    final response = await http.post(
      url,
      headers: headers,
      body: body,
    );

    // Log the response
    log('Response status: ${response.statusCode}');
    log('Response body: ${response.body}');

    return response;
  }
}
