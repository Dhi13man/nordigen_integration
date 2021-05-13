import 'package:flutter_test/flutter_test.dart';

import 'package:nordigen_integration/nordigen_integration.dart';

void main() {
  // TODO: MAKE SURE TO FILL THIS IN BEFORE RUNNING UNIT TESTS.
  final String accessToken = 'YOUR_TOKEN';

  /// STEP 1
  test('Simulate Step 1: Initialize with Access Token', () {
    bool isClassInitSuccessful = true;
    try {
      NordigenAccountInfoAPI(accessToken: accessToken);
    } catch (_) {
      isClassInitSuccessful = false;
    }
    expect(isClassInitSuccessful, true);
  });

  /// STEP 2
  test('Simulate Step 2: Choose a Bank', () async {
    final NordigenAccountInfoAPI nordigenObject =
        NordigenAccountInfoAPI(accessToken: accessToken);
    final List<ASPSP> aspsps = await nordigenObject.getBanksForCountry('gb');
    expect(aspsps != null, true);
    expect(aspsps.length > 0, true);
    expect(aspsps.first.id != null, true);
  });

  /// STEP 3
  test('Simulate Step 3: Create an End-User Agreement', () async {
    final NordigenAccountInfoAPI nordigenObject =
        NordigenAccountInfoAPI(accessToken: accessToken);
    final int maxHistoricalDays = 1;
    final String endUserID = '8234e18b-f360-48cc-8bcf-c8625596d74a';
    final String aspspID = 'ABNAMRO_ABNAGB2LXXX';

    /// TEST USING PURE ASPSP ID
    EndUserAgreementModel endUserAgreementModel =
        await nordigenObject.createEndUserAgreement(
      maxHistoricalDays: maxHistoricalDays,
      endUserID: endUserID,
      aspspID: aspspID,
    );
    expect(endUserAgreementModel != null, true);
    expect(endUserAgreementModel.id != null, true);
    expect(endUserAgreementModel.endUserID, endUserID);
    expect(endUserAgreementModel.aspspID, aspspID);
    expect(endUserAgreementModel.maxHistoricalDays, maxHistoricalDays);

    /// TEST USING ASPSP Data Model object
    endUserAgreementModel = null;
    endUserAgreementModel = await nordigenObject.createEndUserAgreement(
      maxHistoricalDays: maxHistoricalDays,
      endUserID: endUserID,
      aspsp: ASPSP(id: aspspID),
    );
    expect(endUserAgreementModel != null, true);
    expect(endUserAgreementModel.id != null, true);
    expect(endUserAgreementModel.aspspID, aspspID);
  });
}
