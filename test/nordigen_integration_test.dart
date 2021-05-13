import 'dart:math';

import 'package:flutter_test/flutter_test.dart';

import 'package:nordigen_integration/nordigen_integration.dart';

void main() {
  // TODO: MAKE SURE TO FILL THIS IN BEFORE RUNNING UNIT TESTS.
  final String accessToken = 'YOUR_TOKEN';

  /// STEP 1
  test('Simulate Step 1: Initialize with Access Token', () {
    bool isClassInitSuccessful = true;
    try {
      NordigenAccountInfoAPI(accessToken: accessToken);
    } catch (_) {
      isClassInitSuccessful = false;
    }
    expect(isClassInitSuccessful, true);
  });

  /// STEP 2
  test('Simulate Step 2: Choose a Bank', () async {
    final NordigenAccountInfoAPI nordigenObject =
        NordigenAccountInfoAPI(accessToken: accessToken);
    final List<ASPSP> aspsps = await nordigenObject.getBanksForCountry('gb');
    expect(aspsps != null, true);
    expect(aspsps.length > 0, true);
    expect(aspsps.first.id != null, true);
  });

  /// STEP 3
  test('Simulate Step 3: Create an End-User Agreement', () async {
    // Parameters Set up
    final NordigenAccountInfoAPI nordigenObject =
        NordigenAccountInfoAPI(accessToken: accessToken);
    final int maxHistoricalDays = 1;
    final String endUserID = '8234e18b-f360-48cc-8bcf-c8625596d74a';
    final String aspspID = 'ABNAMRO_ABNAGB2LXXX';

    // TEST USING PURE ASPSP ID
    EndUserAgreementModel endUserAgreementModel =
        await nordigenObject.createEndUserAgreement(
      maxHistoricalDays: maxHistoricalDays,
      endUserID: endUserID,
      aspspID: aspspID,
    );
    expect(endUserAgreementModel != null, true);
    expect(endUserAgreementModel.id != null, true);
    expect(endUserAgreementModel.endUserID, endUserID);
    expect(endUserAgreementModel.aspspID, aspspID);
    expect(endUserAgreementModel.maxHistoricalDays, maxHistoricalDays);

    // TEST USING ASPSP Data Model object
    endUserAgreementModel = null;
    endUserAgreementModel = await nordigenObject.createEndUserAgreement(
      maxHistoricalDays: maxHistoricalDays,
      endUserID: endUserID,
      aspsp: ASPSP(id: aspspID),
    );
    expect(endUserAgreementModel != null, true);
    expect(endUserAgreementModel.id != null, true);
    expect(endUserAgreementModel.aspspID, aspspID);
  });

  /// STEP 4.1
  test('Simulate Step 4.1: Create a Requisition', () async {
    // Parameters Set up
    final NordigenAccountInfoAPI nordigenObject =
        NordigenAccountInfoAPI(accessToken: accessToken);
    final String endUserID = '8234e18b-f360-48cc-8bcf-c8625596d74a';
    final String redirect = 'http://www.yourwebpage.com/';
    // Reference ID random generation for testing purpose
    final String reference = Random().nextInt(99999999).toString();
    final RequisitionModel requisitionModel =
        await nordigenObject.createRequisition(
      endUserID: endUserID,
      redirect: redirect,
      reference: reference,
    );
    expect(requisitionModel != null, true);
    expect(requisitionModel.id != null, true);
    expect(requisitionModel.endUserID, endUserID);
    expect(requisitionModel.redirectURL, redirect);
    expect(requisitionModel.reference, reference);
  });

  /// STEP 4.2
  test('Simulate Step 4.2: Build a Link', () async {
    // Parameters Set up
    final NordigenAccountInfoAPI nordigenObject =
        NordigenAccountInfoAPI(accessToken: accessToken);
    final String endUserID = '8234e18b-f360-48cc-8bcf-c8625596d74a';
    final String redirect = 'http://www.yourwebpage.com/';
    final String aspspID = 'ABNAMRO_ABNAGB2LXXX';
    // Reference ID random generation for testing purpose
    final String reference = Random().nextInt(99999999).toString();
    final RequisitionModel requisitionModel =
        await nordigenObject.createRequisition(
      endUserID: endUserID,
      redirect: redirect,
      reference: reference,
    );
    expect(requisitionModel != null, true);
    final String fetchedRedirectLink =
        await nordigenObject.fetchRedirectLinkForRequisition(
      aspspID: aspspID,
      requisition: requisitionModel,
    );
    expect(fetchedRedirectLink != null, true);
    expect(Uri.tryParse(fetchedRedirectLink) != null, true);
  });
}
