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

  /// Step 4.1
  final RequisitionModel requisition =
      await apiInterface.createRequisitionandBuildLink(
    agreement: '',
    institutionID: firstBank.id,
    redirect: 'http://www.yourwebpage.com/',
    reference: 'exampleRef42069666',
  );

  /// Open and Validate in [link] and proceed with other functionality.
  print(requisition.link);
}
