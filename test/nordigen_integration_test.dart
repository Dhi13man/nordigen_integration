import 'dart:io';

import 'package:test/test.dart';

import 'stepwise_tests/step_2_tests.dart';
import 'stepwise_tests/step_3_tests.dart';
import 'stepwise_tests/step_4_tests.dart';
import 'stepwise_tests/step_5_tests.dart';
import 'stepwise_tests/step_6_tests.dart';

import 'package:nordigen_integration/nordigen_integration.dart';

void main() async {
  // TODO: FILL NORDIGEN SECRETS BEFORE RUNNING UNIT TESTS
  String secretID = 'test';
  String secretKey = 'test';
  final NordigenAccountInfoAPI nordigenObject =
      await NordigenAccountInfoAPI.fromSecret(
    secretID: secretID,
    secretKey: secretKey,
  );

  // Change API key from environment if tests are running on Github Actions.
  if ((Platform.environment['EXEC_ENV'] ?? '') == 'github_actions') {
    // If running on Github Actions, the last pusher shouldn't have leaked
    // their API key.
    test(
      'Ensure that User Secrets have been reset.',
      () {
        expect(secretID, 'test');
        expect(secretKey, 'test');
      },
    );
    // assert(secretID == 'test' && secretKey == 'test');
    // secretID = Platform.environment['ORS_SECRET_ID']!;
    // secretKey = Platform.environment['ORS_SECRET_KEY']!;
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
    'Ensure that User Secrets are changed before actual tests.',
    () => expect(secretID != 'test' && secretKey != 'test', true),
  );

  group(
    'Simulate Step 1',
    () => test('Create and get Access Token: [NordigenAccountInfoAPI]', () {
      bool isClassInitSuccessful = true;
      try {
        NordigenAccountInfoAPI.createAccessToken(
          secretID: secretID,
          secretKey: secretKey,
        );
      } catch (_) {
        isClassInitSuccessful = false;
      }
      // API set up should not have any exceptions.
      expect(isClassInitSuccessful, true);
    }),
  );

  group('Simulate Step 2', () => step2Tests(nordigenObject: nordigenObject));

  /// TEST 3
  group(
    'Simulate Step 3',
    () => step3Tests(
      nordigenObject: nordigenObject,
      testEndUserID: testEndUserID,
      testInstitutionID: testInstitutionID,
    ),
  );

  /// TEST 4
  group(
    'Simulate Step 4',
    () => step4Tests(
      nordigenObject: nordigenObject,
      testEndUserID: testEndUserID,
      testInstitutionID: testInstitutionID,
      testRedirectLink: testRedirectLink,
    ),
  );

  /// TEST 5
  group(
    'Simulate Step 5',
    () => step5Tests(
      nordigenObject: nordigenObject,
      testEndUserID: testEndUserID,
      testRedirectLink: testRedirectLink,
      requisitionIDWithAccountAccess: requisitionIDWithAccountAccess,
    ),
  );

  /// TEST 6
  group(
    'Simulate Step 6',
    () => step6Tests(
      nordigenObject: nordigenObject,
      requisitionIDWithAccountAccess: requisitionIDWithAccountAccess,
    ),
  );
}
