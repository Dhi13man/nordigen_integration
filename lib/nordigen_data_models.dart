part of 'nordigen_integration.dart';

/// ASPSP (Bank) Data Model for Nordigen
///
/// Contains the [id] of the ASPSP, its [name], [bic] and the [countries] associated with the ASPSP.
class ASPSP {
  const ASPSP({
    @required this.id,
    this.name = '',
    this.bic = '',
    this.countries = const <String>[],
  }) : assert(id != null);

  /// For easy Data Model Generation from Map fetched by querying Nordigen Server.
  factory ASPSP.fromMap(dynamic fetchedMap) {
    return ASPSP(
      id: fetchedMap['id'] as String,
      name: (fetchedMap['name'] as String) ?? '',
      bic: (fetchedMap['bic'] as String) ?? '',
      countries: (fetchedMap['countries'] as List<dynamic>)
              .map<String>((dynamic country) => country.toString())
              .toList() ??
          const <String>[],
    );
  }

  /// Forms a [Map] of [String] keys and [dynamic] values from Class Data.
  ///
  /// Map Keys: "id", "name", "bic" and "countries"
  Map<String, dynamic> toMap() =>
      {'id': id, 'name': name, 'bic': bic, 'countries': countries};

  /// Identifier of this particular ASPSP
  final String id;

  /// ASPSP Name
  final String name;

  /// BIC of the ASPSP
  final String bic;

  /// Countries associated with the ASPSP
  final List<dynamic> countries;

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
  const EndUserAgreementModel({
    @required this.id,
    this.created,
    this.accepted,
    this.maxHistoricalDays,
    this.accessValidForDays,
    @required this.endUserID,
    @required this.aspspID,
  })  : assert(id != null),
        assert(endUserID != null),
        assert(aspspID != null);

  /// For easy Data Model Generation from Map fetched by querying Nordigen Server.
  factory EndUserAgreementModel.fromMap(dynamic fetchedMap) {
    return EndUserAgreementModel(
      id: fetchedMap['id'],
      created: (fetchedMap['created'] as String) ?? '',
      accepted: (fetchedMap['accepted'] as String) ?? '',
      maxHistoricalDays: fetchedMap['max_historical_days'] as int,
      accessValidForDays: fetchedMap['access_valid_for_days'] as int,
      endUserID: fetchedMap['enduser_id'] as String ?? '',
      aspspID: fetchedMap['aspsp_id'] as String ?? '',
    );
  }

  /// Forms a [Map] of [String] keys and [dynamic] values from Class Data.
  ///
  /// Map Keys: "id", "created", "accepted", "max_historical_days",
  /// "access_valid_for_days", "enduser_id" and "aspsp_id"
  Map<String, dynamic> toMap() => {
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

  /// Time of End User Agreement acceptance (if any) in ISO8601 DateTime String Format
  final dynamic accepted;

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
    @required this.id,
    @required this.redirectURL,
    @required this.reference,
    this.status = '',
    this.agreements = const <String>[],
    this.accounts = const <String>[],
    @required this.endUserID,
  })  : assert(id != null),
        assert(redirectURL != null),
        assert(reference != null),
        assert(endUserID != null);

  /// For easy Data Model Generation from Map fetched by querying Nordigen Server.
  factory RequisitionModel.fromMap(dynamic fetchedMap) {
    return RequisitionModel(
      id: fetchedMap['id'] as String,
      redirectURL: fetchedMap['redirect'] as String,
      reference: fetchedMap['reference'] as String,
      status: (fetchedMap['status'] as String) ?? '',
      agreements: (fetchedMap['agreements'] as List)
              .map<String>((dynamic agreement) => agreement.toString())
              .toList() ??
          const <String>[],
      accounts: (fetchedMap['accounts'] as List)
              .map<String>((dynamic agreement) => agreement.toString())
              .toList() ??
          const <String>[],
      endUserID: fetchedMap['enduser_id'] as String,
    );
  }

  /// Forms a [Map] of [String] keys and [dynamic] values from Class Data.
  ///
  /// Map Keys: "id", "redirect", "status", "agreements", "accounts",
  /// "reference" and "enduser_id"
  Map<String, dynamic> toMap() => {
        'id': id,
        'redirect': redirectURL,
        'status': status,
        'agreements': agreements,
        'accounts': accounts,
        'reference': reference,
        'enduser_id': endUserID,
      };

  /// Identifier of this particular Requisition (typically UUID) (Used to link accounts)
  final String id;

  /// Link where the end user will be redirected after finishing authentication in ASPSP.
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
  const BankAccountDetails({
    @required this.id,
    @required this.created,
    this.lastAccessed = '',
    @required this.iban,
    @required this.aspspIdentifier,
    this.status = '',
  })  : assert(id != null),
        assert(iban != null),
        assert(aspspIdentifier != null);

  /// For easy Data Model Generation from Map fetched by querying Nordigen Server.
  factory BankAccountDetails.fromMap(dynamic fetchedMap) {
    return BankAccountDetails(
      id: fetchedMap['id'] as String,
      created: (fetchedMap['created'] as String),
      lastAccessed: (fetchedMap['last_accessed'] as String) ?? '',
      iban: fetchedMap['iban'] as String,
      aspspIdentifier: fetchedMap['aspsp_identifier'] as String,
      status: (fetchedMap['status'] as String) ?? '',
    );
  }

  /// Forms a [Map] of [String] keys and [dynamic] values from Class Data.
  ///
  /// Map Keys: "id", "name", "bic" and "countries"
  Map<String, dynamic> toMap() => {
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
  final String lastAccessed;

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
/// Contains the [id] of the Transaction, its [debtorName] and [bankTransactionCode],
/// [bookingDate] and [valueDate] as [String], [transactionAmount] as [TransactionAmountData]
/// and its [remittanceInformationUnstructured].
class TransactionData {
  const TransactionData({
    @required this.id,
    this.debtorName,
    this.bankTransactionCode,
    this.bookingDate,
    this.valueDate,
    this.transactionAmount,
    this.remittanceInformationUnstructured = '',
  }) : assert(id != null);

  /// For easy Data Model Generation from Map fetched by querying Nordigen Server.
  factory TransactionData.fromMap(dynamic fetchedMap) {
    return TransactionData(
      id: fetchedMap['id'],
      debtorName: (fetchedMap['debtorName'] as String) ?? '',
      bankTransactionCode: (fetchedMap['bankTransactionCode'] as String) ?? '',
      bookingDate: fetchedMap['bookingDate'] as String,
      valueDate: fetchedMap['valueDate'] as String,
      transactionAmount: TransactionAmountData(
        amount: fetchedMap['transactionAmount'] != null
            ? fetchedMap['transactionAmount']['amount'] as String
            : null,
        currency: fetchedMap['transactionAmount'] != null
            ? fetchedMap['transactionAmount']['currency'] as String
            : null,
      ),
      remittanceInformationUnstructured:
          fetchedMap['remittanceInformationUnstructured'] as String,
    );
  }

  /// Forms a [Map] of [String] keys and [dynamic] values from Class Data.
  ///
  /// Map Keys: "id", "debtorName", "bankTransactionCode", "bookingDate",
  /// "valueDate", "transactionAmount" and "remittanceInformationUnstructured"
  Map<String, dynamic> toMap() => {
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
  final String debtorName;

  /// Transaction Code
  final String bankTransactionCode;

  /// Date of Booking as [String].
  final String bookingDate;

  /// Value date as [String].
  final String valueDate;

  /// Transaction amount details associated with this.
  final TransactionAmountData transactionAmount;

  /// Unstructured Remittance information about the Transaction (if any)
  final String remittanceInformationUnstructured;

  /// Returns the class data converted to a map as a Serialized JSON String.
  @override
  String toString() => jsonEncode(toMap());
}

/// Holds the transaction [amount] and the [currency] type
class TransactionAmountData {
  const TransactionAmountData({@required this.amount, @required this.currency})
      : assert(amount != null),
        assert(currency != null);
  final String currency;
  final String amount;

  double get getAmountNumber => double.tryParse(amount);

  /// Forms a [Map] of [String] keys and [dynamic] values from Class Data.
  ///
  /// Map Keys: "amount" and "currency".
  Map<String, dynamic> toMap() => {'amount': amount, 'currency': currency};

  /// Returns the class data converted to a map as a Serialized JSON String.
  @override
  String toString() => jsonEncode(toMap());
}
