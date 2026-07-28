# nordigen_integration

[![License](https://img.shields.io/github/license/dhi13man/nordigen_integration)](https://github.com/Dhi13man/nordigen_integration/blob/main/LICENSE)
[![Language](https://img.shields.io/badge/language-Dart-blue.svg)](https://dart.dev)
[![Language](https://img.shields.io/badge/language-Flutter-blue.svg)](https://flutter.dev)
[![Contributors](https://img.shields.io/github/contributors-anon/dhi13man/nordigen_integration?style=flat)](https://github.com/Dhi13man/nordigen_integration/graphs/contributors)
[![GitHub forks](https://img.shields.io/github/forks/dhi13man/nordigen_integration?style=social)](https://github.com/Dhi13man/nordigen_integration/network/members)
[![GitHub Repo stars](https://img.shields.io/github/stars/dhi13man/nordigen_integration?style=social)](https://github.com/Dhi13man/nordigen_integration)
[![Last Commit](https://img.shields.io/github/last-commit/dhi13man/nordigen_integration)](https://github.com/Dhi13man/nordigen_integration/commits/main)
[![Build, Format, Test](https://github.com/Dhi13man/nordigen_integration/workflows/Build,%20Format,%20Test/badge.svg)](https://github.com/Dhi13man/nordigen_integration/actions)
[![nordigen_integration version](https://img.shields.io/pub/v/nordigen_integration.svg)](https://pub.dev/packages/nordigen_integration)
[![pub points](https://img.shields.io/pub/points/nordigen_integration)](https://pub.dev/packages/nordigen_integration/score)
[![OpenSSF Scorecard](https://api.scorecard.dev/projects/github.com/Dhi13man/nordigen_integration/badge)](https://scorecard.dev/viewer/?uri=github.com/Dhi13man/nordigen_integration)

Null-safe Dart client and data models for the GoCardless Bank Account Data API,
formerly the Nordigen EU PSD2 account information service.

For API concepts and credentials, see the
[GoCardless Bank Account Data quick-start guide](https://developer.gocardless.com/bank-account-data/quick-start-guide/).

## Contents

- [nordigen_integration](#nordigen_integration)
  - [Contents](#contents)
  - [Usage Steps](#usage-steps)
    - [Example Usage](#example-usage)
  - [API Documentation](#api-documentation)
    - [Available Methods](#available-methods)
    - [Available Data Classes](#available-data-classes)
  - [Contributing](#contributing)
  - [Dependencies](#dependencies)
  - [Vote of Thanks](#vote-of-thanks)
  - [General Information](#general-information)

## Usage Steps

1. Read the [GoCardless Bank Account Data quick-start guide](https://developer.gocardless.com/bank-account-data/quick-start-guide/).

2. Register and create user secrets as described in the [quick-start guide](https://developer.gocardless.com/bank-account-data/quick-start-guide/).

3. Initialize `NordigenAccountInfoAPI` with the credentials from step 2.

4. Call any of the `NordigenAccountInfoAPI` Class methods to directly interact with Nordigen Server's endpoints while having the internal requests and relevant headers abstracted, based on your need.

5. Utilize any of the available Data Classes to modularly and sufficiently store and process the information during any of the API usage steps. The Data Classes have functionality to be constructed `fromMap()` and to be easily converted back `toMap()` as well as to be serialized, at any point.

### Example Usage

```dart
import 'package:nordigen_integration/nordigen_integration.dart';

Future<void> main() async {
    /// Step 1
    final NordigenAccountInfoAPI apiInterface =
        await NordigenAccountInfoAPI.fromSecret(secretID: 'secret_id', secretKey: 'secret_key');

    /// Step 2 and then selecting the first Bank/Institution
    final Institution firstBank =
        (await apiInterface.getInstitutionsForCountry(countryCode: 'gb')).first;

    /// Step 3
    final EndUserAgreementModel endUserAgreementModel =
        await apiInterface.createEndUserAgreement(
        maxHistoricalDays: 90,
        accessValidForDays: 90,
        institutionID: firstBank.id,
    );

    /// Step 4
    final RequisitionModel requisition = await apiInterface.createRequisitionAndBuildLink(
        agreement: endUserAgreementModel.id,
        institutionID: firstBank.id,
        redirect: 'http://www.yourwebpage.com/',
        reference: 'exampleRef42069666',
    );

    /// Open and validate in [link] and proceed with other functionality.
    print('Validate: ${requisition.link}');
}
```

----

## API Documentation

### Available Methods

1. `NordigenAccountInfoAPI({required String accessToken})` (class constructor)

    Call it with the `accessToken` generated using user secrets from the [quick-start guide](https://developer.gocardless.com/bank-account-data/quick-start-guide/) to access API features.

    Analogous to step 1 of the [Bank Account Data quick-start guide](https://developer.gocardless.com/bank-account-data/quick-start-guide/).

2. `static Future<NordigenAccountInfoAPI> fromSecret({required String secretID, required String secretKey})` (static convenience method to generate interface using Secrets)

    Call it with `secretID` and `secretKey` parameters from the user's [GoCardless Bank Account Data credentials](https://developer.gocardless.com/bank-account-data/quick-start-guide/).

    Returns a `Future` that resolves to the initialized `NordigenAccountInfoAPI` object using the Access Token that was generated using the secrets.

    Analogous to step 1 of the [Bank Account Data quick-start guide](https://developer.gocardless.com/bank-account-data/quick-start-guide/).

3. `static Future<Map<String, dynamic>> createAccessToken({required String secretID, required String secretKey})`

    Call it with `secretID` and `secretKey` parameters from the user's [GoCardless Bank Account Data credentials](https://developer.gocardless.com/bank-account-data/quick-start-guide/).

    Returns a `Future` that resolves to a `Map<String, dynamic>` containing the information about the Access Token that was generated using the secrets.

4. `getInstitutionsForCountry({required String countryCode})`

    Gets the Institutions (Banks) in the Country represented by the given two-letter `countryCode` (ISO 3166).

    Analogous to step 2 of the [Bank Account Data quick-start guide](https://developer.gocardless.com/bank-account-data/quick-start-guide/).

5. `createEndUserAgreement({required String institutionID, int maxHistoricalDays = 90, int accessValidForDays = 90, List<String> accessScope = const <String>['balances', 'details', 'transactions']})`

    Create an End User Agreement for the Institution identified by `institutionID`, with an account access period of `accessValidForDays` and `maxHistoricalDays` of transaction history (90 days by default), and return the resulting `EndUserAgreementModel`.

    Analogous to step 3 of the [Bank Account Data quick-start guide](https://developer.gocardless.com/bank-account-data/quick-start-guide/).

6. `acceptEndUserAgreement({required String endUserAgreementID, required String ipAddress, required String userAgent})`

    Accepts the End User Agreement identified by `endUserAgreementID` and returns a `Future` resolving to the resulting `EndUserAgreementModel`.

    Accepts the user agreement using given `userAgent` and `ipAddress`. This determine whether you have permission to accept the Agreement or not. Will throw a Error Code 403 (You do not have permission to perform this action) otherwise.

7. `createRequisitionAndBuildLink({required String redirect, required String institutionID, String? agreement, required String reference, String? userLanguage})`

    Create a Requisition for the given `institutionID` and returns a `Future` resolving to the resulting `RequisitionModel`.

    `reference` is additional layer of unique ID. Should match Step 3 if done. `redirect` is the link where the end user will be redirected after finishing authentication in institution. `agreement` is the identifier of the agreement from Step 3 and `userLanguage` is the language code of the language used in verification.

    Analogous to step 4 of the [Bank Account Data quick-start guide](https://developer.gocardless.com/bank-account-data/quick-start-guide/).

8. `getRequisitionUsingID({required String requisitionID})`

    Gets the Requisition identified by `requisitionID`.

9. `getEndUserAccountIDs({required String requisitionID})`

    Gets the Account IDs of the User for the Requisition identified by `requisitionID`.

    Analogous to step 5 of the [Bank Account Data quick-start guide](https://developer.gocardless.com/bank-account-data/quick-start-guide/).

10. `getAccountDetails({required String accountID})`

    Gets the details of the bank account identified by `accountID`. The account model follows the [GoCardless endpoint schema](https://developer.gocardless.com/bank-account-data/endpoints/).

    Analogous to step 6 of the [Bank Account Data quick-start guide](https://developer.gocardless.com/bank-account-data/quick-start-guide/) for account details.

11. `getAccountTransactions({required String accountID})`

    Gets the Transactions of the Bank Account identified by `accountID` as a `Map<String, List<TransactionData>>` with keys `'booked'` and `'pending'` representing List of Booked and pending transactions respectively.

    Analogous to step 6 of the [Bank Account Data quick-start guide](https://developer.gocardless.com/bank-account-data/quick-start-guide/) for account transactions.

12. `getAccountBalances({required String accountID})`

    Gets the balances of the bank account identified by `accountID` as `dynamic`. This return type may be deprecated when the response schema can be pinned down.

    Analogous to step 6 of the [Bank Account Data quick-start guide](https://developer.gocardless.com/bank-account-data/quick-start-guide/) for account balances.

There are also various other methods for implementing POST, GET and DELETE requests across various endpoints in Nordigen Server, which are self explanatory:

1. `getinstitutionUsingID({required String institutionID})`

2. `getEndUserAgreementUsingID({required String endUserAgreementID})`

3. `getEndUserAgreementTextUsingID({required String endUserAgreementID})`

4. `getEndUserAgreements({int limit = 100, int offset = 0})`

5. `deleteEndUserAgreementUsingID({required String endUserAgreementID})`

6. `getRequisitions({int limit = 100, int offset = 0,})`

7. `getRequisitionUsingID({required String requisitionID})`

8. `deleteRequisitionUsingID({required String requisitionID})`

9. `getAccountMetaData({required String accountID})`

### Available Data Classes

Refer to the [GoCardless Bank Account Data endpoint reference](https://developer.gocardless.com/bank-account-data/endpoints/) for the upstream schemas.

1. `Institution({required String id, required String name, String bic = '', int transactionTotalDays = 90, required List<String> countries, String logoURL = ''})`

    Institution (Bank) Data Model for Nordigen. Contains the `id` of the institution, its `name`, `bic`, `transactionTotalDays`, the `countries` associated with the institution and institution's logo as a URL `logoURL` to it, if any.

2. `EndUserAgreementModel({required String id, String created, int maxHistoricalDays = 90, int accessValidForDays = 90, List<String> accessScope = const <String>['balances', 'details', 'transactions'], String? accepted, required String institutionID})`:

    End-user Agreement Data Model for Nordigen. Contains the `id` of the Agreement, its `created` time string, `accepted`, the number of `maxHistoricalDays` and `accessValidForDays`, and the `accessScope` and `institutionID` relevant to the Agreement.

3. `RequisitionModel({required String id, required String created, required String redirectURL, RequisitionStatus status = const RequisitionStatus(short: '', long: '', description: ''), required String institutionID, String agreement, required String reference, List<String> accounts = const <String>[], String userLanguage='EN', required String link})`:

    Requisition Data Model for Nordigen. Contains the `id` of the Requisition, `created` timestamp String, its `status`, associated end-user `agreement`, the `link` which is to be opened for verification, the `redirectURL` to which it should redirect, `reference` ID if any, `accounts` associated, and the associated `institutionID`.

    `RequisitionStatus({required String short, required String long, required String description})` contains a short status, a long status and a description of the status.

4. `AccountMetaData({required String id, String created, String? lastAccessed, String iban, String institutionIdentifier, String status = ''})`
   Account metadata model. Contains the bank account `id`, `created` and `lastAccessed` timestamps, `iban`, `status`, and the `institutionIdentifier` identifying its institution.

5. `AccountDetails({String? id, String? iban, String? msisdn, required String currency, String? ownerName, String? name, String? displayName, String? product, String? cashAccountType, String? status, String? bic, String? linkedAccounts, String? usage, String? details, List<Balance>? balances, List<String>? links})`:

    Bank account details model. Refer to the [GoCardless endpoint reference](https://developer.gocardless.com/bank-account-data/endpoints/) for the complete schema.

6. `TransactionData({required String id, String? debtorName, Map<String, dynamic>? debtorAccount,  String? bankTransactionCode,  String bookingDate = '',  String valueDate = '', required String transactionAmount, String? remittanceInformationUnstructured = '', ...})`:

    Transaction data model. Refer to the [GoCardless endpoint reference](https://developer.gocardless.com/bank-account-data/endpoints/) for the complete schema.

7. `Balance({required AmountData balanceAmount, required String balanceType, bool? creditLimitIncluded, String? lastChangeDateTime, String? referenceDate, String? lastCommittedTransaction})`

    Balance Data Model for Nordigen. Contains `balanceAmount` of Transaction, its `balanceType`, whether its `creditLimitIncluded`, its `lastChangeDateTime` and `referenceDate` as `String` and the `lastCommittedTransaction`.

    Refer to the [GoCardless endpoint reference](https://developer.gocardless.com/bank-account-data/endpoints/) for the complete schema and available balance types.

8. `AmountData({required String amount, required String currency})`

    It is a simple Class that holds the transaction `amount` and the `currency` type, both as required parameters.

----

## Contributing

See the [contribution guidelines](CONTRIBUTING.md) to contribute to the package.

## Dependencies

- [Dart,](https://www.dartlang.org/) for the Dart SDK which this obviously runs on.
- [http,](https://pub.dev/packages/http) is used for making API calls to the Nordigen Server Endpoints with proper response and error handling.

----

## Vote of Thanks

1. In case of any bugs, reach out to me at [@Dhi13man](https://twitter.com/Dhi13man) or [file an issue](https://github.com/Dhi13man/nordigen_integration/issues)

2. Big thanks to contributors, including [@tolik505](https://github.com/tolik505), [@antoineraulin](https://github.com/antoineraulin), [@stantemo](https://github.com/stantemo) and [@c-louis](https://github.com/c-louis). Contribution is welcome, and makes my day brighter

3. The first release of this package was sponsored by [Cashtic](https://cashtic.com). Show them some love! This package would not otherwise be possible

----

## General Information

This project is a starting point for a Dart [package](https://flutter.dev/developing-packages/), a library module containing code that can be shared easily across multiple Flutter or Dart projects.

For help getting started with Flutter, view the [online documentation](https://flutter.dev/docs), which offers tutorials,samples, guidance on mobile development, and a full API reference.
