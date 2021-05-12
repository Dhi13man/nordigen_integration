import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

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

  factory ASPSP.fromMap(Map<String, dynamic> fetchedMap) {
    return ASPSP(
      id: fetchedMap['id'] as String,
      name: (fetchedMap['name'] as String) ?? '',
      bic: (fetchedMap['bic'] as String) ?? '',
      countries: (fetchedMap['countries'] as List<String>) ?? const <String>[],
    );
  }

  /// Identifier of this particular ASPSP
  final String id;

  /// ASPSP Name
  final String name;

  /// BIC of the ASPSP
  final String bic;

  /// Countries associated with the ASPSP
  final List<String> countries;
}

/// End-user Agreement Data Model for Nordigen
///
/// Contains the [id] of the agreement, its [created] time string, [accepted],
/// the [countries] associated with the ASPSP.
class EndUserAgreementModel {
  const EndUserAgreementModel({
    @required this.id,
    this.created,
    this.accepted,
    this.maxHistoricalDays,
    this.accessValidForDays,
    @required this.enduserID,
    @required this.aspspID,
  })  : assert(id != null),
        assert(enduserID != null),
        assert(aspspID != null);

  factory EndUserAgreementModel.fromMap(Map<String, dynamic> fetchedMap) {
    return EndUserAgreementModel(
      id: fetchedMap['id'],
      created: (fetchedMap['created'] as String) ?? '',
      accepted: (fetchedMap['accepted'] as String) ?? '',
      maxHistoricalDays: fetchedMap['max_historical_days'] as int,
      accessValidForDays: fetchedMap['access_valid_for_days'] as int,
      enduserID: fetchedMap['enduser_id'] as String ?? '',
      aspspID: fetchedMap['aspsp_id'] as String ?? '',
    );
  }

  /// Identifier of this particular End User Agreement
  final String id;

  /// Time of End User Agreement creation in ISO8601 DateTime String Format
  final String created;

  /// Time of End User Agreement acceptance (if any) in ISO8601 DateTime String Format
  final dynamic accepted;

  /// Maximum Historical Days for the agreement.
  final int maxHistoricalDays;

  /// Days that the agreement is valid for.
  final int accessValidForDays;

  /// User ID associated with the transaction (typically UUID)
  final String enduserID;

  /// ID of the ASPSP (bank) associated with the transaction
  final String aspspID;
}

/// ASPSP (Bank) Data Model for Nordigen
///
/// Contains the [id] of the ASPSP, its [name], [bic] and the [countries] associated with the ASPSP.
class RequisitionModel {
  RequisitionModel({
    @required this.id,
    this.redirectURL,
    this.status = '',
    this.agreements = const <String>[],
    this.accounts = const <String>[],
    this.reference = '',
    @required this.enduserID,
  })  : assert(id != null),
        assert(enduserID != null);

  factory RequisitionModel.fromMap(Map<String, dynamic> fetchedMap) {
    return RequisitionModel(
      id: fetchedMap['id'] as String,
      redirectURL: fetchedMap['redirect'] as String,
      status: (fetchedMap['status'] as String) ?? '',
      agreements:
          (fetchedMap['agreements'] as List<String>) ?? const <String>[],
      accounts: (fetchedMap['accounts'] as List<String>) ?? const <String>[],
      reference: fetchedMap['reference'] as String,
      enduserID: fetchedMap['enduser_id'] as String,
    );
  }

  /// Identifier of this particular Requisition (typically UUID) (Used to link accounts)
  final String id;

  /// Link where the end user will be redirected after finishing authentication in ASPSP.
  String redirectURL;

  /// Status of the Requisition
  final String status;

  /// Agreements associated with the Requistion
  final List<String> agreements;

  /// Agreements associated with the Requistion
  final List<String> accounts;

  /// Additional layer of unique ID defined by user.
  final String reference;

  /// User ID associated with the transaction (typically UUID)
  final String enduserID;

  Future<void> getRedirectURL(String aspID, String token) async {
    final Uri requestURL =
        Uri.parse('https://ob.nordigen.com/api/requisitions/$id/links/');
    await http.post(
      requestURL,
      headers: <String, String>{
        'accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Token $token',
      },
      body: jsonEncode({'aspsp_id': aspID}),
    );
  }
}
