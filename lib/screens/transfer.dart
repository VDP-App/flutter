import 'package:flutter/material.dart';
import 'package:vdp/documents/utils/transfer.dart';
import 'package:vdp/providers/apis/accept_transfer.dart';
import 'package:vdp/providers/apis/location.dart';
import 'package:vdp/providers/doc/stock.dart';
import 'package:vdp/utils/loading.dart';
import 'package:vdp/utils/typography.dart';
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
      return SelectLocationButton.fromLocation(
          location, "To See Transfer entry");
    }
    var stock = Provider.of<Stock>(context);
    final doc = stock.doc;
    if (doc == null) return loadingWigit;
    if (doc.transferNotifications.isEmpty) {
      return const NoData(text: "No Transfer to recive!");
    }
    return ListView.builder(
      itemCount: doc.transferNotifications.length * 2,
      itemBuilder: (context, i) {
        if (i.isOdd) return const Divider(thickness: 1.5);
        final transfer = doc.transferNotifications.elementAt(i ~/ 2);
        return ListTile(
          onTap: () => openTransferRequest(context, transfer, stockID),
          title: T1(transfer.uniqueID),
          trailing: const IconT1(
            Icons.get_app_rounded,
            color: Colors.green,
          ),
          subtitle: P2(transfer.preview),
        );
      },
    );
  }
}

void openTransferRequest(
  BuildContext context,
  TransferNotifications transfer,
  String stockID,
) {
  Navigator.push(context, MaterialPageRoute(builder: (context) {
    return ChangeNotifierProvider(
      create: (context) => AcceptTransfer(context, stockID, transfer),
      child: const ShowTransferRequest(),
    );
  }));
}
