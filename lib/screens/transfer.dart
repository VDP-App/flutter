import 'package:flutter/material.dart';
import 'package:vdp/documents/utils/transfer.dart';
import 'package:vdp/providers/apis/accept_transfer.dart';
import 'package:vdp/providers/apis/location.dart';
import 'package:vdp/providers/doc/stock.dart';
import 'package:vdp/utils/loading.dart';
import 'package:vdp/widgets/selectors/open_location_selector.dart';
import 'package:vdp/widgets/stocks/show_transfer_request.dart';
import 'package:provider/provider.dart';

class TransferList extends StatelessWidget {
  const TransferList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final location = Provider.of<Location>(context);
    final stockID = location.stockID;
    if (stockID == null) {
      return SelectLocationButton.fromLocation(location);
    }
    var stock = Provider.of<Stock>(context);
    final doc = stock.doc;
    if (doc == null) return loadingWigit;
    if (doc.transferNotifications.isEmpty) {
      return const NoData(text: "No Transfer to recive!");
    }
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 10, 8, 10),
      child: ListView.builder(
        itemCount: doc.transferNotifications.length * 2,
        itemBuilder: (context, i) {
          if (i.isOdd) return const Divider(thickness: 1.5);
          final transfer = doc.transferNotifications.elementAt(i ~/ 2);
          return ListTile(
            onTap: () => openTransferRequest(context, transfer, stockID),
            title: Text(
              transfer.uniqueID,
              style: const TextStyle(fontSize: 35),
            ),
            trailing: const Icon(
              Icons.get_app_rounded,
              size: 35,
              color: Colors.green,
            ),
            subtitle: Text(
              transfer.preview,
              style: const TextStyle(fontSize: 25),
            ),
          );
        },
      ),
    );
  }
}

void openTransferRequest(
  BuildContext context,
  TransferNotifications transfer,
  String stockID,
) {
  Navigator.push(context, MaterialPageRoute(builder: (context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ChangeNotifierProvider(
          create: (context) => AcceptTransfer(context, stockID, transfer),
          child: const ShowTransferRequest(),
        ),
      ),
    );
  }));
}
