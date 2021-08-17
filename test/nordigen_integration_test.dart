import 'package:flutter_test/flutter_test.dart';

import 'stepwise_tests/step_2_tests.dart';
import 'stepwise_tests/step_3_tests.dart';
import 'stepwise_tests/step_4_tests.dart';

import 'package:nordigen_integration/nordigen_integration.dart';

import 'stepwise_tests/step_5_tests.dart';
import 'stepwise_tests/step_6_tests.dart';

void main() {
  // Set up of common parameters for Testing.
  // TODO: MAKE SURE TO FILL THIS IN BEFORE RUNNING UNIT TESTS.
  const String accessToken = 'YOUR_TOKEN';
  const String testEndUserID = '8234e18b-f360-48cc-8bcf-c8625596d74a';
  const String testAspspID = 'ABNAMRO_ABNAGB2LXXX';
  const String testRedirectLink = 'http://www.yourwebpage.com/';
  const String requisitionIDWithAccountAccess =
      'REQUISITION_WITH_ACCOUNT_ACCESS';

  /// TEST 0
  test(
    'Ensure that Access Token is changed before actual tests.',
    () => expect(accessToken != 'YOUR_TOKEN', true),
  );

  /// TEST 1
  test('Simulate Step 1: Initialize with Access Token', () {
    bool isClassInitSuccessful = true;
    try {
      NordigenAccountInfoAPI(accessToken: accessToken);
    } catch (_) {
      isClassInitSuccessful = false;
    }
    // API set up should not have any exceptions.
    expect(isClassInitSuccessful, true);
  });

  /// TEST 2
  step2Tests(accessToken: accessToken);

  /// TEST 3
  step3Tests(
    accessToken: accessToken,
    testEndUserID: testEndUserID,
    testAspspID: testAspspID,
  );

  /// TEST 4
  step4Tests(
    accessToken: accessToken,
    testEndUserID: testEndUserID,
    testAspspID: testAspspID,
    testRedirectLink: testRedirectLink,
  );

  /// TEST 5
  step5Tests(
    accessToken: accessToken,
    testEndUserID: testEndUserID,
    testRedirectLink: testRedirectLink,
    requisitionIDWithAccountAccess: requisitionIDWithAccountAccess,
  );

  /// TEST 6
  step6Tests(
    accessToken: accessToken,
    requisitionIDWithAccountAccess: requisitionIDWithAccountAccess,
  );
}
