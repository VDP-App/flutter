import 'package:flutter/material.dart';
import 'package:vdp/screens/screen.dart';

enum Pages {
  entry,
  items,
  profile,
  users,
  shop,
  logs,
  summery,
  changes,
  bills,
  notifications,
}

extension Screen on Pages {
  Widget get screen {
    switch (this) {
      case Pages.entry:
        return const MakeEntryPage();
      case Pages.items:
        return const ItemsPage();
      case Pages.profile:
        return const MyProfile();
      case Pages.shop:
        return const EditShop();
      case Pages.users:
        return const EditUser();
      case Pages.logs:
        return const DisplayLogs();
      case Pages.summery:
        return const DisplayReport();
      case Pages.changes:
        return const DisplayStockChanges();
      case Pages.bills:
        return const DisplayBills();
      case Pages.notifications:
        return const TransferList();
    }
  }

  IconData get icon {
    switch (this) {
      case Pages.entry:
        return Icons.home;
      case Pages.items:
        return Icons.local_convenience_store_rounded;
      case Pages.profile:
        return Icons.portrait_rounded;
      case Pages.shop:
        return Icons.store_rounded;
      case Pages.users:
        return Icons.supervised_user_circle_rounded;
      case Pages.logs:
        return Icons.report;
      case Pages.summery:
        return Icons.summarize_rounded;
      case Pages.changes:
        return Icons.published_with_changes_rounded;
      case Pages.bills:
        return Icons.request_page_rounded;
      case Pages.notifications:
        return Icons.send_and_archive_rounded;
    }
  }

  String get text {
    switch (this) {
      case Pages.entry:
        return "Entry";
      case Pages.items:
        return "Items";
      case Pages.profile:
        return "Profile";
      case Pages.shop:
        return "Edit Shop";
      case Pages.users:
        return "Edit Users";
      case Pages.logs:
        return "Logs";
      case Pages.summery:
        return "Report";
      case Pages.changes:
        return "Stock Changes";
      case Pages.bills:
        return "Bills";
      case Pages.notifications:
        return "Transfers";
    }
  }
}

class PageProvider extends ChangeNotifier {
  var _currentPage = Pages.entry;

  int get pageIndex => _currentPage.index;
  Pages get currentPage => _currentPage;

  void changePageTo(Pages newPage, BuildContext context) {
    if (newPage != currentPage) {
      _currentPage = newPage;
      notifyListeners();
    }
  }
}
