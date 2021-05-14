import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:nordigen_integration/nordigen_integration.dart';

void main() => runApp(
      MaterialApp(
        home: Scaffold(
          appBar: AppBar(title: const Text('Basic Widget Example')),
          body: const BankPickerWidget(),
        ),
      ),
    );

/// Opens Redirect URL based on whatever bank is chosen
class BankPickerWidget extends StatelessWidget {
  const BankPickerWidget({
    Key? key,
    EdgeInsets? listItemPadding,
    EdgeInsets? margin,
    double? height,
    double? width,
  })  : _listItemPadding = listItemPadding ?? const EdgeInsets.all(2),
        _margin = margin ?? const EdgeInsets.all(10),
        _width = width,
        _height = height,
        super(key: key);

  final EdgeInsets _listItemPadding;

  final EdgeInsets _margin;

  final double? _height, _width;

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
        child: FutureBuilder<List<ASPSP>>(
          future: apiInterface.getASPSPsForCountry(countryCode: 'gb'),
          builder: (BuildContext context, AsyncSnapshot<List<ASPSP>> snapshot) {
            if (!snapshot.hasData)
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const <Widget>[
                  Text('Loading banks...'),
                  SizedBox(height: 50),
                  CircularProgressIndicator(),
                ],
              );
            final List<ASPSP> banks = snapshot.data ?? <ASPSP>[];
            return ListView.builder(
              itemBuilder: (BuildContext context, int index) => ListTile(
                contentPadding: _listItemPadding,
                onTap: () async => launch(
                  await apiInterface.fetchRedirectLinkForRequisition(
                    requisitionID: (await apiInterface.createRequisition(
                      endUserID: 'exampleEndUser',
                      redirect: 'http://www.yourwebpage.com/',
                      reference: 'exampleReference1771',
                    ))
                        .id,
                    aspspID: banks[index].id,
                  ),
                ),
                title: Text(banks[index].name),
                leading: Text(banks[index].id),
                subtitle: Text(banks[index].bic),
              ),
            );
          },
        ),
      ),
    );
  }
}
