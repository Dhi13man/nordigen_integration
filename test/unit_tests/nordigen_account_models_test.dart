import 'package:nordigen_integration/nordigen_integration.dart';
import 'package:test/test.dart';

Future<void> main() async {
  group(
    'Nordigen Account Models Unit Tests',
    () => <void>{
      test(
        'Parse Account Details',
        () {
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
        },
      ),
    },
  );
}
