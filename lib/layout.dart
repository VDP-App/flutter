import 'package:flutter/material.dart';
import 'package:vdp/providers/apis/auth.dart';
import 'package:vdp/providers/apis/location.dart';
import 'package:vdp/providers/apis/pages.dart';
import 'package:provider/provider.dart';

class Layout extends StatelessWidget {
  const Layout({Key? key}) : super(key: key);

  ListTile listTile(
    BuildContext context,
    Pages page,
    PageProvider pageProvider,
  ) {
    if (page == pageProvider.currentPage) {
      return ListTile(
        leading: Icon(page.icon, size: 33, color: Colors.deepPurpleAccent),
        title: Text(
          page.text,
          style: const TextStyle(fontSize: 33, color: Colors.deepPurpleAccent),
        ),
      );
    }
    return ListTile(
      onTap: () => pageProvider.changePageTo(page, context),
      leading: Icon(page.icon, size: 30, color: Colors.black),
      title: Text(page.text, style: const TextStyle(fontSize: 30)),
    );
  }

  ListTile selectLocation(
      void Function() onTap, String title, IconData iconData) {
    return ListTile(
      onTap: onTap,
      leading: Icon(iconData, size: 30, color: Colors.blue),
      title: Text(
        title,
        style: const TextStyle(fontSize: 30, color: Colors.blue),
      ),
    );
  }

  Widget locationInfo(String? title, void Function() onTap) {
    if (title == null) return const SizedBox();
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: ListTile(
        onTap: onTap,
        leading: const Icon(
          Icons.subdirectory_arrow_right_rounded,
          size: 30,
          color: Colors.red,
        ),
        title: Text(
          title,
          style: const TextStyle(fontSize: 25, color: Colors.red),
        ),
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
        child: SizedBox(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(color: Colors.deepPurple),
                child: Center(
                  child: Text(
                    'Menu',
                    style: TextStyle(fontSize: 50, color: Colors.white),
                  ),
                ),
              ),
              listTile(context, Pages.entry, page),
              listTile(context, Pages.bills, page),
              if (claims.hasManagerAuthorization) ...[
                divider,
                listTile(context, Pages.changes, page),
                listTile(context, Pages.notifications, page)
              ],
              if (claims.hasAdminAuthorization) ...[
                divider,
                listTile(context, Pages.items, page),
                listTile(context, Pages.logs, page),
                listTile(context, Pages.summery, page),
                divider,
                listTile(context, Pages.profile, page),
                listTile(context, Pages.shop, page),
                listTile(context, Pages.users, page)
              ],
              const Divider(thickness: 3, height: 30),
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
      ),
      appBar: AppBar(
        title: const Text('Vardayani Dairy Products'),
        actions: [
          IconButton(
            onPressed: context.read<Auth>().logout,
            icon: const Icon(
              Icons.exit_to_app_rounded,
              color: Colors.white,
              size: 35,
            ),
          ),
          const SizedBox(width: 25),
        ],
      ),
      body: page.currentPage.screen,
    );
  }
}
