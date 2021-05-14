import 'dart:math';

import 'package:flutter_test/flutter_test.dart';

import 'package:nordigen_integration/nordigen_integration.dart';

/// Requisition of random reference ID is generated for testing purpose.
///
/// Needs a [nordigenObject] for API access, [testEndUserID] and
/// [testRedirectLink] for [RequisitionModel] fetching from Nordigen Server.s
Future<RequisitionModel> _createRandomRequisition(
  NordigenAccountInfoAPI nordigenObject,
  String testEndUserID,
  String testRedirectLink,
) async {
  final String randomReference = Random().nextInt(99999999).toString();
  final RequisitionModel requisitionModel =
      await nordigenObject.createRequisition(
    endUserID: testEndUserID,
    redirect: testRedirectLink,
    reference: randomReference,
  );
  expect(requisitionModel.reference, randomReference);
  return requisitionModel;
}

void main() {
  // Set up of common parameters for Testing.
  // TODO: MAKE SURE TO FILL THIS IN BEFORE RUNNING UNIT TESTS.
  const String accessToken = 'YOUR_TOKEN';
  const String testEndUserID = '8234e18b-f360-48cc-8bcf-c8625596d74a';
  const String testAspspID = 'ABNAMRO_ABNAGB2LXXX';
  const String testRedirectLink = 'http://www.yourwebpage.com/';

  /// TEST 0
  test(
    'Ensure that Access Token is changed before actual tests.',
    () => expect(accessToken != 'YOUR_TOKEN', true),
  );

  /// TEST 1
  test('Simulate Step 1: Initialize with Access Token', () {
    bool isClassInitSuccessful = true;
    try {
      NordigenAccountInfoAPI(accessToken: accessToken);
    } catch (_) {
      isClassInitSuccessful = false;
    }
    expect(isClassInitSuccessful, true);
  });

  /// TEST 2
  test('Simulate Step 2: Choose a Bank', () async {
    // API and Parameters Set up
    final NordigenAccountInfoAPI nordigenObject =
        NordigenAccountInfoAPI(accessToken: accessToken);
    // Make Request
    final List<ASPSP> aspsps =
        await nordigenObject.getBanksForCountry(countryCode: 'gb');
    expect(aspsps.isNotEmpty, true);
  });

  /// TEST 3
  test('Simulate Step 3: Create an End-User Agreement', () async {
    // API and Parameters Set up
    final NordigenAccountInfoAPI nordigenObject =
        NordigenAccountInfoAPI(accessToken: accessToken);
    const int maxHistoricalDays = 1;

    // TEST USING PURE ASPSP ID
    EndUserAgreementModel endUserAgreementModel =
        await nordigenObject.createEndUserAgreement(
      maxHistoricalDays: maxHistoricalDays,
      endUserID: testEndUserID,
      aspspID: testAspspID,
    );
    expect(endUserAgreementModel.endUserID, testEndUserID);
    expect(endUserAgreementModel.aspspID, testAspspID);
    expect(endUserAgreementModel.maxHistoricalDays, maxHistoricalDays);

    // TEST USING ASPSP Data Model object
    endUserAgreementModel = await nordigenObject.createEndUserAgreement(
      maxHistoricalDays: maxHistoricalDays,
      endUserID: testEndUserID,
      aspsp: const ASPSP(id: testAspspID, name: '', countries: <String>[]),
    );
    expect(endUserAgreementModel.aspspID, testAspspID);
  });

  /// TEST 4.1
  test('Simulate Step 4.1: Create a Requisition', () async {
    // API Set up
    final NordigenAccountInfoAPI nordigenObject =
        NordigenAccountInfoAPI(accessToken: accessToken);
    // Create a Random Requisition
    final RequisitionModel requisitionModel = await _createRandomRequisition(
      nordigenObject,
      testEndUserID,
      testRedirectLink,
    );
    expect(requisitionModel.endUserID, testEndUserID);
    expect(requisitionModel.redirectURL, testRedirectLink);
  });

  /// TEST 4.2
  test('Simulate Step 4.2: Build a Link', () async {
    // API Set up
    final NordigenAccountInfoAPI nordigenObject =
        NordigenAccountInfoAPI(accessToken: accessToken);
    // Create a Random Requisition
    final RequisitionModel requisitionModel = await _createRandomRequisition(
      nordigenObject,
      testEndUserID,
      testRedirectLink,
    );
    // Make Request
    final String fetchedRedirectLink =
        await nordigenObject.fetchRedirectLinkForRequisition(
      aspspID: testAspspID,
      requisition: requisitionModel,
    );
    expect(Uri.tryParse(fetchedRedirectLink) != null, true);
  });

  /// TEST 5.1
  test('Simulate Getting Requisition from Server.', () async {
    // API Set up
    final NordigenAccountInfoAPI nordigenObject =
        NordigenAccountInfoAPI(accessToken: accessToken);
    // Create a Random Requisition
    final RequisitionModel requisitionModel = await _createRandomRequisition(
      nordigenObject,
      testEndUserID,
      testRedirectLink,
    );
    // Make Request
    final RequisitionModel fetchedRequisitionModel =
        await nordigenObject.getRequisition(requisitionID: requisitionModel.id);
    // Kind of like Equatable Package
    expect(fetchedRequisitionModel.toString(), requisitionModel.toString());
  });

  /// TEST 5.2
  test('Simulate Step 5: List accounts', () async {
    // API Set up
    final NordigenAccountInfoAPI nordigenObject =
        NordigenAccountInfoAPI(accessToken: accessToken);
    // Create a Random Requisition
    final RequisitionModel requisitionModel = await _createRandomRequisition(
      nordigenObject,
      testEndUserID,
      testRedirectLink,
    );
    // Make Request
    await nordigenObject.getEndUserAccountIDs(
      requisitionID: requisitionModel.id,
    );
  });

  /// TEST 6
  test('Simulate Step 6: Access accounts, balances, and transactions',
      () async {
    // API Set up
    final NordigenAccountInfoAPI nordigenObject =
        NordigenAccountInfoAPI(accessToken: accessToken);
    // Create a Random Requisition
    final RequisitionModel requisitionModel = await _createRandomRequisition(
      nordigenObject,
      testEndUserID,
      testRedirectLink,
    );
    // Make Request
    await nordigenObject.getEndUserAccountIDs(
      requisitionID: requisitionModel.id,
    );
    // TODO: Create Banking account and Test Account APIs using its account ID.
    // Eg. nordigenObject.getAccountBalances(accountID: accountID)
  });
}
