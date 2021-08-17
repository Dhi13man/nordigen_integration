import 'package:flutter_test/flutter_test.dart';

import 'package:http/http.dart' show ClientException;

import 'package:nordigen_integration/nordigen_integration.dart';

/// Tests associated with Step 6 of Nordigen API integration.
///
/// Pass in Nordigen Access Token [accessToken],
/// [requisitionIDWithAccountAccess] to the function.
void step6Tests({
  required String accessToken,
  required String requisitionIDWithAccountAccess,
}) {
  /// TEST 6.1
  test('Simulate Step 6: Access account meta data', () async {
    // API Set up
    final NordigenAccountInfoAPI nordigenObject =
        NordigenAccountInfoAPI(accessToken: accessToken);
    // GET accountsIDs
    final List<String> accountsIDs = await nordigenObject.getEndUserAccountIDs(
      requisitionID: requisitionIDWithAccountAccess,
    );
    final String accountID = accountsIDs[0];
    // GET Account Meta Data
    bool hasGetMetaDataFailed = false;
    try {
      await nordigenObject.getAccountMetaData(accountID: accountID);
    } on ClientException {
      hasGetMetaDataFailed = true;
    }
    // Getting Meta Data should not fail or throw an exception.
    expect(hasGetMetaDataFailed, false);
  });

  /// TEST 6.2
  test('Simulate Step 6: Access account details', () async {
    // API Set up
    final NordigenAccountInfoAPI nordigenObject =
        NordigenAccountInfoAPI(accessToken: accessToken);
    // GET accountsIDs
    final List<String> accountsIDs = await nordigenObject.getEndUserAccountIDs(
      requisitionID: requisitionIDWithAccountAccess,
    );
    final String accountID = accountsIDs[0];
    // Get Account Details
    bool hasGetDetailsFailed = false;
    try {
      await nordigenObject.getAccountDetails(accountID: accountID);
    } on ClientException {
      hasGetDetailsFailed = true;
    }
    // Getting Account Details should not fail or throw an exception.
    expect(hasGetDetailsFailed, false);
  });

  /// TEST 6.3
  test('Simulate Step 6: Access account balances', () async {
    // API Set up
    final NordigenAccountInfoAPI nordigenObject =
        NordigenAccountInfoAPI(accessToken: accessToken);
    // GET accountsIDs
    final List<String> accountsIDs = await nordigenObject.getEndUserAccountIDs(
      requisitionID: requisitionIDWithAccountAccess,
    );
    final String accountID = accountsIDs[3];
    // Get Account Details
    bool hasGetBalancesFailed = false;
    try {
      await nordigenObject.getAccountBalances(accountID: accountID);
    } on ClientException {
      hasGetBalancesFailed = true;
    }
    // Getting Account Balances should not fail or throw an exception.
    expect(hasGetBalancesFailed, false);
  });

  /// TEST 6.4
  test('Simulate Step 6: Access account transactions', () async {
    // API Set up
    final NordigenAccountInfoAPI nordigenObject =
        NordigenAccountInfoAPI(accessToken: accessToken);
    // GET accountsIDs
    final List<String> accountsIDs = await nordigenObject.getEndUserAccountIDs(
      requisitionID: requisitionIDWithAccountAccess,
    );
    final String accountID = accountsIDs[0];
    // Get Account Details
    bool hasGetTransactionsFailed = false;
    try {
      await nordigenObject.getAccountTransactions(accountID: accountID);
    } on ClientException {
      hasGetTransactionsFailed = true;
    }
    // Getting Account Transactions should not fail or throw an exception.
    expect(hasGetTransactionsFailed, false);
  });
}
