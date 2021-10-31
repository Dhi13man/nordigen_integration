part of 'package:nordigen_integration/nordigen_integration.dart';

/// Institution (Bank) Data Model for Nordigen
///
/// Contains the [id] of the Institution, its [name], [bic],
/// [totalTransactionDays] and the [countries] associated with the Institution.
class Institution {
  const Institution({
    required this.id,
    required this.name,
    required this.countries,
    this.bic = '',
    this.transactionTotalDays = 90,
    this.logoURL = '',
  });

  /// For easy Data Model Generation from Map fetched by querying Nordigen.
  factory Institution.fromMap(dynamic fetchedMap) => Institution(
        id: fetchedMap['id']! as String,
        name: fetchedMap['name']! as String,
        bic: (fetchedMap['bic'] ?? '') as String,
        transactionTotalDays: int.tryParse(
              (fetchedMap['transaction_total_days'] ?? '90') as String,
            ) ??
            90,
        countries: (fetchedMap['countries']! as List<dynamic>)
            .map<String>((dynamic country) => country.toString())
            .toList(),
        logoURL: (fetchedMap['logo'] ?? '') as String,
      );

  /// Forms a [Map] of [String] keys and [dynamic] values from Class Data.
  ///
  /// Map Keys: "id", "name", "bic" and "countries"
  Map<String, dynamic> toMap() => <String, dynamic>{
        'id': id,
        'name': name,
        'countries': countries,
        'bic': bic,
        'transaction_total_days': transactionTotalDays,
        'logo': logoURL,
      };

  /// Identifier of this particular Institution
  final String id;

  /// Institution Name
  final String name;

  /// BIC of the Institution.
  final String bic;

  /// Represents the total transaction days for the Institution.
  final int transactionTotalDays;

  /// Countries associated with the Institution
  final List<String> countries;

  /// URL of the Logo of the Institution as a [String].
  final String logoURL;

  /// Returns the class data converted to a map as a Serialized JSON String.
  @override
  String toString() => jsonEncode(toMap());
}

/// End-user Agreement Data Model for Nordigen.
///
/// Contains the [id] of the Agreement, its [created] time string, [accepted],
/// the number of [maxHistoricalDays] and [accessValidForDays],
/// and the [accessScope] and [institutionID] relevant to the Agreement.
class EndUserAgreementModel {
  EndUserAgreementModel({
    required this.id,
    String? created,
    this.maxHistoricalDays = 90,
    this.accessValidForDays = 90,
    this.accessScope = const <String>['balances', 'details', 'transactions'],
    this.accepted,
    required this.institutionID,
  }) : created = created ?? DateTime.now().toIso8601String();

  /// For easy Data Model Generation from Map fetched by querying Nordigen.
  factory EndUserAgreementModel.fromMap(dynamic fetchedMap) =>
      EndUserAgreementModel(
        id: fetchedMap['id']! as String,
        created: fetchedMap['created']! as String,
        maxHistoricalDays: fetchedMap['max_historical_days'] as int,
        accessValidForDays: fetchedMap['access_valid_for_days'] as int,
        accessScope: (fetchedMap['access_scope'] as List<dynamic>)
            .map<String>((dynamic e) => e.toString())
            .toList(),
        accepted: fetchedMap['accepted'] as String?,
        institutionID: fetchedMap['institution_id']! as String,
      );

  /// Forms a [Map] of [String] keys and [dynamic] values from Class Data.
  ///
  /// Map Keys: "id", "created", "accepted", "max_historical_days",
  /// "access_valid_for_days", "enduser_id" and "institution_id"
  Map<String, dynamic> toMap() => <String, dynamic>{
        'id': id,
        'created': created,
        'max_historical_days': maxHistoricalDays,
        'access_valid_for_days': accessValidForDays,
        'access_scope': accessScope,
        'accepted': accepted,
        'institution_id': institutionID,
      };

  /// Identifier of this particular End User Agreement
  final String id;

  /// Time of End User Agreement creation in ISO8601 DateTime [String] Format
  final String created;

  /// Maximum Historical Days for the agreement.
  final int maxHistoricalDays;

  /// Days that the agreement is valid for.
  final int accessValidForDays;

  /// User ID associated with the transaction (typically UUID)
  final List<String> accessScope;

  /// Time of End User Agreement acceptance (if any) in ISO8601 DateTime String
  final String? accepted;

  /// ID of the Institution (bank) associated with the transaction
  final String institutionID;

  /// Returns the class data converted to a map as a Serialized JSON String.
  @override
  String toString() => jsonEncode(toMap());
}

/// Holds the transaction [amount] and the [currency] type
class AmountData {
  const AmountData({required this.amount, required this.currency});

  final String currency;
  final String amount;

  /// Parses the amount value from string to a double numeric.
  double get getAmountNumber => double.parse(amount);

  /// Forms a [Map] of [String] keys and [dynamic] values from Class Data.
  ///
  /// Map Keys: "amount" and "currency".
  Map<String, dynamic> toMap() => <String, dynamic>{
        'amount': amount,
        'currency': currency,
      };

  /// Returns the class data converted to a map as a Serialized JSON String.
  @override
  String toString() => jsonEncode(toMap());
}
