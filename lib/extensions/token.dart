part of 'package:nordigen_integration/nordigen_integration.dart';

extension NordigenTokenEndpoints on NordigenAccountInfoAPI {
  /// Static functionality to generate a Nordigen Access Token using a Nordigen
  /// user [secretID] (secret_id) and [secretKey] (secret_key). JWT pair getter.
  ///
  /// Returns a [Future] that resolves to a [Map] containing the generated
  /// Nordigen Access Token's Data.
  ///
  /// Throws a [http.ClientException] if the request fails.
  ///
  /// https://ob.nordigen.com/user-secrets/
  ///
  /// https://nordigen.com/en/account_information_documenation/integration/parameters-and-responses/#/token/JWT%20Obtain
  static Future<Map<String, dynamic>> createAccessToken({
    required String secretID,
    required String secretKey,
  }) async {
    final Map<String, String> data = <String, String>{
      'secret_id': secretID,
      'secret_key': secretKey,
    };
    // Make POST request and fetch output.
    final http.Response response = await http.post(
      Uri.parse('https://ob.nordigen.com/api/v2/token/new/'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'accept': 'application/json',
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Methods': 'GET, POST, DELETE, OPTIONS',
        'Access-Control-Allow-Headers': '*',
      },
      body: json.encode(data),
    );

    if ((response.statusCode / 100).floor() == 2) {
      return jsonDecode(utf8.decoder.convert(response.bodyBytes));
    } else
      throw http.ClientException(
        'Error Code: ${response.statusCode}, '
        // ignore: lines_longer_than_80_chars
        'Reason: ${jsonDecode(utf8.decoder.convert(response.bodyBytes))["detail"]}',
      );
  }

  /// Refresh Access Token.
  ///
  /// Returns a [Future] that resolves to a [Map] containing the refreshed
  /// Nordigen Access Token's Data.
  ///
  /// https://nordigen.com/en/account_information_documenation/integration/parameters-and-responses/#/token/JWT%20Refresh
  Future<Map<String, dynamic>> refreshAccessToken({
    required String refresh,
  }) async {
    // Make POST request and fetch output.
    final http.Response response = await http.post(
      Uri.parse('https://ob.nordigen.com/api/v2/token/refresh/'),
      headers: _headers,
      body: json.encode(<String, String>{'refresh': refresh}),
    );

    if ((response.statusCode / 100).floor() == 2) {
      return jsonDecode(utf8.decoder.convert(response.bodyBytes));
    } else
      throw http.ClientException(
        'Error Code: ${response.statusCode}, '
        // ignore: lines_longer_than_80_chars
        'Reason: ${jsonDecode(utf8.decoder.convert(response.bodyBytes))["detail"]}',
      );
  }
}
