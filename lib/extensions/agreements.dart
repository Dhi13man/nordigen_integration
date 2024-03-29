part of 'package:nordigen_integration/nordigen_integration.dart';

extension NordigenAgreementsEndpoints on NordigenAccountInfoAPI {
  /// Create an End User Agreement for given Institution identified
  /// by [institutionID], account access period for given [accessValidForDays]
  /// and [maxHistoricalDays] of transaction histoy (default 90 days each).
  ///
  /// The aggreement can have scopes given by ([List]) [accessScope] which can
  /// only contain values 'balances', 'details' or 'transactions'. (defaults to
  /// all 3). Throws [ArgumentError] if [accessScope] contains invalid values.
  ///
  /// Refer to Step 3 of Nordigen Account Information API documentation.
  Future<EndUserAgreementModel> createEndUserAgreement({
    required String institutionID,
    int maxHistoricalDays = 90,
    int accessValidForDays = 90,
    List<String> accessScope = const <String>[
      'balances',
      'details',
      'transactions',
    ],
  }) async {
    // Validate [accessScope]. Only 'balances', 'details' and 'transactions'
    if (accessScope.any(
      (String scope) =>
          scope != 'balances' && scope != 'details' && scope != 'transactions',
    )) {
      throw ArgumentError(
        'Invalid accessScope value. '
        'Only values \'balances\', \'details\', \'transactions\' are allowed.',
      );
    }

    // Make POST request and fetch output.
    final dynamic fetchedData = await _nordigenPoster(
      endpointUrl: 'https://bankaccountdata.gocardless.com/api/v2/agreements/enduser/',
      data: <String, dynamic>{
        // API accepts days as String
        'max_historical_days': maxHistoricalDays.toString(),
        'access_valid_for_days': accessValidForDays,
        'institution_id': institutionID,
        'access_scope': accessScope,
      },
    );
    // Form the recieved dynamic Map into EndUserAgreementModel for convenience.
    return EndUserAgreementModel.fromMap(fetchedData);
  }

  /// Accept an End User Agreement identified by [endUserAgreementID].
  ///
  /// Accepts the user agreement using given [userAgent] and [ipAddress]. This
  /// determine whether you have permission to accept the Agreement or not.
  /// Will throw a Error Code 403 (You do not have permission to perform this
  /// action) otherwise.
  ///
  /// https://nordigen.com/en/account_information_documenation/integration/parameters-and-responses/#/agreements/accept%20EUA
  Future<EndUserAgreementModel> acceptEndUserAgreement({
    required String endUserAgreementID,
    required String ipAddress,
    required String userAgent,
  }) async {
    // Make POST request and fetch output.
    final dynamic fetchedData = await _nordigenPoster(
      endpointUrl:
          'https://bankaccountdata.gocardless.com/api/v2/agreements/enduser/$endUserAgreementID/accept/',
      data: <String, dynamic>{
        'user_agent': userAgent,
        'ip_address': ipAddress,
      },
      requestType: 'PUT',
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
    // Make GET request and fetch output.
    final dynamic fetchedData = await _nordigenGetter(
      endpointUrl:
          'https://bankaccountdata.gocardless.com/api/v2/agreements/enduser/$endUserAgreementID/',
    );
    // Form the recieved dynamic Map into RequisitionModel for convenience.
    return EndUserAgreementModel.fromMap(fetchedData);
  }

  /// Show the text of end-user agreement identified by [endUserAgreementID].
  ///
  /// https://nordigen.com/en/account_information_documenation/integration/parameters-and-responses/#/agreements/retrieve%20EUA%20text
  Future<dynamic> getEndUserAgreementTextUsingID({
    required String endUserAgreementID,
  }) async {
    // Make GET request and fetch output.
    final dynamic fetchedData = await _nordigenGetter(
      endpointUrl:
          'https://bankaccountdata.gocardless.com/api/v2/agreements/enduser/$endUserAgreementID/text/',
    );
    return fetchedData;
  }

  /// Get all the End-User Agreements.
  ///
  /// Limited by [limit] (defaults to 100). [offset] (defaults to 0) gives which
  /// index of Agreements to start from.
  Future<List<EndUserAgreementModel>> getEndUserAgreements({
    int limit = 100,
    int offset = 0,
  }) async {
    // Make GET request and fetch output.
    final Map<String, dynamic> fetchedData = await _nordigenGetter(
      endpointUrl:
          'https://bankaccountdata.gocardless.com/api/v2/agreements/enduser/?limit=$limit&offset=$offset',
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
  Future<Map<String, dynamic>> deleteEndUserAgreementUsingID({
    required String endUserAgreementID,
  }) async =>
      await _nordigenDeleter(
        endpointUrl:
            'https://bankaccountdata.gocardless.com/api/v2/agreements/enduser/$endUserAgreementID/',
      );
}
