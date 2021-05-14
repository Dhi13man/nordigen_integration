part of 'package:nordigen_integration/nordigen_integration.dart';

/// Balance Data Model for Nordigen.
///
/// Refer https://nordigen.com/en/docs/account-information/output/balance/
///
/// Contains [balanceAmount] of Transaction, its [balanceType], whether its
/// [creditLimitIncluded], its [lastChangeDateTime] and [referenceDate] as
/// [String] and the [lastCommittedTransaction].
class Balance {
  const Balance({
    required this.balanceAmount,
    required this.balanceType,
    this.creditLimitIncluded,
    this.lastChangeDateTime,
    this.referenceDate,
    this.lastCommittedTransaction,
  });

  /// For easy Data Model Generation from Map fetched by querying Nordigen.
  factory Balance.fromMap(dynamic fetchedMap) {
    // Validate data first.
    assert(fetchedMap['balanceAmount'] != null);
    assert(fetchedMap['balanceType'] != null);
    return Balance(
      balanceAmount: fetchedMap['balanceAmount'],
      balanceType: fetchedMap['balanceType'] as String,
      creditLimitIncluded: fetchedMap['creditLimitIncluded'] as bool?,
      lastChangeDateTime: fetchedMap['lastChangeDateTime'] as String?,
      referenceDate: fetchedMap['referenceDate'] as String?,
      lastCommittedTransaction:
          fetchedMap['lastCommittedTransaction'] as String?,
    );
  }

  /// Forms a [Map] of [String] keys and [dynamic] values from Class Data.
  ///
  /// Map Keys: "amount" and "currency".
  Map<String, dynamic> toMap() => <String, dynamic>{
        'balanceAmount': balanceAmount,
        'balanceType': balanceType,
        'creditLimitIncluded': creditLimitIncluded,
        'lastChangeDateTime': lastChangeDateTime,
        'referenceDate': referenceDate,
        'lastCommittedTransaction': lastCommittedTransaction,
      };

  /// The actual Amount of the balance.
  final dynamic balanceAmount;

  /// Refer https://nordigen.com/en/docs/account-information/output/balance/ for
  /// the available balance types.
  final String balanceType;

  /// A flag indicating if the credit limit of the corresponding account
  /// is included in the calculation of the balance, where applicable.
  final bool? creditLimitIncluded;

  /// Might be used to indicate e.g. with the expected or booked balance that
  /// no action is known on the account, which is not yet booked (ISODateTime).
  final String? lastChangeDateTime;

  /// Indicates the date of the balance (ISODate)
  final String? referenceDate;

  /// entryReference of the last commited transaction to support the TPP
  /// in identifying whether all PSU transactions are already known.
  final String? lastCommittedTransaction;

  /// Returns the class data converted to a map as a Serialized JSON String.
  @override
  String toString() => jsonEncode(toMap());
}
