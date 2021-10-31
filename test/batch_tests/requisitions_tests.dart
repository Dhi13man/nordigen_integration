import 'package:http/http.dart' show ClientException;
import 'package:test/test.dart';

import '../utilities/create_random_requisition.dart';

import 'package:nordigen_integration/nordigen_integration.dart';

/// Tests associated with Step 4 of Nordigen API integration.
///
/// Pass in Nordigen Access Token [nordigenObject], [testInstitutionID],
/// [testRedirectLink] to the function.
void requisitionsTests({
  required NordigenAccountInfoAPI nordigenObject,
  required String testInstitutionID,
  required String testRedirectLink,
}) {
  /// TEST 4.1
  test(
    'Step 4: Build a Link: [createRequisitionandBuildLink]',
    () async {
      // Create a Random Requisition
      final RequisitionModel requisitionModel = await createRandomRequisition(
        nordigenObject,
        testInstitutionID,
        testRedirectLink,
      );
      // Integrity checks
      expect(requisitionModel.institutionID, testInstitutionID);
      expect(requisitionModel.redirectURL, testRedirectLink);
      expect(Uri.tryParse(requisitionModel.redirectURL) != null, true);
      expect(Uri.tryParse(requisitionModel.link) != null, true);
    },
  );

  /// TEST 4.23
  test(
    'GET and DELETE a single Requisition by ID: [getRequisitionUsingID]'
    ' and [deleteRequisitionUsingID]',
    () async {
      // Create a Random Requisition
      final RequisitionModel requisitionModel = await createRandomRequisition(
        nordigenObject,
        testInstitutionID,
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

  /// TEST 5.1
  test(
    'GET Multiple Requisitions from Server: [getRequisitions]',
    () async {
      const int limit = 100, offset = 0;
      // Create a Random Requisition
      await createRandomRequisition(
        nordigenObject,
        testInstitutionID,
        testRedirectLink,
      );

      // Make Request
      final List<RequisitionModel> fetchedRequisitionModels =
          await nordigenObject.getRequisitions(limit: limit, offset: offset);
      // We should expect Requisitions less than or equal to (limit - offset)
      expect(
        fetchedRequisitionModels.isNotEmpty &&
            fetchedRequisitionModels.length <= limit - offset,
        true,
      );
    },
  );
}
