part of 'package:nordigen_integration/nordigen_integration.dart';

extension NordigenRequisitionsEndpoints on NordigenAccountInfoAPI {
  /// Create a Requisition for the given [institutionID] and build a [redirect]
  /// link associated with it.
  ///
  /// Follow the link to start the end-user authentication process with the
  /// financial institution. Save the requisition ID (id in the response) as it
  /// will be later needed to retrieve the list of end-user accounts.
  ///
  /// Refer to Step 4.1 of Nordigen Account Information API documentation.
  ///
  /// [redirect] is the link where the end user will be redirected after
  /// finishing authentication in Institution.
  ///
  /// [institutionID] is the identifier of the Bank/Institution associated with
  /// the requisition.
  ///
  /// [agreement] is end user agreement ID from Step 3.
  ///
  /// [reference] is additional layer of unique ID. Should match Step 3 if done.
  /// Defined by you for internal referencing.
  ///
  /// [userLanguage] to enforce a language for all end user steps hosted by
  /// Nordigen passed as a two-letter country code (ISO 639-1).
  ///
  /// If [userLanguage] is not defined a language set in browser will be used
  /// to determine language.
  Future<RequisitionModel> createRequisitionAndBuildLink({
    required String redirect,
    required String institutionID,
    String? agreement,
    required String reference,
    String? userLanguage,
  }) async {
    // Make POST request and fetch output.
    final dynamic fetchedData = await _nordigenPoster(
      endpointUrl: 'https://bankaccountdata.gocardless.com/api/v2/requisitions/',
      data: <String, dynamic>{
        'redirect': redirect,
        'institution_id': institutionID,
        'agreement': agreement,
        'reference': reference,
        'user_language': userLanguage,
      }..removeWhere((_, dynamic value) => value == null),
    );
    // Form the recieved dynamic Map into RequisitionModel for convenience.
    return RequisitionModel.fromMap(fetchedData);
  }

  /// Get All Requisitions.
  ///
  /// Refer to Step 5 of Nordigen Account Information API documentation.
  Future<List<RequisitionModel>> getRequisitions({
    int limit = 100,
    int offset = 0,
  }) async {
    // Make GET request and fetch output.
    final Map<String, dynamic> fetchedData = await _nordigenGetter(
      endpointUrl:
          'https://bankaccountdata.gocardless.com/api/v2/requisitions/?limit=$limit&offset=$offset',
    );
    final List<dynamic> fetchedRequisitions = fetchedData['results'];
    // Form the recieved dynamic Map into RequisitionModel for convenience.
    return fetchedRequisitions
        .map<RequisitionModel>((dynamic requisitionData) =>
            RequisitionModel.fromMap(requisitionData))
        .toList();
  }

  /// Get the Requisition identified by [requisitionID].
  ///
  /// Refer to Step 5 of Nordigen Account Information API documentation.
  Future<RequisitionModel> getRequisitionUsingID({
    required String requisitionID,
  }) async {
    assert(requisitionID.isNotEmpty);
    // Make GET request and fetch output.
    final dynamic fetchedData = await _nordigenGetter(
      endpointUrl:
          'https://bankaccountdata.gocardless.com/api/v2/requisitions/$requisitionID/',
    );
    // Form the recieved dynamic Map into RequisitionModel for convenience.
    return RequisitionModel.fromMap(fetchedData);
  }

  /// Delete the Requisition identified by [requisitionID].
  ///
  /// Refer to Step 5 of Nordigen Account Information API documentation.
  Future<void> deleteRequisitionUsingID({
    required String requisitionID,
  }) async =>
      await _nordigenDeleter(
        endpointUrl:
            'https://bankaccountdata.gocardless.com/api/v2/requisitions/$requisitionID/',
      );
}
