import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:nordigen_integration/nordigen_integration.dart';

void main() => runApp(
      MaterialApp(
        home: Scaffold(
          appBar: AppBar(title: Text('Basic Widget Example')),
          body: BankPickerWidget(),
        ),
      ),
    );

/// Opens Redirect URL based on whatever bank is chosen
class BankPickerWidget extends StatelessWidget {
  const BankPickerWidget({
    Key key,
    EdgeInsets listItemPadding,
    EdgeInsets margin,
    double height,
    double width,
  })  : _listItemPadding = listItemPadding ?? const EdgeInsets.all(2),
        _margin = margin ?? const EdgeInsets.all(10),
        _width = width,
        _height = height,
        super(key: key);

  final EdgeInsets _listItemPadding;

  final EdgeInsets _margin;

  final double _height, _width;

  @override
  Widget build(BuildContext context) {
    final NordigenAccountInfoAPI apiInterface = NordigenAccountInfoAPI(
      accessToken: 'YOUR_TOKEN',
    );
    return Container(
      margin: _margin,
      height: _height,
      width: _width,
      child: Expanded(
        child: FutureBuilder(
          future: apiInterface.getBanksForCountry(countryCode: 'gb'),
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Loading banks...'),
                  SizedBox(height: 50),
                  CircularProgressIndicator(),
                ],
              );
            List<ASPSP> banks = snapshot.data;
            return ListView.builder(
              itemBuilder: (context, index) => ListTile(
                contentPadding: _listItemPadding,
                onTap: () async => launch(
                  await apiInterface.fetchRedirectLinkForRequisition(
                    requisition: await apiInterface.createRequisition(
                      endUserID: 'exampleEndUser',
                      redirect: 'http://www.yourwebpage.com/',
                      reference: 'exampleReference1771',
                    ),
                    aspsp: banks[index],
                  ),
                ),
                title: Text('${banks[index].name}'),
                leading: Text('${banks[index].id}'),
                subtitle: Text('${banks[index].bic}'),
              ),
            );
          },
        ),
      ),
    );
  }
}
