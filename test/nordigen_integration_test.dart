import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' show ClientException;

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
  test('Simulate Step 2: Choose a Bank/ASPSP', () async {
    // API and Parameters Set up
    final NordigenAccountInfoAPI nordigenObject =
        NordigenAccountInfoAPI(accessToken: accessToken);
    // Make Request
    final List<ASPSP> aspsps =
        await nordigenObject.getASPSPsForCountry(countryCode: 'gb');
    expect(aspsps.isNotEmpty, true);
  });

  /// TEST 2.1
  test('GET a single ASPSP by ID', () async {
    // API and Parameters Set up
    final NordigenAccountInfoAPI nordigenObject =
        NordigenAccountInfoAPI(accessToken: accessToken);
    // Make Request
    final List<ASPSP> aspsps =
        await nordigenObject.getASPSPsForCountry(countryCode: 'gb');
    expect(aspsps.isNotEmpty, true);
    final ASPSP singleASPSP =
        await nordigenObject.getASPSPUsingID(aspspID: aspsps.first.id);
    expect(aspsps.first.toString(), singleASPSP.toString());
  });

  /// TEST 3
  test('Simulate Step 3: Create an End-User Agreement', () async {
    // API and Parameters Set up
    final NordigenAccountInfoAPI nordigenObject =
        NordigenAccountInfoAPI(accessToken: accessToken);
    const int maxHistoricalDays = 1;

    // TEST creation
    EndUserAgreementModel endUserAgreementModel =
        await nordigenObject.createEndUserAgreement(
      maxHistoricalDays: maxHistoricalDays,
      endUserID: testEndUserID,
      aspspID: testAspspID,
    );
    expect(endUserAgreementModel.endUserID, testEndUserID);
    expect(endUserAgreementModel.aspspID, testAspspID);
    expect(endUserAgreementModel.maxHistoricalDays, maxHistoricalDays);
    expect(endUserAgreementModel.aspspID, testAspspID);
  });

  /// TEST 3.1
  test('GET and DELETE a single End-User Agreement by ID', () async {
    // API and Parameters Set up
    final NordigenAccountInfoAPI nordigenObject =
        NordigenAccountInfoAPI(accessToken: accessToken);
    final EndUserAgreementModel endUserAgreement =
        await nordigenObject.createEndUserAgreement(
      endUserID: testEndUserID,
      aspspID: testAspspID,
    );
    // GET the created Agreement and compare.
    final EndUserAgreementModel fetchedEndUserAgreement =
        await nordigenObject.getEndUserAgreementUsingID(
      endUserAgreementID: endUserAgreement.id,
    );
    expect(fetchedEndUserAgreement.toString(), endUserAgreement.toString());
    // DELETE the created Agreement and check.
    await nordigenObject.deleteEndUserAgreementUsingID(
      endUserAgreementID: endUserAgreement.id,
    );
    bool hasRequestFailed = false;
    try {
      await nordigenObject.getEndUserAgreementUsingID(
        endUserAgreementID: endUserAgreement.id,
      );
    } on ClientException {
      hasRequestFailed = true;
    }
    expect(hasRequestFailed, true); // If successfully deleted, should fail.
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
      requisitionID: requisitionModel.id,
    );
    expect(Uri.tryParse(fetchedRedirectLink) != null, true);
  });

  /// TEST 4.3
  test('GET and DELETE a single Requisition by ID', () async {
    // API and Parameters Set up
    final NordigenAccountInfoAPI nordigenObject =
        NordigenAccountInfoAPI(accessToken: accessToken);
    // Create a Random Requisition
    final RequisitionModel requisitionModel = await _createRandomRequisition(
      nordigenObject,
      testEndUserID,
      testRedirectLink,
    );
    // GET the created Agreement and compare.
    final RequisitionModel fetchedRequisition = await nordigenObject
        .getRequisitionUsingID(requisitionID: requisitionModel.id);
    expect(requisitionModel.toString(), fetchedRequisition.toString());
    // DELETE the created Agreement and check.
    await nordigenObject.deleteRequisitionUsingID(
      requisitionID: requisitionModel.id,
    );
    bool hasRequestFailed = false;
    try {
      await nordigenObject.getRequisitionUsingID(
        requisitionID: requisitionModel.id,
      );
    } on ClientException {
      hasRequestFailed = true;
    }
    expect(hasRequestFailed, true); // If successfully deleted, should fail.
  });

  /// TEST 5.1
  test('GET Multiple Requisitions from Server.', () async {
    // API and Parameters Set up
    final NordigenAccountInfoAPI nordigenObject =
        NordigenAccountInfoAPI(accessToken: accessToken);
    const int limit = 100, offset = 0;
    // Create a Random Requisition
    await _createRandomRequisition(
      nordigenObject,
      testEndUserID,
      testRedirectLink,
    );
    // Make Request
    List<RequisitionModel> fetchedRequisitionModels =
        await nordigenObject.getRequisitions(limit: limit, offset: offset);
    // We should expect Requisitions less than or equal to (limit - offset)
    expect(
      fetchedRequisitionModels.isNotEmpty &&
          fetchedRequisitionModels.length <= limit - offset,
      true,
    );
  });

  /// TEST 5.2
  test('Simulate Step 5: List accounts from Specific Requisition', () async {
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
  test(
      'Simulate Step 6: Access account meta data, details, balances, and'
      ' transactions', () async {
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
