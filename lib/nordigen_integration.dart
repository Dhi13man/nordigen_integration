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
    // Make GET request and fetch output.
    final List<dynamic> aspspsMap = await _nordigenGetter(
      endpointUrl: "https://ob.nordigen.com/api/aspsps/?country=$countryCode",
    ) as List<dynamic>;
    // Map the recieved List<dynamic> into List<ASPSP> Data Format for convenience.
    return aspspsMap
        .map<ASPSP>(
          (dynamic aspspMapItem) => ASPSP.fromMap(aspspMapItem),
        )
        .toList();
  }

  /// Create an End User Agreement for the given [endUserID] and [aspspID] (or [aspsp])
  /// and for the given [maxHistoricalDays] (default 90 days).
  ///
  /// Refer to Step 3 of Nordigen Account Information API documentation.
  ///
  /// Both [aspspID] and [aspsp] can not be NULL.
  /// If both are NOT NULL, [aspspID] will be prefereed.
  Future<EndUserAgreementModel> createEndUserAgreement({
    @required String endUserID,
    String aspspID,
    ASPSP aspsp,
    int maxHistoricalDays = 90,
  }) async {
    // Prepare the ASPSP ID that the function will work with
    assert(aspspID != null || (aspsp != null && aspsp.id != null));
    final String workingAspspID = aspspID ?? aspsp.id;
    // Make POST request and fetch output.
    final dynamic fetchedMap = await _nordigenPoster(
      endpointUrl: "https://ob.nordigen.com/api/agreements/enduser/",
      data: {
        'max_historical_days': maxHistoricalDays.toString(),
        'aspsp_id': workingAspspID,
        'enduser_id': endUserID,
      },
    );
    // Map the recieved dynamic into EndUserAgreementModel for convenience.
    return EndUserAgreementModel.fromMap(fetchedMap);
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
      if ((response.statusCode / 100).floor() == 2)
        output = jsonDecode(response.body);
      else
        throw http.ClientException(
          'Error Code: ${response.statusCode}, Reason: ${jsonDecode(response.body)["detail"]}',
        );
    } catch (e) {
      throw http.ClientException('POST Request Failed: $e');
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
      if ((response.statusCode / 100).floor() == 2)
        output = jsonDecode(response.body);
      else
        throw http.ClientException(
          'Error Code: ${response.statusCode}, Reason: ${jsonDecode(response.body)["detail"]}',
        );
    } catch (e) {
      throw http.ClientException('GET Request Failed: $e');
    }
    return output;
  }
}
