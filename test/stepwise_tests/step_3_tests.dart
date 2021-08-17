import 'package:flutter_test/flutter_test.dart';

import 'package:http/http.dart' show ClientException;

import 'package:nordigen_integration/nordigen_integration.dart';

/// Tests associated with Step 3 of Nordigen API integration.
/// 
/// Pass in Nordigen Access Token [accessToken], [testEndUserID], [testAspspID]
/// to the function.
void step3Tests(String accessToken, String testEndUserID, String testAspspID) {
  /// TEST 3.1
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
    // Data Integrity check
    expect(endUserAgreementModel.endUserID, testEndUserID);
    expect(endUserAgreementModel.aspspID, testAspspID);
    expect(endUserAgreementModel.maxHistoricalDays, maxHistoricalDays);
    expect(endUserAgreementModel.aspspID, testAspspID);
  });

  /// TEST 3.2
  test(
    'Simulate Step 3: Get all End-User Agreements associated with User',
    () async {
      // API and Parameters Set up
      final NordigenAccountInfoAPI nordigenObject =
          NordigenAccountInfoAPI(accessToken: accessToken);

      // TEST creation
      List<EndUserAgreementModel> endUserAgreementModels = await nordigenObject
          .getEndUserAgreementsUsingUserID(endUserID: testEndUserID);
      // List should not be empty as Step 3 makes a End-User Agreement
      expect(endUserAgreementModels.isEmpty, false);
      // Verify end user ID of the first End-User Agreement. Integrity Check.
      expect(endUserAgreementModels[0].endUserID, testEndUserID);
    },
  );

  /// TEST 3.3
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
    // Integrity check
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
}
