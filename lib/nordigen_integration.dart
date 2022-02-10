library nordigen_integration;

import 'dart:convert';

import 'package:http/http.dart' as http;

/// Data Models
part 'package:nordigen_integration/data_models/nordigen_balance_model.dart';
part 'package:nordigen_integration/data_models/nordigen_account_models.dart';
part 'package:nordigen_integration/data_models/nordigen_other_data_models.dart';
part 'package:nordigen_integration/data_models/nordigen_requisition_model.dart';
part 'package:nordigen_integration/data_models/nordigen_transaction_model.dart';

// Extensions
part 'package:nordigen_integration/extensions/token.dart';
part 'package:nordigen_integration/extensions/institutions.dart';
part 'package:nordigen_integration/extensions/agreements.dart';
part 'package:nordigen_integration/extensions/requisitions.dart';
part 'package:nordigen_integration/extensions/accounts.dart';

/// Encapsulation of the Nordigen Open Account Information API functions.
///
/// Requires either (as per https://ob.nordigen.com/user-secrets/):
/// 1. a Nordigen Access Token that has already been generated, to initialize
/// using [NordigenAccountInfoAPI] constructor.
///
/// 2. a Nordigen secret_id and secret_key, to generate a new access token and
/// initialize using [NordigenAccountInfoAPI.fromSecret]:
///
/// For more information about the API:
/// https://nordigen.com/en/account_information_documenation/integration/quickstart_guide/
class NordigenAccountInfoAPI {
  /// Initialize the Nordigen API with a pre-generated Nordigen Access Token.
  NordigenAccountInfoAPI({required String accessToken})
      : _accessToken = accessToken;

  /// Nordigen API Access token required to access API functionality.
  final String _accessToken;

  /// Client initialization as we repeated requests to the same Server.
  final http.Client _client = http.Client();

  /// Initialize the Nordigen API with Access Token generated using Nordigen
  /// user [secretID] (secret_id) and [secretKey] (secret_key).
  ///
  /// This is a convenience method that will generate a Nordigen Access Token
  /// for you and return a [Future] that resolves to the initialized
  /// [NordigenAccountInfoAPI] object using that Access Token.
  ///
  /// https://ob.nordigen.com/user-secrets/
  static Future<NordigenAccountInfoAPI> fromSecret({
    required String secretID,
    required String secretKey,
  }) async {
    final Map<String, dynamic> data =
        await NordigenTokenEndpoints.createAccessToken(
      secretID: secretID,
      secretKey: secretKey,
    );
    return NordigenAccountInfoAPI(accessToken: data['access']!);
  }

  /// Static functionality to generate a Nordigen Access Token using a Nordigen
  /// user [secretID] (secret_id) and [secretKey] (secret_key). JWT pair getter.
  ///
  /// https://ob.nordigen.com/user-secrets/
  ///
  /// https://nordigen.com/en/account_information_documenation/integration/parameters-and-responses/#/token/JWT%20Obtain
  static Future<Map<String, dynamic>> createAccessToken({
    required String secretID,
    required String secretKey,
  }) =>
      NordigenTokenEndpoints.createAccessToken(
        secretID: secretID,
        secretKey: secretKey,
      );

  /// Generate headers for requests.
  Map<String, String> get _headers => <String, String>{
        'accept': 'application/json',
        'Content-Type': 'application/json',
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Methods': 'GET, POST, DELETE, OPTIONS',
        'Access-Control-Allow-Headers': '*',
        'Authorization': 'Bearer $_accessToken',
      };

  /// Utility class to easily make POST requests to Nordigen API endpoints.
  ///
  /// [requestType] can be 'POST' or 'PUT'.
  Future<dynamic> _nordigenPoster({
    required String endpointUrl,
    Map<String, dynamic> data = const <String, dynamic>{},
    String requestType = 'POST',
  }) async {
    // Validate [requestType].
    assert(requestType == 'POST' || requestType == 'PUT');
    final Uri requestURL = Uri.parse(endpointUrl);
    http.Response response;
    if (requestType == 'PUT') {
      response = await _client.put(
        requestURL,
        headers: _headers,
        body: jsonEncode(data),
      );
    } else {
      response = await _client.post(
        requestURL,
        headers: _headers,
        body: jsonEncode(data),
      );
    }
    if ((response.statusCode / 100).floor() == 2) {
      return jsonDecode(utf8.decoder.convert(response.bodyBytes));
    } else {
      throw http.ClientException(
        'Error Code: ${response.statusCode}, '
        // ignore: lines_longer_than_80_chars
        'Reason: ${jsonDecode(utf8.decoder.convert(response.bodyBytes))["detail"]}',
        requestURL,
      );
    }
  }

  /// Utility class to easily make GET requests to Nordigen API endpoints.
  Future<dynamic> _nordigenGetter({required String endpointUrl}) async {
    final Uri requestURL = Uri.parse(endpointUrl);
    final http.Response response = await _client.get(
      requestURL,
      headers: _headers,
    );
    if ((response.statusCode / 100).floor() == 2) {
      return jsonDecode(utf8.decoder.convert(response.bodyBytes));
    } else {
      throw http.ClientException(
        'Error Code: ${response.statusCode}, '
        // ignore: lines_longer_than_80_chars
        'Reason: ${jsonDecode(utf8.decoder.convert(response.bodyBytes))["detail"]}',
        requestURL,
      );
    }
  }

  /// Utility class to easily make DELETE requests to Nordigen API endpoints.
  Future<dynamic> _nordigenDeleter({required String endpointUrl}) async {
    final Uri requestURL = Uri.parse(endpointUrl);
    final http.Response response = await _client.delete(
      requestURL,
      headers: _headers,
    );
    if ((response.statusCode / 100).floor() == 2) {
      return jsonDecode(utf8.decoder.convert(response.bodyBytes));
    } else {
      throw http.ClientException(
        'Error Code: ${response.statusCode}, '
        // ignore: lines_longer_than_80_chars
        'Reason: ${jsonDecode(utf8.decoder.convert(response.bodyBytes))["detail"]}',
        requestURL,
      );
    }
  }
}
