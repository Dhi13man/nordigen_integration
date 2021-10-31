import 'package:http/http.dart' show ClientException;
import 'package:test/test.dart';

import 'package:nordigen_integration/nordigen_integration.dart';

/// Tests associated with Step 3 of Nordigen API integration.
///
/// Pass in Nordigen Access Token [nordigenObject], [testEndUserID],
/// [testInstitutionID] to the function.
void step3Tests({
  required NordigenAccountInfoAPI nordigenObject,
  required String testEndUserID,
  required String testInstitutionID,
}) {
  /// TEST 3.1
  test(
    'Create an End-User Agreement: [createEndUserAgreement]',
    () async {
      const int maxHistoricalDays = 1;

      // TEST creation
      final EndUserAgreementModel endUserAgreementModel =
          await nordigenObject.createEndUserAgreement(
        maxHistoricalDays: maxHistoricalDays,
        endUserID: testEndUserID,
        institutionID: testInstitutionID,
      );
      // Data Integrity check
      expect(endUserAgreementModel.endUserID, testEndUserID);
      expect(endUserAgreementModel.institutionID, testInstitutionID);
      expect(endUserAgreementModel.maxHistoricalDays, maxHistoricalDays);
      expect(endUserAgreementModel.institutionID, testInstitutionID);
    },
  );

  /// TEST 3.2
  test(
    'GET all Agreements for User: [getEndUserAgreementsUsingUserID]',
    () async {
      // TEST creation
      final List<EndUserAgreementModel> endUserAgreementModels =
          await nordigenObject.getEndUserAgreementsUsingUserID(
        endUserID: testEndUserID,
      );
      // List should not be empty as Step 3 makes a End-User Agreement
      expect(endUserAgreementModels.isEmpty, false);
      // Verify end user ID of the first End-User Agreement. Integrity Check.
      expect(endUserAgreementModels[0].endUserID, testEndUserID);
    },
  );

  /// TEST 3.3
  test(
    'GET and DELETE a End-User Agreement by ID: [getEndUserAgreementUsingID]'
    ' and [deleteEndUserAgreementUsingID]',
    () async {
      final EndUserAgreementModel endUserAgreement =
          await nordigenObject.createEndUserAgreement(
        endUserID: testEndUserID,
        institutionID: testInstitutionID,
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
    },
  );
}
