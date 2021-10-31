library nordigen_integration;

import 'dart:convert';

import 'package:http/http.dart' as http;

/// Data Models
part 'package:nordigen_integration/data_models/nordigen_balance_model.dart';
part 'package:nordigen_integration/data_models/nordigen_account_models.dart';
part 'package:nordigen_integration/data_models/nordigen_other_data_models.dart';
part 'package:nordigen_integration/data_models/nordigen_transaction_model.dart';

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
    final Map<String, dynamic> data = await createAccessToken(
      secretID: secretID,
      secretKey: secretKey,
    );
    return NordigenAccountInfoAPI(accessToken: data['access']!);
  }

  /// Static functionality to generate a Nordigen Access Token using a Nordigen
  /// user [secretID] (secret_id) and [secretKey] (secret_key).
  ///
  /// Returns a [Future] that resolves to a [Map] containing the generated
  /// Nordigen Access Token Data.
  ///
  /// Throws a [http.ClientException] if the request fails.
  ///
  /// https://ob.nordigen.com/user-secrets/
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
        'accept': 'application/json'
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

  /// Gets the Institutions (Banks) for the given [countryCode].
  ///
  /// Refer to Step 2 of Nordigen Account Information API documentation.
  /// [countryCode] is just two-letter country code (ISO 3166).
  Future<List<Institution>> getInstitutionsForCountry(
      {required String countryCode}) async {
    assert(countryCode.isNotEmpty);
    // Make GET request and fetch output.
    final List<dynamic> fetchedData = await _nordigenGetter(
          endpointUrl:
              'https://ob.nordigen.com/api/v2/institutions/?country=$countryCode',
        ) ??
        <dynamic>[];
    // Map the recieved List<dynamic> into List<Institution> Data Format.
    return fetchedData
        .map<Institution>(
          (dynamic institutionItem) => Institution.fromMap(institutionItem),
        )
        .toList();
  }

  /// Get the Institution identified by [institutionID].
  Future<Institution> getInstitutionUsingID(
      {required String institutionID}) async {
    assert(institutionID.isNotEmpty);
    // Make GET request and fetch output.
    final dynamic fetchedData = await _nordigenGetter(
      endpointUrl:
          'https://ob.nordigen.com/api/v2/institutions/$institutionID/',
    );
    // Form the recieved dynamic Map into RequisitionModel for convenience.
    return Institution.fromMap(fetchedData);
  }

  /// Create an End User Agreement for given [endUserID], Institution identified
  /// by [institutionID], and for given [maxHistoricalDays] (default 90 days).
  ///
  /// Refer to Step 3 of Nordigen Account Information API documentation.
  Future<EndUserAgreementModel> createEndUserAgreement({
    required String endUserID,
    required String institutionID,
    int maxHistoricalDays = 90,
  }) async {
    // Make POST request and fetch output.
    final dynamic fetchedData = await _nordigenPoster(
      endpointUrl: 'https://ob.nordigen.com/api/agreements/enduser/',
      data: <String, dynamic>{
        // API accepts days as String
        'max_historical_days': maxHistoricalDays.toString(),
        'institution_id': institutionID,
        'enduser_id': endUserID,
      },
    );
    // Form the recieved dynamic Map into EndUserAgreementModel for convenience.
    return EndUserAgreementModel.fromMap(fetchedData);
  }

  /// Get the End-User Agreement identified by [endUserAgreementID].
  ///
  /// Refer to Step 5 of Nordigen Account Information API documentation.
  Future<EndUserAgreementModel> getEndUserAgreementUsingID({
    required String endUserAgreementID,
  }) async {
    assert(endUserAgreementID.isNotEmpty);
    // Make GET request and fetch output.
    final dynamic fetchedData = await _nordigenGetter(
      endpointUrl:
          'https://ob.nordigen.com/api/agreements/enduser/$endUserAgreementID/',
    );
    // Form the recieved dynamic Map into RequisitionModel for convenience.
    return EndUserAgreementModel.fromMap(fetchedData);
  }

  /// Get all the End-User Agreements of the User identified by [endUserID].
  Future<List<EndUserAgreementModel>> getEndUserAgreementsUsingUserID({
    required String endUserID,
  }) async {
    assert(endUserID.isNotEmpty);
    // Make GET request and fetch output.
    final Map<String, dynamic> fetchedData = await _nordigenGetter(
      endpointUrl:
          'https://ob.nordigen.com/api/agreements/enduser/?enduser_id=$endUserID',
    );
    final List<dynamic> fetchedEndUserAgreements = fetchedData['results'];
    // Form the recieved dynamic Map into EndUserAgreementModel for convenience.
    return fetchedEndUserAgreements
        .map<EndUserAgreementModel>(
          (dynamic endUserAgreementData) =>
              EndUserAgreementModel.fromMap(endUserAgreementData),
        )
        .toList();
  }

  /// Delete the End-User Agreement identified by [endUserAgreementID].
  ///
  /// Refer to Step 5 of Nordigen Account Information API documentation.
  Future<void> deleteEndUserAgreementUsingID({
    required String endUserAgreementID,
  }) async =>
      await _nordigenDeleter(
        endpointUrl:
            'https://ob.nordigen.com/api/agreements/enduser/$endUserAgreementID/',
      );

  /// Create a Requisition for the given [endUserID].
  ///
  /// Refer to Step 4.1 of Nordigen Account Information API documentation.
  ///
  /// [reference] is additional layer of unique ID. Should match Step 3 if done.
  /// [redirect] is the link where the end user will be redirected after
  /// finishing authentication in Institution.
  /// [agreements] is as an array of ID(s) from Step 3 or empty array
  /// if that step was skipped.
  Future<RequisitionModel> createRequisition({
    required String endUserID,
    required String redirect,
    required String reference,
    List<String> agreements = const <String>[],
  }) async {
    // Make POST request and fetch output.
    final dynamic fetchedData = await _nordigenPoster(
      endpointUrl: 'https://ob.nordigen.com/api/requisitions/',
      data: <String, dynamic>{
        'redirect': redirect,
        'reference': reference,
        'enduser_id': endUserID,
        'agreements': agreements,
      },
    );
    // Form the recieved dynamic Map into RequisitionModel for convenience.
    return RequisitionModel.fromMap(fetchedData);
  }

  /// Provides a redirect link to the Requisition represented by the
  /// [requisitionID] passed in, and for the Institution represented
  /// by [institutionID].
  ///
  /// Refer to Step 4.2 of Nordigen Account Information API documentation.
  Future<String> fetchRedirectLinkForRequisition({
    required String institutionID,
    required String requisitionID,
  }) async {
    // Make POST request and fetch output.
    final dynamic fetchedData = await _nordigenPoster(
      endpointUrl:
          'https://ob.nordigen.com/api/requisitions/$requisitionID/links/',
      data: <String, dynamic>{'institution_id': institutionID},
    );
    // Extract the redirectURL and output it.
    return fetchedData['initiate'].toString();
  }

  /// Get All Requisitions.
  ///
  /// Refer to Step 5 of Nordigen Account Information API documentation.
  Future<List<RequisitionModel>> getRequisitions({
    int limit = 100,
    int offset = 0,
  }) async {
    // Make GET request and fetch output.
    final Map<String, dynamic> fetchedData = await _nordigenGetter(
      endpointUrl:
          'https://ob.nordigen.com/api/requisitions/?limit=$limit&offset=$offset',
    );
    final List<dynamic> fetchedRequisitions = fetchedData['results'];
    // Form the recieved dynamic Map into RequisitionModel for convenience.
    return fetchedRequisitions
        .map<RequisitionModel>((dynamic requisitionData) =>
            RequisitionModel.fromMap(requisitionData))
        .toList();
  }

  /// Get the Requisition identified by [requisitionID].
  ///
  /// Refer to Step 5 of Nordigen Account Information API documentation.
  Future<RequisitionModel> getRequisitionUsingID({
    required String requisitionID,
  }) async {
    assert(requisitionID.isNotEmpty);
    // Make GET request and fetch output.
    final dynamic fetchedData = await _nordigenGetter(
      endpointUrl: 'https://ob.nordigen.com/api/requisitions/$requisitionID/',
    );
    // Form the recieved dynamic Map into RequisitionModel for convenience.
    return RequisitionModel.fromMap(fetchedData);
  }

  /// Delete the Requisition identified by [requisitionID].
  ///
  /// Refer to Step 5 of Nordigen Account Information API documentation.
  Future<void> deleteRequisitionUsingID({
    required String requisitionID,
  }) async =>
      await _nordigenDeleter(
        endpointUrl: 'https://ob.nordigen.com/api/requisitions/$requisitionID/',
      );

  /// Get the Account IDs of the User,
  /// for the Requisition identified by [requisitionID].
  ///
  /// Uses [getRequisitionUsingID] and then finds the accounts.
  ///
  /// Refer to Step 5 of Nordigen Account Information API documentation.
  Future<List<String>> getEndUserAccountIDs({
    required String requisitionID,
  }) async =>
      (await getRequisitionUsingID(requisitionID: requisitionID)).accounts;

  /// Get the Details of the Bank Account identified by [accountID].
  ///
  /// [AccountMetaData] follows schema in https://nordigen.com/en/docs/account-information/overview/parameters-and-responses/.
  ///
  /// Refer to Step 6 of Nordigen Account Information API documentation.
  Future<AccountMetaData> getAccountMetaData({
    required String accountID,
  }) async {
    assert(accountID.isNotEmpty);
    // Make GET request and fetch output.
    final dynamic fetchedData = await _nordigenGetter(
      endpointUrl: 'https://ob.nordigen.com/api/accounts/$accountID/',
    );
    // Form the received dynamic Map into AccountMetaData for convenience.
    return AccountMetaData.fromMap(fetchedData);
  }

  /// Get the Details of the Bank Account identified by [accountID].
  ///
  /// [AccountDetails] follows schema in https://nordigen.com/en/docs/account-information/output/accounts/.
  ///
  /// Refer to Step 6 of Nordigen Account Information API documentation.
  Future<AccountDetails> getAccountDetails({
    required String accountID,
  }) async {
    assert(accountID.isNotEmpty);
    // Make GET request and fetch output.
    final dynamic fetchedData = await _nordigenGetter(
      endpointUrl: 'https://ob.nordigen.com/api/accounts/$accountID/details/',
    );
    assert(fetchedData['account'] != null);
    // Form the recieved dynamic Map into BankAccountDetails for convenience.
    return AccountDetails.fromMap(fetchedData['account']);
  }

  /// Get the Transactions of the Bank Account identified by [accountID].
  ///
  /// Returns a [Map] of [String] keys: 'booked', 'pending' with the relevant
  /// list of [TransactionData]) for each.
  ///
  /// Refer to Step 6 of Nordigen Account Information API documentation.
  Future<Map<String, List<TransactionData>>> getAccountTransactions({
    required String accountID,
  }) async {
    assert(accountID.isNotEmpty);
    // Make GET request and fetch output.
    final dynamic fetchedData = await _nordigenGetter(
      endpointUrl:
          'https://ob.nordigen.com/api/accounts/$accountID/transactions/',
    );
    // No Transactions retrieved case.
    if (fetchedData['transactions'] == null)
      return <String, List<TransactionData>>{};
    final List<dynamic> bookedTransactions =
            fetchedData['transactions']['booked'] ?? <dynamic>[],
        pendingTransactions =
            fetchedData['transactions']['pending'] ?? <dynamic>[];

    // Form the received dynamic Lists of bookedTransactions and
    // pendingTransactions into Lists<TransactionData> for convenience.
    return <String, List<TransactionData>>{
      'booked': bookedTransactions
          .map<TransactionData>(
              (dynamic transaction) => TransactionData.fromMap(transaction))
          .toList(),
      'pending': pendingTransactions
          .map<TransactionData>(
              (dynamic transaction) => TransactionData.fromMap(transaction))
          .toList(),
    };
  }

  /// Get Balances of the Bank Account identified by [accountID]
  /// as [List] of [Balance].
  ///
  /// Refer to Step 6 of Nordigen Account Information API documentation.
  Future<List<Balance>> getAccountBalances({
    required String accountID,
  }) async {
    assert(accountID.isNotEmpty);
    // Make GET request and fetch output.
    final dynamic fetched = await _nordigenGetter(
      endpointUrl: 'https://ob.nordigen.com/api/accounts/$accountID/balances/',
    );
    final List<dynamic> fetchedData = fetched['balances'] ?? <dynamic>[];
    // Form the recieved dynamic Map into BankAccountDetails for convenience.
    return fetchedData
        .map<Balance>((dynamic balanceMap) => Balance.fromMap(balanceMap))
        .toList();
  }

  /// Generate headers for requests.
  Map<String, String> get _headers => <String, String>{
        'accept': 'application/json',
        'Content-Type': 'application/json',
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
    final Uri requestURL = Uri.parse(endpointUrl);
    http.Response response;
    if (requestType == 'PUT')
      response = await _client.put(
        requestURL,
        headers: _headers,
        body: jsonEncode(data),
      );
    else
      response = await _client.post(
        requestURL,
        headers: _headers,
        body: jsonEncode(data),
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

  /// Utility class to easily make GET requests to Nordigen API endpoints.
  Future<dynamic> _nordigenGetter({required String endpointUrl}) async {
    final Uri requestURL = Uri.parse(endpointUrl);
    final http.Response response = await _client.get(
      requestURL,
      headers: <String, String>{
        'accept': 'application/json',
        'Authorization': 'Bearer $_accessToken',
      },
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

  /// Utility class to easily make DELETE requests to Nordigen API endpoints.
  Future<dynamic> _nordigenDeleter({required String endpointUrl}) async {
    final Uri requestURL = Uri.parse(endpointUrl);
    final http.Response response = await _client.delete(
      requestURL,
      headers: _headers,
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
