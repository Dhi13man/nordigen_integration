import 'dart:math';

import 'package:test/test.dart';

import 'package:nordigen_integration/nordigen_integration.dart';

/// Requisition of random reference ID is generated for testing purpose.
///
/// Needs a [nordigenObject] for API access, [testEndUserID] and
/// [testRedirectLink] for [RequisitionModel] fetching from Nordigen Server.s
Future<RequisitionModel> createRandomRequisition(
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
  // Integrity check
  expect(requisitionModel.reference, randomReference);
  return requisitionModel;
}
