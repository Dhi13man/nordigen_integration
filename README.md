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

[!["Buy Me A Coffee"](https://img.buymeacoffee.com/button-api/?text=Buy%20me%20a%20Ego%20boost&emoji=%F0%9F%98%B3&slug=dhi13man&button_colour=FF5F5F&font_colour=ffffff&font_family=Lato&outline_colour=000000&coffee_colour=FFDD00****)](https://www.buymeacoffee.com/dhi13man)

Development of a Null Safe Dart/Flutter Package for Nordigen EU PSD2 AISP Banking API Integration with relevant Data Models, proper encapsulation with the exposing of parameters, and succinct documentation.

For more information about the API view [Nordigen's Account Information API documentation](https://nordigen.com/en/account_information_documenation/integration/quickstart_guide/).

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
  - [Tests Screenshot](#tests-screenshot)
  - [Vote of Thanks](#vote-of-thanks)
  - [General Information](#general-information)

## Usage Steps

1. Go through the [Nordigen's Account Information API documentation](https://nordigen.com/en/account_information_documenation/integration/quickstart_guide/).

2. Register and get the API Access Token from <https://ob.nordigen.com>.

3. Initialise the `NordigenAccountInfoAPI` Class with the token recieved from Step 2.

4. Call any of the `NordigenAccountInfoAPI` Class methods to directly interact with Nordigen Server's endpoints while having the internal requests and relevant headers abstracted, based on your need.

5. Utilize any of the available Data Classes to modularly and sufficiently store and process the information during any of the API usage steps. The Data Classes have functionality to be constructed `fromMap()` and to be easily converted back `toMap()` as well as to be serialized, at any point.

### Example Usage

```dart
import 'package:nordigen_integration/nordigen_integration.dart';

Future<void> main() async {
    /// Step 1
    final NordigenAccountInfoAPI apiInterface = NordigenAccountInfoAPI(
        accessToken: 'YOUR_TOKEN',
    );

    /// Step 2 and then selecting the first ASPSP
    final ASPSP firstBank =
        (await apiInterface.getASPSPsForCountry(countryCode: 'gb')).first;

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
        aspspID: firstBank.id,
    );

    /// Open and Validate [redirectLink] and proceed with other functionality.
    print(redirectLink);
}
```

----

## API Documentation

### Available Methods

1. `NordigenAccountInfoAPI({required String accessToken})` (Class constuctor)

    Call it with `accessToken` parameter which is the access token recieved from <https://ob.nordigen.com/>, to access API features.

    Analogous to Step 1 of [Account Information API documentation](https://nordigen.com/en/account_information_documenation/integration/quickstart_guide/).

2. `getASPSPsForCountry({required String countryCode})`

    Gets the ASPSPs (Banks) in the Country represented by the given two-letter `countryCode` (ISO 3166).

    Analogous to Step 2 of [Account Information API documentation](https://nordigen.com/en/account_information_documenation/integration/quickstart_guide/).

3. `createEndUserAgreement({required String endUserID, required String aspspID, int maxHistoricalDays = 90})`

    Creates an End User Agreement for the given `endUserID`, `aspspID` and for the given `maxHistoricalDays` (default 90 days) and returns the resulting `EndUserAgreementModel`.

    Analogous to Step 3 of [Account Information API documentation](https://nordigen.com/en/account_information_documenation/integration/quickstart_guide/).

4. `createRequisition({required String endUserID, required String redirect, required String reference, List<String> agreements = const <String>[]})`

    Create a Requisition for the given `endUserID` and returns the resulting `RequisitionModel`. `reference` is additional layer of unique ID. Should match Step 3 if done. `redirect` is the link where the end user will be redirected after finishing authentication in ASPSP. `agreements` is as an array of ID(s) from Step 3 or empty array if that step was skipped.

    Analogous to Step 4.1 of [Account Information API documentation](https://nordigen.com/en/account_information_documenation/integration/quickstart_guide/).

5. `fetchRedirectLinkForRequisition({required String aspspID, required String requisitionID})`

    Provides a redirect link for the Requisition represented by the `requisitionID` passed in, for the ASPSP represented by the given `aspspID`.

    Analogous to Step 4.2 of [Account Information API documentation](https://nordigen.com/en/account_information_documenation/integration/quickstart_guide/).

6. `getRequisitionFromID({required String requisitionID})`

    Gets the Requisition identified by `requisitionID`.

7. `getEndUserAccountIDs({required String requisitionID})`

    Gets the Account IDs of the User for the Requisition identified by `requisitionID`.

    Analogous to Step 5 of [Account Information API documentation](https://nordigen.com/en/account_information_documenation/integration/quickstart_guide/).

8. `getAccountDetails({required String accountID})`

    Gets the Details of the Bank Account identified by `accountID`. Account Model follows schema in <https://nordigen.com/en/docs/account-information/overview/parameters-and-responses/>.

    Analogous to Step 6 of [Account Information API documentation](https://nordigen.com/en/account_information_documenation/integration/quickstart_guide/) for Account Details.

9. `getAccountTransactions({required String accountID})`

    Gets the Transactions of the Bank Account identified by `accountID` as a `Map<String, List<TransactionData>>` with keys `'booked'` and `'pending'` representing List of Booked and pending transactions respectively.

    Analogous to Step 6 of [Account Information API documentation](https://nordigen.com/en/account_information_documenation/integration/quickstart_guide/) for Account Transactions.

10. `getAccountBalances({required String accountID})`

    Gets the Balances of the Bank Account identified by `accountID` as `dynamic`. Will be depreciated later when documentation provides example of potentially fetched Balance Data.

    Analogous to Step 6 of [Account Information API documentation](https://nordigen.com/en/account_information_documenation/integration/quickstart_guide/) for Account Balances.

There are also various other methods for implementing POST, GET and DELETE requests across various endpoints in Nordigen Server, which are self explanatory:

1. `getASPSPUsingID({required String aspspID})`

2. `getEndUserAgreementUsingID({required String endUserAgreementID})`

3. `getEndUserAgreementsUsingUserID({required String endUserID})`

4. `deleteEndUserAgreementUsingID({required String endUserAgreementID})`

5. `getRequisitions({int limit = 100, int offset = 0,})`

6. `getRequisitionUsingID({required String requisitionID})`

7. `deleteRequisitionUsingID({required String requisitionID})`

8. `getAccountMetaData({required String accountID})`

### Available Data Classes

Refer <https://nordigen.com/en/docs/account-information/overview/parameters-and-responses/> for most of the Data Schema and the mentioned URLs in the special cases.

1. `ASPSP({required String id, required String name, String bic = '', int transactionTotalDays = 90, required List<String> countries, String logoURL = ''})`

    ASPSP (Bank) Data Model for Nordigen. Contains the `id` of the ASPSP, its `name`, `bic`, `transactionTotalDays`, the `countries` associated with the ASPSP and  ASPSP's logo as a URL `logoURL` to it, if any.

2. `EndUserAgreementModel({required String id, String created, String? accepted, int maxHistoricalDays = 90, int accessValidForDays = 90, required String endUserID, required String aspspID})`:

    End-user Agreement Data Model for Nordigen. Contains the `id` of the Agreement, its `created` time string, `accepted`, the number of `maxHistoricalDays` and `accessValidForDays`, and the `endUserID` and `aspspID` relevant to the Agreement.

3. `RequisitionModel({required String id, required String redirectURL, required String reference, String status = '', List<String> agreements = const <String>[], List<String> accounts = const <String>[], required String endUserID})`:

    Requisition Data Model for Nordigen. Contains the `id` of the Requisition, its `status`, end-user `agreements`, the `redirectURL` to which it should redirect, `reference` ID if any, `accounts` associated, and the associated `endUserID`.

4. `AccountMetaData({required String id, String created, String? lastAccessed, String iban, String aspspIdentifier, String status = ''})`
   Account meta-data model for Nordigen. Contains the `id` of the Bank Account, its `created` and `lastAccessed` date and time, `iban`, `status` and the `aspspIdentifier` identifiying its ASPSP. Refer to <https://nordigen.com/en/docs/account-information/overview/parameters-and-responses/>

5. `AccountDetails({String? id, String? iban, String? msisdn, required String currency, String? ownerName, String? name, String? displayName, String? product, String? cashAccountType, String? status, String? bic, String? linkedAccounts, String? usage, String? details, List<Balance>? balances, List<String>? links})`:

    Bank Account Details Model for Nordigen. Refer to <https://nordigen.com/en/docs/account-information/output/accounts/> for full Data Schema.

6. `TransactionData({required String id, String? debtorName, Map<String, dynamic>? debtorAccount,  String? bankTransactionCode,  String bookingDate = '',  String valueDate = '', required String transactionAmount, String? remittanceInformationUnstructured = '', ...})`:

    Transaction Data Model for Nordigen. Refer to <https://nordigen.com/en/docs/account-information/output/transactions/> for full Data Schema.

7. `Balance({required AmountData balanceAmount, required String balanceType, bool? creditLimitIncluded, String? lastChangeDateTime, String? referenceDate, String? lastCommittedTransaction})`

    Balance Data Model for Nordigen. Contains `balanceAmount` of Transaction, its `balanceType`, whether its `creditLimitIncluded`, its `lastChangeDateTime` and `referenceDate` as `String` and the `lastCommittedTransaction`.

    Refer to <https://nordigen.com/en/docs/account-information/output/balance/> for full Data Schema and the available balance types.

8. `AmountData({required String amount, required String currency})`

    It is a simple Class that holds the transaction `amount` and the `currency` type, both as required parameters.

----

## Contributing

Make sure you check out the [Contribution Guildelines](https://github.com/Dhi13man/nordigen_integration/blob/main/CONTRIBUTING.md) for information about how to contribute to the development of this package!

## Dependencies

- [Dart,](https://www.dartlang.org/) for the Dart SDK which this obviously runs on.
- [http,](https://pub.dev/packages/http) is used for making API calls to the Nordigen Server Endpoints with proper response and error handling.

----

## Tests Screenshot

![Nordigen EU PSD2 AISP Integration Tests Successful Screenshot](https://raw.githubusercontent.com/Dhi13man/nordigen_integration/main/package_tests_success_screenshot.png)

----

## Vote of Thanks

1. In case of any bugs, reach out to me at [@Dhi13man](https://twitter.com/Dhi13man) or [file an issue](https://github.com/Dhi13man/nordigen_integration/issues)

2. The first release of this package was sponsored by [Cashtic](https://cashtic.com). Show them some love! This package would not otherwise be possible

3. Big thanks to contributors, including [@stantemo](https://github.com/stantemo) and [@c-louis](https://github.com/c-louis). Contribution is welcome, and makes my day brighter

----

## General Information

This project is a starting point for a Dart [package](https://flutter.dev/developing-packages/), a library module containing code that can be shared easily across multiple Flutter or Dart projects.

For help getting started with Flutter, view the [online documentation](https://flutter.dev/docs), which offers tutorials,samples, guidance on mobile development, and a full API reference.
