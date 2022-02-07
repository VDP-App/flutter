import 'package:flutter/material.dart';
import 'package:vdp/documents/utils/transfer.dart';
import 'package:vdp/providers/apis/accept_transfer.dart';
import 'package:vdp/providers/apis/location.dart';
import 'package:vdp/providers/doc/stock.dart';
import 'package:vdp/utils/build_list_page.dart';
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
    return BuildListPage<TransferNotifications>(
      wrapScaffold: true,
      buildChild: (context, transfer) {
        return ListTilePage(
          onClick: () => openTransferRequest(context, transfer, stockID),
          title: transfer.uniqueID,
          preview: Preview.text(P2(transfer.preview)),
          trailingWidgit: TrailingWidgit.icon(
            const IconT1(
              Icons.get_app_rounded,
              color: Colors.green,
            ),
          ),
        );
      },
      noDataText: "No Transfer to recive!",
      list: doc.transferNotifications,
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
