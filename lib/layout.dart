import 'package:flutter/material.dart';
import 'package:vdp/providers/apis/auth.dart';
import 'package:vdp/providers/apis/location.dart';
import 'package:vdp/providers/apis/pages.dart';
import 'package:provider/provider.dart';
import 'package:vdp/utils/typography.dart';

class Layout extends StatelessWidget {
  const Layout({Key? key}) : super(key: key);

  Widget listTile(
    BuildContext context,
    Pages page,
    PageProvider pageProvider,
  ) {
    if (page == pageProvider.currentPage) {
      return ListTile(
        style: ListTileStyle.drawer,
        tileColor: Colors.grey[200],
        leading: IconP3.bigger(page.icon, color: Colors.deepPurpleAccent),
        title: P3.bigger(page.text, color: Colors.deepPurpleAccent),
      );
    }
    return ListTile(
      style: ListTileStyle.drawer,
      onTap: () => pageProvider.changePageTo(page, context),
      leading: IconP3(page.icon, color: Colors.black),
      title: P3(page.text),
    );
  }

  Widget selectLocation(
    void Function() onTap,
    String title,
    IconData iconData,
  ) {
    return TextButton(
      onPressed: onTap,
      child: Row(
        children: [
          Flexible(
            flex: 2,
            child: IconP3(iconData, color: Colors.blue),
          ),
          const Spacer(),
          Flexible(
            flex: 6,
            child: P3(title, color: Colors.blue),
          ),
        ],
      ),
    );
  }

  Widget locationInfo(String? title, void Function() onTap) {
    if (title == null) return const SizedBox();
    return TextButton(
      onPressed: onTap,
      child: Row(
        children: [
          const Spacer(),
          const Flexible(
            flex: 2,
            child: IconP3(
              Icons.subdirectory_arrow_right_rounded,
              color: Colors.red,
            ),
          ),
          const Spacer(),
          Flexible(
            flex: 6,
            child: P2(title, color: Colors.red),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var page = Provider.of<PageProvider>(context);
    var location = Provider.of<Location>(context);
    var auth = Provider.of<Auth>(context, listen: false);
    final claims = auth.claims!;
    const divider = Divider(thickness: 1.5, height: 30);
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.deepPurple),
              child: Center(
                child: H1('Menu', color: Colors.white),
              ),
            ),
            listTile(context, Pages.entry, page),
            listTile(context, Pages.bills, page),
            if (claims.hasManagerAuthorization) ...[
              divider,
              listTile(context, Pages.changes, page),
              listTile(context, Pages.notifications, page)
            ],
            if (claims.hasManagerAuthorization) ...[
              divider,
              listTile(context, Pages.items, page),
              listTile(context, Pages.logs, page),
              listTile(context, Pages.summery, page),
            ],
            if (claims.hasAdminAuthorization) ...[
              divider,
              listTile(context, Pages.profile, page),
              listTile(context, Pages.shop, page),
              listTile(context, Pages.users, page)
            ],
            divider,
            if (claims.hasAdminAuthorization)
              selectLocation(() {
                Navigator.pop(context);
                location.selectStock();
              }, "Select Stock", Icons.location_on_outlined),
            locationInfo(location.stockName, () {
              Navigator.pop(context);
              if (claims.hasAdminAuthorization) location.selectStock();
            }),
            if (claims.hasManagerAuthorization)
              selectLocation(() {
                Navigator.pop(context);
                location.selectCashCounter();
              }, "Select Counter", Icons.local_atm_outlined),
            locationInfo(location.cashCounterName, () {
              Navigator.pop(context);
              if (claims.hasManagerAuthorization) {
                location.selectCashCounter();
              }
            }),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text('Vardayani Dairy Products'),
        actions: [
          IconButton(
            onPressed: context.read<Auth>().logout,
            icon: const IconT1(Icons.exit_to_app_rounded, color: Colors.white),
          ),
          const SizedBox(width: 25),
        ],
      ),
      body: page.currentPage.screen,
    );
  }
}
