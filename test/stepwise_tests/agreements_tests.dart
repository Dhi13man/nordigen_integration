import 'package:http/http.dart' show ClientException;
import 'package:test/test.dart';

import 'package:nordigen_integration/nordigen_integration.dart';

/// Tests associated with Step 3 of Nordigen API integration.
///
/// Pass in Nordigen Access Token [nordigenObject], [testEndUserID],
/// [testInstitutionID] to the function.
void agreementsTests({
  required NordigenAccountInfoAPI nordigenObject,
  required String testEndUserID,
  required String testInstitutionID,
}) {
  /// TEST 3.1
  test(
    'Step 3: Create an End-User Agreement: [createEndUserAgreement]',
    () async {
      const int maxHistoricalDays = 1, accessValidForDays = 2;

      // TEST creation
      final EndUserAgreementModel endUserAgreementModel =
          await nordigenObject.createEndUserAgreement(
        maxHistoricalDays: maxHistoricalDays,
        accessValidForDays: accessValidForDays,
        institutionID: testInstitutionID,
      );
      // Data Integrity check
      expect(endUserAgreementModel.institutionID, testInstitutionID);
      expect(endUserAgreementModel.maxHistoricalDays, maxHistoricalDays);
      expect(endUserAgreementModel.accessValidForDays, accessValidForDays);
    },
  );

  /// TEST 3.1
  test(
    'Cross-Validate [createEndUserAgreement] and [acceptEndUserAgreement]',
    () async {
      final EndUserAgreementModel endUserAgreementModelCreated =
          await nordigenObject.createEndUserAgreement(
        institutionID: testInstitutionID,
      );
      // TODO: Need a proper ipAddress, Agent with permission to test this.
      final EndUserAgreementModel endUserAgreementModelAccepted =
          await nordigenObject.acceptEndUserAgreement(
        endUserAgreementID: endUserAgreementModelCreated.id,
        ipAddress: 'test',
        userAgent: 'test',
      );

      // Data Integrity check
      expect(
        endUserAgreementModelCreated.toString(),
        endUserAgreementModelAccepted.toString(),
      );
    },
  );

  /// TEST 3.2
  test(
    'GET all Agreements with limit: [getEndUserAgreements]',
    () async {
      const int limit = 2;
      // TEST creation
      final List<EndUserAgreementModel> endUserAgreementModels =
          await nordigenObject.getEndUserAgreements(limit: limit);
      // List should not be empty as Step 3 makes a End-User Agreement
      expect(endUserAgreementModels.isEmpty, false);
      // Verify end user ID of the first End-User Agreement. Integrity Check.
      expect(endUserAgreementModels.length, lessThanOrEqualTo(limit));
    },
  );

  /// TEST 3.3
  test(
    'GET and DELETE a End-User Agreement by ID: [getEndUserAgreementUsingID]'
    ' and [deleteEndUserAgreementUsingID]',
    () async {
      final EndUserAgreementModel endUserAgreement =
          await nordigenObject.createEndUserAgreement(
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
