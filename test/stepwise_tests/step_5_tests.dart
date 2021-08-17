import 'package:flutter_test/flutter_test.dart';

import '../utilities/create_random_requisition.dart';

import 'package:nordigen_integration/nordigen_integration.dart';

/// Tests associated with Step 5 of Nordigen API integration.
///
/// Pass in Nordigen Access Token [accessToken], [testEndUserID],
/// [testRedirectLink], [requisitionIDWithAccountAccess] to the function.
void step5Tests({
  required String accessToken,
  required String testEndUserID,
  required String testRedirectLink,
  required String requisitionIDWithAccountAccess,
}) {
  /// TEST 5.1
  test('GET Multiple Requisitions from Server.', () async {
    // API and Parameters Set up
    final NordigenAccountInfoAPI nordigenObject =
        NordigenAccountInfoAPI(accessToken: accessToken);
    const int limit = 100, offset = 0;
    // Create a Random Requisition
    await createRandomRequisition(
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
    // Make Request
    final List<String> accountsIDs = await nordigenObject.getEndUserAccountIDs(
      requisitionID: requisitionIDWithAccountAccess,
    );
    expect(accountsIDs.isNotEmpty, true);
  });
}
