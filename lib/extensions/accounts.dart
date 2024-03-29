part of 'package:nordigen_integration/nordigen_integration.dart';

extension NordigenAccountsEndpoints on NordigenAccountInfoAPI {
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
      endpointUrl: 'https://bankaccountdata.gocardless.com/api/v2/accounts/$accountID/',
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
      endpointUrl:
          'https://bankaccountdata.gocardless.com/api/v2/accounts/$accountID/details/',
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
          'https://bankaccountdata.gocardless.com/api/v2/accounts/$accountID/transactions/',
    );
    // No Transactions retrieved case.
    if (fetchedData['transactions'] == null) {
      return <String, List<TransactionData>>{};
    }
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
      endpointUrl:
          'https://bankaccountdata.gocardless.com/api/v2/accounts/$accountID/balances/',
    );
    final List<dynamic> fetchedData = fetched['balances'] ?? <dynamic>[];
    // Form the recieved dynamic Map into BankAccountDetails for convenience.
    return fetchedData
        .map<Balance>((dynamic balanceMap) => Balance.fromMap(balanceMap))
        .toList();
  }
}
