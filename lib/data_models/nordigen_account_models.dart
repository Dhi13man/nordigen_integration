part of 'package:nordigen_integration/nordigen_integration.dart';

/// Bank Account Details Model for Nordigen.
///
/// The only mandatory value is [currency].
///
/// Refer to https://nordigen.com/en/docs/account-information/output/accounts/
/// for all the optional and conditional (nullable) values.
class AccountDetails {
  const AccountDetails({
    this.id,
    this.iban,
    this.bban,
    this.msisdn,
    required this.currency,
    this.ownerName,
    this.name,
    this.displayName,
    this.product,
    this.cashAccountType,
    this.status,
    this.bic,
    this.linkedAccounts,
    this.usage,
    this.details,
    this.balances,
    this.links,
  });

  /// For easy Data Model Generation from Map fetched by querying Nordigen.
  factory AccountDetails.fromMap(dynamic fetchedMap) {
    // Validate data first.
    assert(fetchedMap['currency'] != null);
    return AccountDetails(
      id: fetchedMap['resourceId'] as String?,
      iban: fetchedMap['iban'] as String?,
      bban: fetchedMap['bban'] as String?,
      msisdn: fetchedMap['msisdn'] as String?,
      currency: fetchedMap['currency'] as String,
      ownerName: fetchedMap['ownerName'] as String?,
      name: fetchedMap['name'] as String?,
      displayName: fetchedMap['displayName'] as String?,
      product: fetchedMap['product'] as String?,
      cashAccountType: fetchedMap['cashAccountType'] as String?,
      status: fetchedMap['status'] as String?,
      bic: fetchedMap['bic'] as String?,
      linkedAccounts: fetchedMap['linkedAccounts'] as String?,
      usage: fetchedMap['usage'] as String?,
      details: fetchedMap['details'] as String?,
      balances: fetchedMap['balances'] != null
          ? (fetchedMap['balances'] as List<dynamic>)
              .map<Balance>(
                  (dynamic balanceData) => Balance.fromMap(balanceData))
              .toList()
          : null,
      links: fetchedMap['_links'] as List<String>?,
    );
  }

  /// Forms a [Map] of [String] keys and [dynamic] values from Class Data.
  ///
  /// Map Keys: "id", "name", "bic" and "countries"
  Map<String, dynamic> toMap() => <String, dynamic>{
        'resourceId': id,
        'iban': iban,
        'bban': bban,
        'msisdn': msisdn,
        'currency': currency,
        'ownerName': ownerName,
        'name': name,
        'displayName': displayName,
        'product': product,
        'cashAccountType': cashAccountType,
        'status': status,
        'bic': bic,
        'linkedAccounts': linkedAccounts,
        'usage': usage,
        'details': details,
        'balances': balances
            ?.map<Map<String, dynamic>>((Balance balance) => balance.toMap())
            .toList(),
        '_links': links,
      };

  /// The ID of this Account, used to refer to this account in other API calls.
  final String? id;

  /// This data element is used for payment accounts which have no IBAN.
  final String? iban;

  // This data element is used for payment accounts which have no IBAN
  final String? bban;

  /// An alias to a payment account via a registered mobile phone number.
  final String? msisdn;

  /// Account currency
  final String currency;

  /// Name of the legal account owner. If there is more than one owner,
  /// then two names might be noted here.
  final String? ownerName;

  /// Name of the account, as assigned by the Institution.
  final String? name;

  /// Name of the account as defined by the PSU within online channels.
  final String? displayName;

  /// Product Name of the Bank for this account, proprietary definition.
  final String? product;

  /// The processing status of this account.
  final String? cashAccountType;

  /// Account status. The value is one of the following:
  ///    "enabled": account is available
  ///    "deleted": account is terminated
  ///    "blocked": account is blocked e.g. for legal reasons
  ///
  /// If this field is not used, then the account is available in the sense
  /// of this specification.
  final String? status;

  /// The BIC associated to the account.
  final String? bic;

  /// This data attribute is a field, where an Institution can name a cash
  /// account associated to pending card transactions.
  final String? linkedAccounts;

  /// Specifies the usage of the account.
  ///    PRIV: private personal account
  ///    ORGA: professional account
  final String? usage;

  /// Specifications that might be provided by the Institution.
  final String? details;

  /// List of Balances associated with the account.
  final List<Balance>? balances;

  /// The following links could be used here: transactionDetails for retrieving
  /// details of a transaction.
  final List<String>? links;

  /// Returns the class data converted to a map as a Serialized JSON String.
  @override
  String toString() => jsonEncode(toMap());
}

/// Nordigen Account Meta Data Model
///
/// Refer https://nordigen.com/en/docs/account-information/overview/parameters-and-responses/
///
/// Contains the [id] of the Bank Account, its [created] and [lastAccessed] date
/// and time as ISO String, [iban], [status] and the
/// [institutionID] identifiying its Institution.
class AccountMetaData {
  AccountMetaData({
    required this.id,
    String? created,
    this.lastAccessed,
    required this.iban,
    required this.institutionID,
    this.status = '',
  }) : created = created ?? DateTime.now().toIso8601String();

  /// For easy Data Model Generation from Map fetched by querying Nordigen.
  factory AccountMetaData.fromMap(dynamic fetchedMap) => AccountMetaData(
        id: fetchedMap['id']! as String,
        created: fetchedMap['created']! as String,
        lastAccessed: fetchedMap['last_accessed'] as String?,
        iban: fetchedMap['iban']! as String,
        institutionID: fetchedMap['institution_id']! as String,
        status: fetchedMap['status'] is String?
            ? fetchedMap['status'] ?? ''
            : fetchedMap['status']?.toString() ?? '',
      );

  /// Forms a [Map] of [String] keys and [dynamic] values from Class Data.
  ///
  /// Map Keys: "id", "name", "bic" and "countries"
  Map<String, dynamic> toMap() => <String, dynamic>{
        'id': id,
        'created': created,
        'last_accessed': lastAccessed,
        'iban': iban,
        'institution_id': institutionID,
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

  /// The ID of the Institution (bank) associated with this account.
  final String institutionID;

  /// The processing status of this account.
  final String status;

  /// Returns the class data converted to a map as a Serialized JSON String.
  @override
  String toString() => jsonEncode(toMap());
}
