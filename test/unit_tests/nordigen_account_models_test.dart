import 'package:nordigen_integration/nordigen_integration.dart';
import 'package:test/test.dart';

Future<void> main() async {
  group(
    'Nordigen Account Models Unit Tests',
    () => <void>{
      test('Parse sample Account Models Data', () {
        // Arrange - Sample Data
        const Map<String, dynamic> sampleAccountJson = <String, dynamic>{
          'transactionId': 'uuid',
          'bookingDate': '2022-08-15',
          'valueDate': '2022-08-15',
          'transactionAmount': <String, String>{
            'amount': '-14.54',
            'currency': 'EUR'
          },
          'currencyExchange': <Map<String, String>>[
            <String, String>{
              'sourceCurrency': 'USD',
              'exchangeRate': '0.9771505376',
              'unitCurrency': 'USD',
              'targetCurrency': 'EUR',
              'quotationDate': '2022-08-15'
            }
          ],
          'creditorName': 'PAYPAL',
          'remittanceInformationUnstructured': '-',
          'remittanceInformationUnstructuredArray': <String>['-'],
          'additionalInformation': 'uuid',
          'bankTransactionCode': 'CODE'
        };

        // Act - Parse Data
        final TransactionData transactionData =
            TransactionData.fromMap(sampleAccountJson);

        // Assert - Check Data
        expect(transactionData.id, 'uuid');
        expect(transactionData.bookingDate, '2022-08-15');
        expect(transactionData.valueDate, '2022-08-15');
        expect(transactionData.transactionAmount.amount, '-14.54');
        expect(transactionData.transactionAmount.currency, 'EUR');
        expect(transactionData.currencyExchange.length, 1);
      }),
    },
  );
}
