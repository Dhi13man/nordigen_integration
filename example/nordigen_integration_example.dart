import 'package:nordigen_integration/nordigen_integration.dart';

Future<void> main() async {
  /// Step 1
  final NordigenAccountInfoAPI apiInterface =
      await NordigenAccountInfoAPI.fromSecret(
    secretID: 'secret_id',
    secretKey: 'secret_key',
  );

  /// Step 2 and then selecting the first Bank/Institution
  final Institution firstBank =
      (await apiInterface.getInstitutionsForCountry(countryCode: 'gb')).first;

  /// Step 3
  final EndUserAgreementModel endUserAgreementModel =
      await nordigenObject.createEndUserAgreement(
    maxHistoricalDays: 90,
    accessValidForDays: 90,
    institutionID: testInstitutionID,
  );

  /// Step 4
  final RequisitionModel requisition =
      await apiInterface.createRequisitionandBuildLink(
    agreement: endUserAgreementModel.id,
    institutionID: firstBank.id,
    redirect: 'http://www.yourwebpage.com/',
    reference: 'exampleRef42069666',
  );

  /// Open and Validate in [link] and proceed with other functionality.
  print(requisition.link);
}
