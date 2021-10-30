import 'dart:io';

import 'package:test/test.dart';

import 'stepwise_tests/step_2_tests.dart';
import 'stepwise_tests/step_3_tests.dart';
import 'stepwise_tests/step_4_tests.dart';
import 'stepwise_tests/step_5_tests.dart';
import 'stepwise_tests/step_6_tests.dart';

import 'package:nordigen_integration/nordigen_integration.dart';

void main() {
// TODO: FILL NORDIGEN ACCESS TOKEN BEFORE RUNNING UNIT TESTS
  String accessToken = 'test';

  // Change API key from environment if tests are running on Github Actions.
  if ((Platform.environment['EXEC_ENV'] ?? '') == 'github_actions') {
    // If running on Github Actions, the last pusher shouldn't have leaked
    // their API key.
    test(
      'Ensure that Access Token has been reset.',
      () => expect(accessToken, 'YOUR_TOKEN'),
    );
    // assert(accessToken == 'test');
    // accessToken = Platform.environment['ORS_API_KEY']!;
    return;
  }

  // Set up of common parameters for Testing.
  const String testEndUserID = '8234e18b-f360-48cc-8bcf-c8625596d74a';
  const String testInstitutionID = 'ABNAMRO_ABNAGB2LXXX';
  const String testRedirectLink = 'http://www.yourwebpage.com/';
  // TODO: FILL REQUISTION ID WITH ACCOUNT ACCESS BEFORE RUNNING TESTS 5 and 6
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
    testInstitutionID: testInstitutionID,
  );

  /// TEST 4
  step4Tests(
    accessToken: accessToken,
    testEndUserID: testEndUserID,
    testInstitutionID: testInstitutionID,
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
