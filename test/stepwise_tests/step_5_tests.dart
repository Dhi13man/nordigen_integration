import 'package:test/test.dart';

import '../utilities/create_random_requisition.dart';

import 'package:nordigen_integration/nordigen_integration.dart';

/// Tests associated with Step 5 of Nordigen API integration.
///
/// Pass in Nordigen Access Token [nordigenObject], [testEndUserID],
/// [testRedirectLink], [requisitionIDWithAccountAccess] to the function.
void step5Tests({
  required NordigenAccountInfoAPI nordigenObject,
  required String testEndUserID,
  required String testRedirectLink,
  required String requisitionIDWithAccountAccess,
}) {
  /// TEST 5.1
  test(
    'GET Multiple Requisitions from Server: [getRequisitions]',
    () async {
      const int limit = 100, offset = 0;
      // Create a Random Requisition
      await createRandomRequisition(
        nordigenObject,
        testEndUserID,
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

  /// TEST 5.2
  test(
    'List accounts from Specific Requisition: [getEndUserAccountIDs]',
    () async {
      // Make Request
      final List<String> accountsIDs =
          await nordigenObject.getEndUserAccountIDs(
        requisitionID: requisitionIDWithAccountAccess,
      );
      expect(accountsIDs.isNotEmpty, true);
    },
  );
}
