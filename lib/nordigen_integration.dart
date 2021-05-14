library nordigen_integration;

import 'dart:convert';

import 'package:meta/meta.dart';
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

  /// Client initialization as we repeated requests to the same Server.
  final http.Client _client = http.Client();

  /// Gets the ASPSPs (Banks) for the given [countryCode].
  ///
  /// Refer to Step 2 of Nordigen Account Information API documentation.
  /// [countryCode] is just two-letter country code (ISO 3166).
  Future<List<ASPSP>> getBanksForCountry({@required String countryCode}) async {
    assert(countryCode != null && countryCode.isNotEmpty);
    // Make GET request and fetch output.
    final List<dynamic> fetchedMap = await _nordigenGetter(
      endpointUrl: 'https://ob.nordigen.com/api/aspsps/?country=$countryCode',
    ) as List<dynamic>;
    // Map the recieved List<dynamic> into List<ASPSP> Data Format.
    return fetchedMap
        .map<ASPSP>(
          (dynamic aspspMapItem) => ASPSP.fromMap(aspspMapItem),
        )
        .toList();
  }

  /// Create an End User Agreement for the given [endUserID], [aspspID]
  /// (or [aspsp]) and for the given [maxHistoricalDays] (default 90 days).
  ///
  /// Refer to Step 3 of Nordigen Account Information API documentation.
  ///
  /// Both [aspspID] and [aspsp] can not be NULL.
  /// If both are NOT NULL, ID of [aspsp] will be prefereed.
  Future<EndUserAgreementModel> createEndUserAgreement({
    @required String endUserID,
    String aspspID,
    ASPSP aspsp,
    int maxHistoricalDays = 90,
  }) async {
    // Prepare the ASPSP ID that the function will work with
    assert(aspspID != null || (aspsp != null && aspsp.id != null));
    final String workingAspspID = aspsp?.id ?? aspspID;
    // Make POST request and fetch output.
    final dynamic fetchedMap = await _nordigenPoster(
      endpointUrl: 'https://ob.nordigen.com/api/agreements/enduser/',
      data: <String, dynamic>{
        // API accepts days as String
        'max_historical_days': maxHistoricalDays.toString(),
        'aspsp_id': workingAspspID,
        'enduser_id': endUserID,
      },
    );
    // Form the recieved dynamic Map into EndUserAgreementModel for convenience.
    return EndUserAgreementModel.fromMap(fetchedMap);
  }

  /// Create a Requisition for the given [endUserID].
  ///
  /// Refer to Step 4.1 of Nordigen Account Information API documentation.
  ///
  /// [reference] is additional layer of unique ID. Should match Step 3 if done.
  /// [redirect] is the link where the end user will be redirected after
  /// finishing authentication in ASPSP.
  /// [agreements] is as an array of ID(s) from Step 3 or empty array
  /// if that step was skipped.
  Future<RequisitionModel> createRequisition({
    @required String endUserID,
    @required String redirect,
    @required String reference,
    List<String> agreements = const <String>[],
  }) async {
    assert(endUserID != null && redirect != null && reference != null);
    // Make POST request and fetch output.
    final dynamic fetchedMap = await _nordigenPoster(
      endpointUrl: 'https://ob.nordigen.com/api/requisitions/',
      data: <String, dynamic>{
        'redirect': redirect,
        'reference': reference,
        'enduser_id': endUserID,
        'agreements': agreements,
      },
    );
    // Form the recieved dynamic Map into RequisitionModel for convenience.
    return RequisitionModel.fromMap(fetchedMap);
  }

  /// Provides a redirect link to the Requisition passed in.
  ///
  /// Refer to Step 4.2 of Nordigen Account Information API documentation.
  ///
  /// Both [aspspID] and [aspsp] can not be NULL.
  /// If both are NOT NULL, ID of [aspsp] will be prefereed.
  ///
  /// Both [requisitionID] and [requisition] can not be NULL.
  /// If both are NOT NULL, ID of [requisition] will be prefereed.
  Future<String> fetchRedirectLinkForRequisition({
    String aspspID,
    String requisitionID,
    ASPSP aspsp,
    RequisitionModel requisition,
  }) async {
    // Prepare the ASPSP ID that the function will work with
    assert(aspspID != null || (aspsp != null && aspsp.id != null));
    final String workingAspspID = aspsp?.id ?? aspspID;
    // Prepare the Requisition ID that the function will work with
    assert(
      requisitionID != null || (requisition != null && requisition.id != null),
    );
    final String workingRequisitionID = requisition?.id ?? requisitionID;
    // Make POST request and fetch output.
    final dynamic fetchedMap = await _nordigenPoster(
      endpointUrl:
          'https://ob.nordigen.com/api/requisitions/$workingRequisitionID/links/',
      data: <String, dynamic>{'aspsp_id': workingAspspID},
    );
    // Extract the redirectURL and output it.
    return fetchedMap['initiate'].toString();
  }

  /// Get the Requisition identified by [requisitionID].
  ///
  /// Refer to Step 5 of Nordigen Account Information API documentation.
  Future<RequisitionModel> getRequisition({
    @required String requisitionID,
  }) async {
    assert(requisitionID != null && requisitionID.isNotEmpty);
    // Make GET request and fetch output.
    final dynamic fetchedMap = await _nordigenGetter(
      endpointUrl: 'https://ob.nordigen.com/api/requisitions/$requisitionID/',
    );
    // Form the recieved dynamic Map into RequisitionModel for convenience.
    return RequisitionModel.fromMap(fetchedMap);
  }

  /// Get the Account IDs of the User,
  /// for the Requisition identified by [requisitionID].
  ///
  /// Uses [getRequisition] and then finds the accounts.
  ///
  /// Refer to Step 5 of Nordigen Account Information API documentation.
  Future<List<String>> getEndUserAccountIDs({
    @required String requisitionID,
  }) async =>
      (await getRequisition(requisitionID: requisitionID)).accounts;

  /// Get the Details of the Bank Account identified by [accountID].
  ///
  /// Refer to Step 6 of Nordigen Account Information API documentation.
  Future<BankAccountDetails> getAccountDetails({
    @required String accountID,
  }) async {
    assert(accountID != null && accountID.isNotEmpty);
    // Make GET request and fetch output.
    final dynamic fetchedMap = await _nordigenGetter(
      endpointUrl: 'https://ob.nordigen.com/api/accounts/$accountID/details/',
    );
    // Form the recieved dynamic Map into BankAccountDetails for convenience.
    return BankAccountDetails.fromMap(fetchedMap);
  }

  /// Get the Transactions of the Bank Account identified by [accountID].
  ///
  /// Refer to Step 6 of Nordigen Account Information API documentation.
  Future<TransactionData> getAccountTransactions({
    @required String accountID,
  }) async {
    assert(accountID != null && accountID.isNotEmpty);
    // Make GET request and fetch output.
    final dynamic fetchedMap = await _nordigenGetter(
      endpointUrl:
          'https://ob.nordigen.com/api/accounts/$accountID/transactions/',
    );
    // Form the recieved dynamic Map into TransactionData for convenience.
    return TransactionData.fromMap(fetchedMap);
  }

  /// Get Balances of the Bank Account identified by [accountID].
  ///
  /// Refer to Step 6 of Nordigen Account Information API documentation.
  Future<BankAccountDetails> getAccountBalances({
    @required String accountID,
  }) async {
    assert(accountID != null && accountID.isNotEmpty);
    // Make GET request and fetch output.
    final dynamic fetchedMap = await _nordigenGetter(
      endpointUrl: 'https://ob.nordigen.com/api/accounts/$accountID/balances/',
    );
    // Form the recieved dynamic Map into BankAccountDetails for convenience.
    return BankAccountDetails.fromMap(fetchedMap);
  }

  /// Utility class to easily make POST requests to Nordigen API endpoints.
  Future<dynamic> _nordigenPoster({
    @required String endpointUrl,
    Map<String, dynamic> data,
  }) async {
    dynamic output = <dynamic, dynamic>{};
    try {
      final Uri requestURL = Uri.parse(endpointUrl);
      final http.Response response = await _client.post(
        requestURL,
        headers: <String, String>{
          'accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Token $_accessToken',
        },
        body: jsonEncode(data),
      );
      if ((response.statusCode / 100).floor() == 2) // Request Success Condition
        output = jsonDecode(response.body);
      else
        throw http.ClientException(
          'Error Code: ${response.statusCode}, ' +
              'Reason: ${jsonDecode(response.body)["detail"]}',
        );
    } catch (e) {
      throw http.ClientException('POST Request Failed: $e');
    }
    return output;
  }

  /// Utility class to easily make GET requests to Nordigen API endpoints.
  Future<dynamic> _nordigenGetter({@required String endpointUrl}) async {
    dynamic output = <dynamic, dynamic>{};
    try {
      final Uri requestURL = Uri.parse(endpointUrl);
      final http.Response response = await _client.get(
        requestURL,
        headers: <String, String>{
          'accept': 'application/json',
          'Authorization': 'Token $_accessToken',
        },
      );
      if ((response.statusCode / 100).floor() == 2) // Request Success Condition
        output = jsonDecode(response.body);
      else
        throw http.ClientException(
          'Error Code: ${response.statusCode}, ' +
              'Reason: ${jsonDecode(response.body)["detail"]}',
        );
    } catch (e) {
      throw http.ClientException('GET Request Failed: $e');
    }
    return output;
  }
}
