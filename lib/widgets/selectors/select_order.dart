import 'package:flutter/material.dart';
import 'package:vdp/documents/utils/bill.dart';
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
    return Scaffold(
      appBar: AppBar(title: const Text("Select Order")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
            itemCount: orders.length * 2,
            itemBuilder: (context, i) {
              if (i.isOdd) return const Divider(thickness: 1);
              i ~/= 2;
              var order = orders.elementAt(i);
              return Dismissible(
                key: Key(order.id),
                onDismissed: (direction) {
                  deleteOrder(order);
                  if (orders.isEmpty) Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('order with id ${order.id} was removed'),
                    ),
                  );
                },
                child: ListTile(
                  onTap: () {
                    onOrderSelect(order);
                    Navigator.pop(context);
                  },
                  trailing: P3(rs + order.amount.text),
                  subtitle: P2("Quntity: " + order.quntity.text),
                  title: T1(order.item.name),
                ),
                background: Container(color: Colors.red),
              );
            }),
      ),
    );
  }
}
