import 'package:flutter/material.dart';
import 'package:vdp/documents/utils/bill.dart';
import 'package:vdp/utils/build_list_page.dart';
import 'package:vdp/utils/loading.dart';
import 'package:vdp/utils/typography.dart';

class ShowOrders extends StatelessWidget {
  const ShowOrders({
    Key? key,
    required this.orders,
    required this.onOrderSelect,
    required this.deleteOrder,
  }) : super(key: key);

  final List<Order> orders;
  final void Function(Order order) onOrderSelect;
  final void Function(Order order) deleteOrder;

  @override
  Widget build(BuildContext context) {
    return BuildListPage<Order>(
      topic: "Select Order",
      wrapScaffold: true,
      buildChild: (context, order) {
        return ListTilePage(
          onClick: () {
            onOrderSelect(order);
            Navigator.pop(context);
          },
          title: order.item.name,
          preview: Preview.text(P2("Quntity: " + order.quntity.text)),
          trailingWidgit: TrailingWidgit.text(P3(rs + order.amount.text)),
        );
      },
      onDismissed: (order) {
        deleteOrder(order);
        if (orders.isEmpty) Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('order with id ${order.item.name} was removed'),
          ),
        );
      },
      noDataText: "no Order here",
      list: orders,
    );
  }
}
