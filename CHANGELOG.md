## [1.0.0] - 13th May, 2021

Initial release supporting [Nordigen's Account Information API documentation](https://nordigen.com/en/account_information_documenation/integration/quickstart_guide/) and relevant Data Models required to support it, in the form of Serializable Classes.

## [1.0.1] - 13th May, 2021

Initial release supporting [Nordigen's Account Information API documentation](https://nordigen.com/en/account_information_documenation/integration/quickstart_guide/) and relevant Data Models required to support it, in the form of Serializable Classes.

Shortened Package description to follow dart conventions.

## [1.0.2] - 14th May, 2021

Initial release supporting [Nordigen's Account Information API documentation](https://nordigen.com/en/account_information_documenation/integration/quickstart_guide/) and relevant Data Models required to support it, in the form of Serializable Classes.

Added EU PSD2 AISP keywords to package descriptions so people can find it easier. Unnecessary Flutter dependancy removed.

## [1.2.0] - 14th May, 2021

1. ASPSP Data Structure changed to include  `[String] transaction_total_days`.

2. Lint rules applied.

3. Null Safety implemented.

4. Documentation follows null safety conventions now.

## [1.2.5] - 14th May, 2021

1. Implemented actual full `TransactionData` Model from API Documentation.

2. Renamed `BankAccountModel` to `AccountModel` because of Account schema discrepency in documentation between <https://nordigen.com/en/docs/account-information/overview/parameters-and-responses/> and <https://nordigen.com/en/docs/account-information/output/accounts/>.
3. Implemented `Balance` model from API Documentation.

4. Temporary `getAccountBalancesTemporary` method of `NordigenAccountInfoAPI` class implemented that will be depreciated once the returned data format can be pinned down.

5. Lint -> Pedantic.

6. TODO: Resolve account model discrepency between <https://nordigen.com/en/docs/account-information/output/accounts/> and Schema given in <https://nordigen.com/en/docs/account-information/overview/parameters-and-responses/>

## [1.3.0] - 15th May, 2021

1. Discrepencies solved with `BankAccountModel`; `Balance` and `getAccountBalances`.

2. Added basic GET and DELETE requests for certain endpoints.

3. **BREAKING:** Simplified certain APIs for more controlled usage.
   1. `fetchRedirectLinkForRequisition` method only takes `String aspspID` and `String requisitionID` now.
   2. `createEndUserAgreement` method only takes `String endUserID`,  `String aspspID`, `int maxHistoricalDays = 90` now.

4. PUT implementation added for future conveinience.

5. Updated documentation to highligh changes.
