library nordigen_integration;

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

part 'nordigen_data_models.dart';

/// Encapsulation of the Nordigen Open Account Information API functions.
///
/// For more information about the API: https://nordigen.com/en/account_information_documenation/integration/quickstart_guide/
///
/// Requires an Nordignen Access token available from https://ob.nordigen.com/
class NordigenAccountInfoAPI {
  NordigenAccountInfoAPI({@required String accessToken})
      : _accessToken = accessToken;

  /// Nordigen API Access token required to access API functionality.
  final String _accessToken;

  /// Client initialization as we are repeatedly making requests to the same Server.
  final http.Client _client = http.Client();

  /// Gets the ASPSPs (Banks) for the given [countryCode].
  ///
  /// Refer to Step 2 of Nordigen Account Information API documentation.
  /// [countryCode] is just two-letter country code (ISO 3166).
  Future<List<ASPSP>> getBanksForCountry(String countryCode) async {
    final List<Map<String, dynamic>> aspspsMap = await _nordigenGetter(
      endpointUrl: "https://ob.nordigen.com/api/aspsps/?country=$countryCode",
    ) as List<Map<String, dynamic>>;
    return aspspsMap
        .map<ASPSP>(
          (Map<String, dynamic> aspspMapItem) => ASPSP.fromMap(aspspMapItem),
        )
        .toList();
  }

  /// Utility class to easily make POST requests to Nordigen API endpoints.
  Future<dynamic> _nordigenPoster({
    @required String endpointUrl,
    Map<String, dynamic> data,
  }) async {
    dynamic output = {};
    try {
      final Uri requestURL = Uri.parse(endpointUrl);
      http.Response response = await _client.post(
        requestURL,
        headers: <String, String>{
          'accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Token $_accessToken',
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 200)
        output = jsonDecode(response.body);
      else
        throw http.ClientException('Improper API response!');
    } catch (e) {
      throw http.ClientException('Connection to API Failed: $e');
    }
    return output;
  }

  /// Utility class to easily make GET requests to Nordigen API endpoints.
  Future<dynamic> _nordigenGetter({@required String endpointUrl}) async {
    dynamic output = {};
    try {
      final Uri requestURL = Uri.parse(endpointUrl);
      http.Response response = await _client.get(
        requestURL,
        headers: <String, String>{
          'accept': 'application/json',
          'Authorization': 'Token $_accessToken',
        },
      );

      if (response.statusCode == 200)
        output = jsonDecode(response.body);
      else
        throw http.ClientException('Improper API response!');
    } catch (e) {
      throw http.ClientException('Connection to API Failed: $e');
    }
    return output;
  }
}
