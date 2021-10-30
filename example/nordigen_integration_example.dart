import 'package:nordigen_integration/nordigen_integration.dart';

Future<void> main() async {
  /// Step 1
  final NordigenAccountInfoAPI apiInterface = NordigenAccountInfoAPI(
    accessToken: 'YOUR_TOKEN',
  );

  /// Step 2 and then selecting the first Bank/Institution
  final Institution firstBank =
      (await apiInterface.getInstitutionsForCountry(countryCode: 'gb')).first;

  /// Step 4.1
  final RequisitionModel requisition = await apiInterface.createRequisition(
    endUserID: 'exampleEndUser',
    redirect: 'http://www.yourwebpage.com/',
    reference: 'exampleRef42069666',
  );

  /// Step 4.2
  final String redirectLink =
      await apiInterface.fetchRedirectLinkForRequisition(
    requisitionID: requisition.id,
    institutionID: firstBank.id,
  );

  /// Open and Validate [redirectLink] and proceed with other functionality.
  print(redirectLink);
}
