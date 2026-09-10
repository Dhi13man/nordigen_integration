---
name: nordigen-integration-account-link
description: >-
  Use whenever writing, fixing, or reviewing Dart/Flutter code that uses
  package:nordigen_integration, GoCardless Bank Account Data, Nordigen, PSD2,
  open banking, requisitions, or bank transactions. Trigger on "Nordigen",
  "GoCardless", "bank account data", "requisition", "end user agreement",
  "list banks", "fetch transactions".
---

# nordigen_integration

Dart client for **GoCardless Bank Account Data**. Types are still named
`Nordigen*`. The live host is `https://bankaccountdata.gocardless.com`. Do not
call `ob.nordigen.com` or `nordigen.com` API hosts; those are dead.

## Secrets

`secret_id` and `secret_key` come from environment or a secret store. Never
commit, log, print, or embed them in widgets or tests. Use placeholders in
examples.

`NordigenAccountInfoAPI.fromSecret(secretID:, secretKey:)` keeps only the
access JWT and drops `refresh`. For a process that outlives the access token,
call `NordigenAccountInfoAPI.createAccessToken`, persist `refresh`, construct
with `NordigenAccountInfoAPI(accessToken:)`, and later
`refreshAccessToken(refresh:)`.

HTTP failures throw `http.ClientException`, not a package exception type.

## Link flow

Skip a step and you get 403 or empty `accounts`. Order:

1. `getInstitutionsForCountry(countryCode: 'gb')`: ISO 3166 two letters.
2. `createEndUserAgreement(institutionID:)`: `accessScope` may only contain
   `'balances'`, `'details'`, `'transactions'` (`ArgumentError` otherwise).
3. `createRequisitionAndBuildLink(redirect:, institutionID:,
   agreement: eua.id, reference: uniqueId)`.
4. Send the end user to `requisition.link`. Do **not** call
   `acceptEndUserAgreement` unless you have that user's `ipAddress` and
   `userAgent`; it 403s otherwise.
5. After redirect: `getEndUserAccountIDs(requisitionID: requisition.id)`.
6. Per account id:
   - `getAccountDetails`: IBAN, owner, currency
   - `getAccountMetaData`: requisition account resource, not details
   - `getAccountTransactions`: map keys `'booked'` and `'pending'`
   - `getAccountBalances`: `List<Balance>`

```dart
import 'package:nordigen_integration/nordigen_integration.dart';

final api = await NordigenAccountInfoAPI.fromSecret(
  secretID: secretId,
  secretKey: secretKey,
);
final bank = (await api.getInstitutionsForCountry(countryCode: 'gb')).first;
final eua = await api.createEndUserAgreement(institutionID: bank.id);
final requisition = await api.createRequisitionAndBuildLink(
  redirect: redirectUrl,
  institutionID: bank.id,
  agreement: eua.id,
  reference: reference,
);
// Open requisition.link, then:
final accountIds = await api.getEndUserAccountIDs(
  requisitionID: requisition.id,
);
```
