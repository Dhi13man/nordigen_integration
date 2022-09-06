import 'package:nordigen_integration/nordigen_integration.dart';
import 'package:test/test.dart';

Future<void> main() async {
  group(
    'Nordigen Account Models Unit Tests',
    () => <void>{
      test('Parse Account Details', () {
        // Arrange - Sample Data
        const Map<String, dynamic> sampleMap = <String, dynamic>{
          'resourceId': '0df01281-2408-5dbe-92f2-96b2c1cc08e1',
          'iban': 'DE26100110012622221111',
          'bban': '333322221111',
          'currency': 'EUR',
          'name': 'Main Account',
          'product': 'Main Product',
          'cashAccountType': 'CACC',
          'status': 'enabled',
          'bic': 'NTSBDEB1XXX',
          'usage': 'PRIV'
        };

        // Act - Parse Data
        final AccountDetails result = AccountDetails.fromMap(sampleMap);

        // Assert - Check Data
        expect(result.id, '0df01281-2408-5dbe-92f2-96b2c1cc08e1');
        expect(result.iban, 'DE26100110012622221111');
        expect(result.bban, '333322221111');
        expect(result.currency, 'EUR');
        expect(result.name, 'Main Account');
        expect(result.product, 'Main Product');
        expect(result.cashAccountType, 'CACC');
        expect(result.status, 'enabled');
        expect(result.bic, 'NTSBDEB1XXX');
        expect(result.usage, 'PRIV');
      }),
      test('Parse sample Account Model Transaction Data', () {
        // Arrange - Sample Data
        const Map<String, dynamic> sampleTransactionMap = <String, dynamic>{
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
            TransactionData.fromMap(sampleTransactionMap);

        // Assert - Check Data
        expect(transactionData.id, 'uuid');
        expect(transactionData.bookingDate, '2022-08-15');
        expect(transactionData.valueDate, '2022-08-15');
        expect(transactionData.transactionAmount.amount, '-14.54');
        expect(transactionData.transactionAmount.currency, 'EUR');
        expect(transactionData.currencyExchange!.length, 1);
      }),
      test('Parse List of sample Account Model Transaction Data', () {
        // Arrange - Sample Data
        const List<Map<String, dynamic>> sampleTransactionMapList =
            <Map<String, dynamic>>[
          <String, dynamic>{
            'transactionId': 'uuid',
            'bookingDate': '2022-08-15',
            'valueDate': '2022-08-15',
            'transactionAmount': <String, String>{
              'amount': '-14.54',
              'currency': 'EUR',
            },
            'currencyExchange': <Map<String, String>>[
              <String, String>{
                'sourceCurrency': 'USD',
                'exchangeRate': '0.9771505376',
                'unitCurrency': 'USD',
                'targetCurrency': 'EUR',
                'quotationDate': '2022-08-15',
              }
            ],
            'creditorName': 'PAYPAL',
            'remittanceInformationUnstructured': '-',
            'remittanceInformationUnstructuredArray': <String>['-'],
            'additionalInformation': 'uuid',
            'bankTransactionCode': 'CODE',
          },
          <String, dynamic>{
            'transactionId': 'uuid-1',
            'bookingDate': '2022-08-16',
            'valueDate': '2022-08-16',
            'transactionAmount': <String, String>{
              'amount': '-150.0',
              'currency': 'EUR',
            },
            'creditorName': 'Someone',
            'creditorAccount': <String, String>{'iban': 'DE87100110535353906'},
            'remittanceInformationUnstructured': 'MoneyBeam',
            'remittanceInformationUnstructuredArray': <String>['MoneyBeam'],
            'bankTransactionCode': 'ICDT',
          },
          <String, dynamic>{
            'transactionId': 'uuid-2',
            'bookingDate': '2022-08-16',
            'valueDate': '2022-08-16',
            'transactionAmount': <String, dynamic>{
              'amount': '300.0',
              'currency': 'EUR',
            },
            'debtorName': 'JOHN DOE',
            'debtorAccount': <String, dynamic>{'iban': 'DE047008000543427500'},
            'bankTransactionCode': 'PMNT-ESCT',
          },
          <String, dynamic>{
            'transactionId': 'uuid-3',
            'bookingDate': '2022-08-15',
            'valueDate': '2022-08-15',
            'transactionAmount': <String, dynamic>{
              'amount': '-3.1',
              'currency': 'EUR',
            },
            'creditorName': 'TICKETSHOP',
            'remittanceInformationUnstructured': '-',
            'remittanceInformationUnstructuredArray': <String>['-'],
            'additionalInformation': '90ef-4147-aa2e',
            'bankTransactionCode': 'PMNT-CCRD',
          }
        ];

        for (Map<String, dynamic> transactionMap in sampleTransactionMapList) {
          // Act - Parse Data
          final TransactionData transactionData =
              TransactionData.fromMap(transactionMap);

          // Assert - Check Data
          expect(transactionData.id, transactionMap['transactionId']);
          expect(transactionData.bookingDate, transactionMap['bookingDate']);
          expect(transactionData.valueDate, transactionMap['valueDate']);
          expect(transactionData.transactionAmount.amount,
              transactionMap['transactionAmount']['amount']);
          expect(transactionData.transactionAmount.currency,
              transactionMap['transactionAmount']['currency']);
          expect(transactionData.currencyExchange?.length ?? 0,
              transactionMap['currencyExchange']?.length ?? 0);
        }
      })
    },
  );
}
