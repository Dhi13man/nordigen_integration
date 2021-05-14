part of 'package:nordigen_integration/nordigen_integration.dart';

/// Account Model
///
/// Refer https://nordigen.com/en/docs/account-information/overview/parameters-and-responses/
///
/// Contains the [id] of the Bank Account, its [created] and [lastAccessed] date
/// and time, [iban], [status] and the [aspspIdentifier] identifiying its ASPSP.
class AccountModel {
  AccountModel({
    required this.id,
    String? created,
    this.lastAccessed,
    required this.iban,
    required this.aspspIdentifier,
    this.status = '',
  }) : created = created ?? DateTime.now().toIso8601String();

  /// For easy Data Model Generation from Map fetched by querying Nordigen.
  factory AccountModel.fromMap(dynamic fetchedMap) {
    // Validate data first.
    assert(fetchedMap['id'] != null);
    assert(fetchedMap['created'] != null);
    assert(fetchedMap['iban'] != null);
    assert(fetchedMap['aspsp_identifier'] != null);
    return AccountModel(
      id: fetchedMap['id'] as String,
      created: fetchedMap['created'] as String,
      lastAccessed: fetchedMap['last_accessed'] as String?,
      iban: fetchedMap['iban'] as String,
      aspspIdentifier: fetchedMap['aspsp_identifier'] as String,
      status: (fetchedMap['status'] ?? '') as String,
    );
  }

  /// Forms a [Map] of [String] keys and [dynamic] values from Class Data.
  ///
  /// Map Keys: "id", "name", "bic" and "countries"
  Map<String, dynamic> toMap() => <String, dynamic>{
        'id': id,
        'created': created,
        'last_accessed': lastAccessed,
        'iban': iban,
        'aspsp_identifier': aspspIdentifier,
        'status': status,
      };

  /// The ID of this Account, used to refer to this account in other API calls.
  final String id;

  /// The date & time at which the account object was created.
  final String created;

  /// The date & time at which the account object was last accessed.
  final String? lastAccessed;

  /// The Account IBAN
  final String iban;

  /// The ID of the ASPSP (bank) associated with this account.
  final String aspspIdentifier;

  /// The processing status of this account.
  final String status;

  /// Returns the class data converted to a map as a Serialized JSON String.
  @override
  String toString() => jsonEncode(toMap());
}

/// Bank Account Model
///
/// Refer https://nordigen.com/en/docs/account-information/overview/parameters-and-responses/
///
/// Contains the [id] of the Bank Account, its [created] and [lastAccessed] date
/// and time, [iban], [status] and the [aspspIdentifier] identifiying its ASPSP.
class BankAccountModel {
  BankAccountModel({
    required this.id,
    String? created,
    this.lastAccessed,
    required this.iban,
    required this.aspspIdentifier,
    this.status = '',
  }) : created = created ?? DateTime.now().toIso8601String();

  /// For easy Data Model Generation from Map fetched by querying Nordigen.
  factory BankAccountModel.fromMap(dynamic fetchedMap) {
    // Validate data first.
    assert(fetchedMap['id'] != null);
    assert(fetchedMap['created'] != null);
    assert(fetchedMap['iban'] != null);
    assert(fetchedMap['aspsp_identifier'] != null);
    return BankAccountModel(
      id: fetchedMap['id'] as String,
      created: fetchedMap['created'] as String,
      lastAccessed: fetchedMap['last_accessed'] as String?,
      iban: fetchedMap['iban'] as String,
      aspspIdentifier: fetchedMap['aspsp_identifier'] as String,
      status: (fetchedMap['status'] ?? '') as String,
    );
  }

  /// Forms a [Map] of [String] keys and [dynamic] values from Class Data.
  ///
  /// Map Keys: "id", "name", "bic" and "countries"
  Map<String, dynamic> toMap() => <String, dynamic>{
        'id': id,
        'created': created,
        'last_accessed': lastAccessed,
        'iban': iban,
        'aspsp_identifier': aspspIdentifier,
        'status': status,
      };

  /// The ID of this Account, used to refer to this account in other API calls.
  final String id;

  /// The date & time at which the account object was created.
  final String created;

  /// The date & time at which the account object was last accessed.
  final String? lastAccessed;

  /// The Account IBAN
  final String iban;

  /// The ID of the ASPSP (bank) associated with this account.
  final String aspspIdentifier;

  /// The processing status of this account.
  final String status;

  /// Returns the class data converted to a map as a Serialized JSON String.
  @override
  String toString() => jsonEncode(toMap());
}
