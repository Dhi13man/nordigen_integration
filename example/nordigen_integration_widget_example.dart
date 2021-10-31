// import 'dart:math';

// import 'package:flutter/material.dart';
// import 'package:nordigen_integration/nordigen_integration.dart';
// import 'package:url_launcher/url_launcher.dart';

// void main() => runApp(
//       MaterialApp(
//         home: BankAppExample(),
//       ),
//     );

// class BankAppExample extends StatefulWidget {
//   @override
//   _BankAppExampleState createState() => _BankAppExampleState();
// }

// class _BankAppExampleState extends State<BankAppExample> {
//   final String token = 'YOUR_TOKEN';
//   int index = 0;
//   Widget? body;

//   @override
//   void initState() {
//     body ??= BankPickerWidget(token: token);
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Basic Widget Example')),
//       body: body,
//       bottomNavigationBar: BottomNavigationBar(
//         items: <BottomNavigationBarItem>[
//           BottomNavigationBarItem(
//             icon: Icon(Icons.list),
//             label: 'Bank List',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.link),
//             label: 'Linked bank',
//           )
//         ],
//         onTap: (int idx) {
//           index = idx;
//           if (index == 1) {
//             body = BankListWidget(token: token);
//           } else {
//             body = BankPickerWidget(token: token);
//           }
//           setState(() {
//             index = idx;
//           });
//         },
//         currentIndex: index,
//       ),
//     );
//   }
// }

// /// Opens Redirect URL based on whatever bank is chosen
// class BankPickerWidget extends StatelessWidget {
//   BankPickerWidget({required this.token, Key? key}) : super(key: key);

//   final String token;

//   @override
//   Widget build(BuildContext context) {
//     final NordigenAccountInfoAPI apiInterface = NordigenAccountInfoAPI(
//       accessToken: token,
//     );
//     return FutureBuilder<List<Institution>>(
//       future: apiInterface.getInstitutionsForCountry(countryCode: 'gb'),
//       builder: (
//         BuildContext context,
//         AsyncSnapshot<List<Institution>> snapshot,
//       ) {
//         if (!snapshot.hasData)
//           return Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: const <Widget>[
//               Text('Loading banks...'),
//               SizedBox(height: 50),
//               CircularProgressIndicator(),
//             ],
//           );
//         final List<Institution> banks = snapshot.data ?? <Institution>[];
//         final String randomReference = Random().nextInt(99999999).toString();
//         return ListView.builder(
//           itemCount: banks.length,
//           itemBuilder: (BuildContext context, int index) => ListTile(
//             onTap: () async => launch(
//               await apiInterface.fetchRedirectLinkForRequisition(
//                 requisitionID: (await apiInterface.createRequisition(
//                   endUserID: 'exampleEndUser',
//                   redirect: 'http://www.yourwebpage.com/',
//                   reference: randomReference,
//                 ))
//                     .id,
//                 institutionID: banks[index].id,
//               ),
//             ),
//             title: Text(banks[index].name),
//             subtitle: Text(banks[index].id),
//             leading: Text(banks[index].bic),
//           ),
//         );
//       },
//     );
//   }
// }

// /// Class to store information from different endpoints
// class BankInformation {
//   BankInformation(this.accountID);

//   final String accountID;
//   late int transactionCount;
//   late String name;
//   late String iban;
//   late String lastAccessed;
// }

// /// Widget to list linked bank accounts
// class BankListWidget extends StatelessWidget {
//   BankListWidget({required this.token, Key? key}) : super(key: key);

//   final String token;

//   Future<List<BankInformation>> _findLinkedBank() async {
//     NordigenAccountInfoAPI apiInterface =
//         NordigenAccountInfoAPI(accessToken: token);
//     List<RequisitionModel> fetchedRequisitionModels =
//         await apiInterface.getRequisitions(limit: 400, offset: 0);
//     List<String> accountsIDs = <String>[];
//     for (RequisitionModel requisition in fetchedRequisitionModels) {
//       if (requisition.accounts.isNotEmpty) {
//         accountsIDs.addAll(requisition.accounts);
//       }
//     }
//     List<BankInformation> bankInformation = <BankInformation>[];
//     for (String accountID in accountsIDs) {
//       BankInformation info = BankInformation(accountID);
//       AccountDetails details =
//           await apiInterface.getAccountDetails(accountID: accountID);
//       AccountMetaData meta =
//           await apiInterface.getAccountMetaData(accountID: accountID);
//       Map<String, List<TransactionData>> transactions =
//           await apiInterface.getAccountTransactions(accountID: accountID);
//       info.name = details.name ?? details.displayName ?? 'No Name';
//       info.lastAccessed = meta.lastAccessed ?? 'Unknown';
//       info.transactionCount =
//           transactions['booked']!.length + transactions['pending']!.length;
//       info.iban = details.iban ?? 'No Iban';
//       bankInformation.add(info);
//     }
//     return bankInformation;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<List<BankInformation>>(
//       initialData: <BankInformation>[],
//       future: _findLinkedBank(),
//       builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
//         if (!snapshot.hasData)
//           return Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: const <Widget>[
//               Text('Loading banks...'),
//               SizedBox(height: 50),
//               CircularProgressIndicator(),
//             ],
//           );
//         return ListView.builder(
//           itemCount: snapshot.data.length,
//           itemBuilder: (BuildContext context, int index) {
//             BankInformation bank = snapshot.data[index];
//             return ListTile(
//               title: Text(bank.name),
//               subtitle: Text(
//                 '${bank.iban}|Last access : ${bank.lastAccessed}',
//               ),
//               trailing: Text(bank.transactionCount.toString()),
//             );
//           },
//         );
//       },
//     );
//   }
// }
