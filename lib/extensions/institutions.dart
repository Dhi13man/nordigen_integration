part of 'package:nordigen_integration/nordigen_integration.dart';

extension NordigenInstitutionsEndpoints on NordigenAccountInfoAPI {
  /// Gets the Institutions (Banks) for the given [countryCode].
  ///
  /// Refer to Step 2 of Nordigen Account Information API documentation.
  /// [countryCode] is just two-letter country code (ISO 3166).
  Future<List<Institution>> getInstitutionsForCountry({
    required String countryCode,
  }) async {
    // Make GET request and fetch output.
    final List<dynamic> fetchedData = await _nordigenGetter(
          endpointUrl:
              'https://bankaccountdata.gocardless.com/api/v2/institutions/?country=$countryCode',
        ) ??
        <dynamic>[];
    // Map the recieved List<dynamic> into List<Institution> Data Format.
    return fetchedData
        .map<Institution>(
          (dynamic institutionItem) => Institution.fromMap(institutionItem),
        )
        .toList();
  }

  /// Get the Institution identified by [institutionID].
  Future<Institution> getInstitutionUsingID({
    required String institutionID,
  }) async {
    // Make GET request and fetch output.
    final dynamic fetchedData = await _nordigenGetter(
      endpointUrl:
          'https://bankaccountdata.gocardless.com/api/v2/institutions/$institutionID/',
    );
    // Form the recieved dynamic Map into RequisitionModel for convenience.
    return Institution.fromMap(fetchedData);
  }
}
