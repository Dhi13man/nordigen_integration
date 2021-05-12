library nordigen_integration;

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

/// Encapsulation of the Nordigen Open API functions.
///
/// For more information about the API: https://nordigen.com/en/account_information_documenation/integration/quickstart_guide/
///
/// Requires an Nordignen Access token available from https://ob.nordigen.com/
class NordigenAPI {
  const NordigenAPI({@required String accessToken})
      : _accessToken = accessToken;

  /// Nordigen API Access token required to access API functionality.
  final String _accessToken;

  /// Client initialization as we are repeatedly making requests to the same Server.
  final http.Client _client = http.Client();

  /// Utility class to easily make POST requests to Nordigen API endpoints.
  Future<dynamic> _postRequester(
    String endpointUrl,
    Map<String, dynamic> body,
  ) async {
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
        body: jsonEncode(body),
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
