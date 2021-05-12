import 'package:flutter_test/flutter_test.dart';

import 'package:nordigen_integration/nordigen_integration.dart';

void main() {
  test('adds one to input values', () {
    final nordigenObject = NordigenAPI();
    expect(nordigenObject.addOne(2), 3);
    expect(nordigenObject.addOne(-7), -6);
    expect(nordigenObject.addOne(0), 1);
  });
}
