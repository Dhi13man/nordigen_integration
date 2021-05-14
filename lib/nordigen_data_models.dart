part of 'nordigen_integration.dart';

/// ASPSP (Bank) Data Model for Nordigen
///
/// Contains the [id] of the ASPSP, its [name], [bic]
/// and the [countries] associated with the ASPSP.
class ASPSP {
  const ASPSP({
    required this.id,
    required this.name,
    this.bic = '',
    this.transactionTotalDays = 90,
    required this.countries,
  });

  /// For easy Data Model Generation from Map fetched by querying Nordigen.
  factory ASPSP.fromMap(dynamic fetchedMap) {
    // Validate data first.
    assert(fetchedMap['id'] != null);
    assert(fetchedMap['name'] != null);
    assert(fetchedMap['countries'] != null);
    return ASPSP(
      id: fetchedMap['id'] as String,
      name: fetchedMap['name'] as String,
      bic: (fetchedMap['bic'] ?? '') as String,
      transactionTotalDays: int.tryParse(
            (fetchedMap['transaction_total_days'] ?? '90') as String,
          ) ??
          90,
      countries: (fetchedMap['countries'] as List<dynamic>)
          .map<String>((dynamic country) => country.toString())
          .toList(),
    );
  }

  /// Forms a [Map] of [String] keys and [dynamic] values from Class Data.
  ///
  /// Map Keys: "id", "name", "bic" and "countries"
  Map<String, dynamic> toMap() => <String, dynamic>{
        'id': id,
        'name': name,
        'bic': bic,
        'transaction_total_days': transactionTotalDays,
        'countries': countries,
      };

  /// Identifier of this particular ASPSP
  final String id;

  /// ASPSP Name
  final String name;

  /// BIC of the ASPSP.
  final String bic;

  /// Represents the total transaction days for the ASPSP.
  final int transactionTotalDays;

  /// Countries associated with the ASPSP
  final List<String> countries;

  /// Returns the class data converted to a map as a Serialized JSON String.
  @override
  String toString() => jsonEncode(toMap());
}

/// End-user Agreement Data Model for Nordigen
///
/// Contains the [id] of the Agreement, its [created] time string, [accepted],
/// the number of [maxHistoricalDays] and [accessValidForDays],
/// and the [endUserID] and [aspspID] relevant to the Agreement.
class EndUserAgreementModel {
  EndUserAgreementModel({
    required this.id,
    String? created,
    this.accepted,
    this.maxHistoricalDays = 90,
    this.accessValidForDays = 90,
    required this.endUserID,
    required this.aspspID,
  }) : created = created ?? DateTime.now().toIso8601String();

  /// For easy Data Model Generation from Map fetched by querying Nordigen.
  factory EndUserAgreementModel.fromMap(dynamic fetchedMap) {
    // Validate data first.
    assert(fetchedMap['id'] != null);
    assert(fetchedMap['created'] != null);
    assert(fetchedMap['enduser_id'] != null);
    assert(fetchedMap['aspsp_id'] != null);
    return EndUserAgreementModel(
      id: fetchedMap['id'] as String,
      created: fetchedMap['created'] as String,
      accepted: fetchedMap['accepted'] as String?,
      maxHistoricalDays: fetchedMap['max_historical_days'] as int,
      accessValidForDays: fetchedMap['access_valid_for_days'] as int,
      endUserID: fetchedMap['enduser_id'] as String,
      aspspID: fetchedMap['aspsp_id'] as String,
    );
  }

  /// Forms a [Map] of [String] keys and [dynamic] values from Class Data.
  ///
  /// Map Keys: "id", "created", "accepted", "max_historical_days",
  /// "access_valid_for_days", "enduser_id" and "aspsp_id"
  Map<String, dynamic> toMap() => <String, dynamic>{
        'id': id,
        'created': created,
        'accepted': accepted,
        'max_historical_days': maxHistoricalDays,
        'access_valid_for_days': accessValidForDays,
        'enduser_id': endUserID,
        'aspsp_id': aspspID,
      };

  /// Identifier of this particular End User Agreement
  final String id;

  /// Time of End User Agreement creation in ISO8601 DateTime [String] Format
  final String created;

  /// Time of End User Agreement acceptance (if any) in ISO8601 DateTime String
  final String? accepted;

  /// Maximum Historical Days for the agreement.
  final int maxHistoricalDays;

  /// Days that the agreement is valid for.
  final int accessValidForDays;

  /// User ID associated with the transaction (typically UUID)
  final String endUserID;

  /// ID of the ASPSP (bank) associated with the transaction
  final String aspspID;

  /// Returns the class data converted to a map as a Serialized JSON String.
  @override
  String toString() => jsonEncode(toMap());
}

/// Requisition Model for Nordigen.
///
/// Contains the [id] of the Requisition, its [status], end-user [agreements],
/// the [redirectURL] to which it should redirect, [reference] ID if any,
/// [accounts] associated, and the associated [endUserID].
class RequisitionModel {
  const RequisitionModel({
    required this.id,
    required this.redirectURL,
    required this.reference,
    this.status = '',
    this.agreements = const <String>[],
    this.accounts = const <String>[],
    required this.endUserID,
  });

  /// For easy Data Model Generation from Map fetched by querying Nordigen.
  factory RequisitionModel.fromMap(dynamic fetchedMap) {
    // Validate data first.
    assert(fetchedMap['id'] != null);
    assert(fetchedMap['redirect'] != null);
    assert(fetchedMap['reference'] != null);
    assert(fetchedMap['enduser_id'] != null);
    return RequisitionModel(
      id: fetchedMap['id'] as String,
      redirectURL: fetchedMap['redirect'] as String,
      reference: fetchedMap['reference'] as String,
      status: (fetchedMap['status'] ?? '') as String,
      agreements:
          ((fetchedMap['agreements'] ?? const <String>[]) as List<dynamic>)
              .map<String>((dynamic agreement) => agreement.toString())
              .toList(),
      accounts: ((fetchedMap['accounts'] ?? const <String>[]) as List<dynamic>)
          .map<String>((dynamic agreement) => agreement.toString())
          .toList(),
      endUserID: fetchedMap['enduser_id'] as String,
    );
  }

  /// Forms a [Map] of [String] keys and [dynamic] values from Class Data.
  ///
  /// Map Keys: "id", "redirect", "status", "agreements", "accounts",
  /// "reference" and "enduser_id"
  Map<String, dynamic> toMap() => <String, dynamic>{
        'id': id,
        'redirect': redirectURL,
        'status': status,
        'agreements': agreements,
        'accounts': accounts,
        'reference': reference,
        'enduser_id': endUserID,
      };

  /// Identifier (typically UUID) of this Requisition used to link accounts
  final String id;

  /// Link where end user will be redirected for authenticating in ASPSP.
  final String redirectURL;

  /// Status of the Requisition
  final String status;

  /// Agreements associated with the Requistion
  final List<String> agreements;

  /// Agreements associated with the Requistion
  final List<String> accounts;

  /// Additional layer of unique ID defined by user.
  final String reference;

  /// User ID associated with the transaction (typically UUID)
  final String endUserID;

  /// Returns the class data converted to a map as a Serialized JSON String.
  @override
  String toString() => jsonEncode(toMap());
}

/// Bank Account Data Model
///
/// Contains the [id] of the Bank Account, its [created] and [lastAccessed] date
/// and time, [iban], [status] and the [aspspIdentifier] identifiying its ASPSP.
class BankAccountDetails {
  BankAccountDetails({
    required this.id,
    String? created,
    this.lastAccessed,
    required this.iban,
    required this.aspspIdentifier,
    this.status = '',
  }) : created = created ?? DateTime.now().toIso8601String();

  /// For easy Data Model Generation from Map fetched by querying Nordigen.
  factory BankAccountDetails.fromMap(dynamic fetchedMap) {
    // Validate data first.
    assert(fetchedMap['id'] != null);
    assert(fetchedMap['created'] != null);
    assert(fetchedMap['iban'] != null);
    assert(fetchedMap['aspsp_identifier'] != null);
    return BankAccountDetails(
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

/// Transaction Data Model for Nordigen.
///
/// Contains [id] of Transaction, its [debtorName] and [bankTransactionCode],
/// [bookingDate] and [valueDate] as [String], [transactionAmount] as
/// [TransactionAmountData] and its [remittanceInformationUnstructured].
class TransactionData {
  const TransactionData({
    required this.id,
    this.debtorName,
    this.debtorAccount,
    this.bankTransactionCode,
    this.bookingDate = '',
    this.valueDate = '',
    required this.transactionAmount,
    this.remittanceInformationUnstructured = '',
  });

  /// For easy Data Model Generation from Map fetched by querying Nordigen.
  factory TransactionData.fromMap(dynamic fetchedMap) {
    // Validate data first.
    assert(fetchedMap['id'] != null);
    assert(fetchedMap['transactionAmount'] != null);
    assert(fetchedMap['transactionAmount']['amount'] != null);
    assert(fetchedMap['transactionAmount']['currency'] != null);
    return TransactionData(
      id: fetchedMap['id'] as String,
      debtorName: fetchedMap['debtorName'] as String?,
      debtorAccount: fetchedMap['debtorAccount'] as Map<String, dynamic>,
      bankTransactionCode: fetchedMap['bankTransactionCode'] as String?,
      bookingDate: fetchedMap['bookingDate'] as String,
      valueDate: fetchedMap['valueDate'] as String,
      transactionAmount: TransactionAmountData(
        amount: fetchedMap['transactionAmount']['amount'] as String,
        currency: fetchedMap['transactionAmount']['currency'] as String,
      ),
      remittanceInformationUnstructured:
          fetchedMap['remittanceInformationUnstructured'] as String?,
    );
  }

  /// Forms a [Map] of [String] keys and [dynamic] values from Class Data.
  ///
  /// Map Keys: "id", "debtorName", "bankTransactionCode", "bookingDate",
  /// "valueDate", "transactionAmount" and "remittanceInformationUnstructured"
  Map<String, dynamic> toMap() => <String, dynamic>{
        'id': id,
        'debtorName': debtorName,
        'bankTransactionCode': bankTransactionCode,
        'bookingDate': bookingDate,
        'valueDate': valueDate,
        'transactionAmount': transactionAmount,
        'remittanceInformationUnstructured': remittanceInformationUnstructured,
      };

  /// Identifier of this particular Transaction
  final String id;

  /// Name of the Transaction debtor (if any)
  final String? debtorName;

  /// Debtor Account Map (if any)
  /// TODO: Implement this better. Couldn't find exact model in docs.
  final Map<String, dynamic>? debtorAccount;

  /// Transaction Code
  final String? bankTransactionCode;

  /// Date of Booking as [String].
  final String bookingDate;

  /// Value date as [String].
  final String valueDate;

  /// Transaction amount details associated with this.
  final TransactionAmountData transactionAmount;

  /// Unstructured Remittance information about the Transaction (if any)
  final String? remittanceInformationUnstructured;

  /// Returns the class data converted to a map as a Serialized JSON String.
  @override
  String toString() => jsonEncode(toMap());
}

/// Holds the transaction [amount] and the [currency] type
class TransactionAmountData {
  const TransactionAmountData({required this.amount, required this.currency});

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
