import 'dart:math';

import 'package:test/test.dart';

import 'package:nordigen_integration/nordigen_integration.dart';

/// Requisition of random reference ID is generated for testing purpose.
///
/// Needs a [nordigenObject] for API access, [testInstitutionID] and
/// [testRedirectLink] for [RequisitionModel] fetching from Nordigen Server.s
Future<RequisitionModel> createRandomRequisition(
  NordigenAccountInfoAPI nordigenObject,
  String testInstitutionID,
  String testRedirectLink,
) async {
  final String randomReference = Random().nextInt(99999999).toString();
  final RequisitionModel requisitionModel =
      await nordigenObject.createRequisitionandBuildLink(
    institutionID: testInstitutionID,
    redirect: testRedirectLink,
    reference: randomReference,
  );
  // Integrity check
  expect(requisitionModel.reference, randomReference);
  return requisitionModel;
}
