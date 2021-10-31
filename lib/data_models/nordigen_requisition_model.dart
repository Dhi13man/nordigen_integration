part of 'package:nordigen_integration/nordigen_integration.dart';

/// Requisition Model for Nordigen.
///
/// Contains the [id] of the Requisition, its [status], end-user [agreements],
/// the [redirectURL] to which it should redirect, [reference] ID if any,
/// [accounts] associated, and the associated [institutionID].
class RequisitionModel {
  RequisitionModel({
    required this.id,
    String? created,
    required this.redirectURL,
    this.status = const RequisitionStatus(short: '', long: '', description: ''),
    required this.institutionID,
    required this.agreement,
    required this.reference,
    this.accounts = const <String>[],
    this.userLanguage = 'EN',
    required this.link,
  }) : created = created ?? DateTime.now().toIso8601String();

  /// For easy Data Model Generation from Map fetched by querying Nordigen.
  factory RequisitionModel.fromMap(dynamic fetchedMap) => RequisitionModel(
        id: fetchedMap['id'] as String,
        created: fetchedMap['created'] as String,
        redirectURL: fetchedMap['redirect'] as String,
        status: fetchedMap['status'] == null
            ? const RequisitionStatus(short: '', long: '', description: '')
            : fetchedMap['status'] is Map<String, dynamic>
                ? RequisitionStatus.fromMap(fetchedMap['status'])
                : RequisitionStatus(
                    short: fetchedMap['status'],
                    long: fetchedMap['status'],
                    description: fetchedMap['status'],
                  ),
        institutionID: (fetchedMap['institution_id'] as String?) ?? '',
        agreement: fetchedMap['agreement'] as String,
        reference: fetchedMap['reference'] as String,
        accounts:
            ((fetchedMap['accounts'] ?? const <String>[]) as List<dynamic>)
                .map<String>((dynamic agreement) => agreement.toString())
                .toList(),
        userLanguage: (fetchedMap['user_language'] ?? 'EN') as String,
        link: fetchedMap['link'] as String,
      );

  /// Forms a [Map] of [String] keys and [dynamic] values from Class Data.
  ///
  /// Map Keys: "id", "redirect", "status", "agreements", "accounts",
  /// "reference" and "institution_id"
  Map<String, dynamic> toMap() => <String, dynamic>{
        'id': id,
        'created': created,
        'redirect': redirectURL,
        'status': status.toMap(),
        'institution_id': institutionID,
        'agreement': agreement,
        'reference': reference,
        'accounts': accounts,
        'user_language': userLanguage,
        'link': link,
      };

  /// Identifier (typically UUID) of this Requisition used to link accounts
  final String id;

  /// Timestamp of when the Requisition was created in ISO8601 DateTime String
  final String created;

  /// Link where end user will be redirected for authenticating in Institution.
  final String redirectURL;

  /// Status of the Requisition
  final RequisitionStatus status;

  /// Institution/Bank ID associated with the transaction (typically UUID)
  final String institutionID;

  /// End-User Agreement associated with the Requistion
  final String agreement;

  /// Additional layer of unique ID defined by user.
  final String reference;

  /// Agreements associated with the Requistion
  final List<String> accounts;

  /// [String] code of the Language of the requisition verification.
  final String userLanguage;

  /// Verification [String] link associated with the requisition.
  final String link;

  /// Returns the class data converted to a map as a Serialized JSON String.
  @override
  String toString() => jsonEncode(toMap());
}

/// Requistion Status Information
class RequisitionStatus {
  const RequisitionStatus({
    required this.short,
    required this.long,
    required this.description,
  });

  /// For easy Data Model Generation from Map fetched by querying Nordigen.
  ///
  /// Map Keys: "short", "long", "description"
  factory RequisitionStatus.fromMap(dynamic fetchedMap) => RequisitionStatus(
        short: fetchedMap['short'] as String,
        long: fetchedMap['long'] as String,
        description: fetchedMap['description'] as String,
      );

  /// Short status [String].
  final String short;

  /// Long status [String].
  final String long;

  /// [String] Description of the status.
  final String description;

  /// Forms a [Map] of [String] keys and [dynamic] values from Class Data.
  ///
  /// Map Keys: "short", "long", "description".
  Map<String, dynamic> toMap() => <String, dynamic>{
        'short': short,
        'long': long,
        'description': description,
      };

  @override
  String toString() => jsonEncode(toMap());
}
