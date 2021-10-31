import 'package:http/http.dart' show ClientException;
import 'package:test/test.dart';

import '../utilities/create_random_requisition.dart';

import 'package:nordigen_integration/nordigen_integration.dart';

/// Tests associated with Step 4 of Nordigen API integration.
///
/// Pass in Nordigen Access Token [nordigenObject], [testEndUserID],
/// [testInstitutionID], [testRedirectLink] to the function.
void step4Tests({
  required NordigenAccountInfoAPI nordigenObject,
  required String testEndUserID,
  required String testInstitutionID,
  required String testRedirectLink,
}) {
  /// TEST 4.1
  test(
    '4.1: Create a Requisition: [createRandomRequisition]',
    () async {
      // Create a Random Requisition
      final RequisitionModel requisitionModel = await createRandomRequisition(
        nordigenObject,
        testEndUserID,
        testRedirectLink,
      );
      // Integrity checks
      expect(requisitionModel.endUserID, testEndUserID);
      expect(requisitionModel.redirectURL, testRedirectLink);
    },
  );

  /// TEST 4.2
  test(
    '4.2: Build a Link: [fetchRedirectLinkForRequisition]',
    () async {
      // Create a Random Requisition
      final RequisitionModel requisitionModel = await createRandomRequisition(
        nordigenObject,
        testEndUserID,
        testRedirectLink,
      );
      // Make Request
      final String fetchedRedirectLink =
          await nordigenObject.fetchRedirectLinkForRequisition(
        institutionID: testInstitutionID,
        requisitionID: requisitionModel.id,
      );
      expect(Uri.tryParse(fetchedRedirectLink) != null, true);
    },
  );

  /// TEST 4.3
  test(
    'GET and DELETE a single Requisition by ID: [getRequisitionUsingID]'
    ' and [deleteRequisitionUsingID]',
    () async {
      // Create a Random Requisition
      final RequisitionModel requisitionModel = await createRandomRequisition(
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
    },
  );
}
