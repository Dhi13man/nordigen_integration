import 'dart:io';

import 'package:test/test.dart';

import './batch_tests/institutions_tests.dart';
import './batch_tests/agreements_tests.dart';
import './batch_tests/requisitions_tests.dart';
import './batch_tests/step_5_tests.dart';
import './batch_tests/step_6_tests.dart';

import 'package:nordigen_integration/nordigen_integration.dart';

Future<void> main() async {
  // TODO: FILL NORDIGEN SECRETS BEFORE RUNNING UNIT TESTS
  String secretID = 'test';
  String secretKey = 'test';

  // Change API key from environment if tests are running on Github Actions.
  if (Platform.environment['EXEC_ENV'] == 'github_actions') {
    // If running on Github Actions, the last committer shouldn't have
    // leaked their API key.
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

  final NordigenAccountInfoAPI nordigenObject =
      await NordigenAccountInfoAPI.fromSecret(
    secretID: secretID,
    secretKey: secretKey,
  );

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
    'Simulate Step 1 (/token)',
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

  group(
    'Simulate Step 2 and /institutions Tests',
    () => institutionsTests(nordigenObject: nordigenObject),
  );

  /// TEST 3
  group(
    'Simulate Step 3 and /agreements Tests',
    () => agreementsTests(
      nordigenObject: nordigenObject,
      testEndUserID: testEndUserID,
      testInstitutionID: testInstitutionID,
    ),
  );

  /// TEST 4
  group(
    'Simulate Step 4 and /requisitions Tests',
    () => requisitionsTests(
      nordigenObject: nordigenObject,
      testInstitutionID: testInstitutionID,
      testRedirectLink: testRedirectLink,
    ),
  );

  /// TEST 5
  group(
    'Simulate Step 5',
    () => step5Tests(
      nordigenObject: nordigenObject,
      requisitionIDWithAccountAccess: requisitionIDWithAccountAccess,
      testInstitutionID: testInstitutionID,
      testRedirectLink: testRedirectLink,
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
