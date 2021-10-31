import 'package:test/test.dart';

import 'package:nordigen_integration/nordigen_integration.dart';

import '../utilities/create_random_requisition.dart';

/// Tests associated with Step 5 of Nordigen API integration.
///
/// Pass in Nordigen Access Token [nordigenObject], [testEndUserID],
/// [testRedirectLink], [requisitionIDWithAccountAccess] to the function.
void step5Tests({
  required NordigenAccountInfoAPI nordigenObject,
  required String requisitionIDWithAccountAccess,
  required String testInstitutionID,
  required String testRedirectLink,
}) {
  /// TEST 5.1
  test(
    'List accounts from Random Accountless Requisition: [getEndUserAccountIDs]',
    () async {
      // Create a Random Requisition
      final RequisitionModel requisitionModel = await createRandomRequisition(
        nordigenObject,
        testInstitutionID,
        testRedirectLink,
      );
      // Make Request
      final List<String> accountsIDs =
          await nordigenObject.getEndUserAccountIDs(
        requisitionID: requisitionModel.id,
      );
      // The random requisition has no accounts.
      expect(accountsIDs.isEmpty, true);
      await nordigenObject.deleteRequisitionUsingID(
        requisitionID: requisitionModel.id,
      );
    },
  );

  /// TEST 5.2
  test(
    'List accounts from Requisition with Accounts: [getEndUserAccountIDs]',
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
