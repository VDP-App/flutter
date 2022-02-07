import 'package:flutter/material.dart';
import 'package:vdp/Widgets/edit_config/show_profile.dart';
import 'package:vdp/documents/config.dart';
import 'package:vdp/documents/utils/config_info.dart';
import 'package:vdp/providers/apis/auth.dart';
import 'package:vdp/providers/apis/profile.dart';
import 'package:vdp/providers/doc/config.dart';
import 'package:vdp/utils/build_list_page.dart';
import 'package:vdp/utils/loading.dart';
import 'package:vdp/utils/typography.dart';
import 'package:vdp/widgets/edit_config/add_profile.dart';
import 'package:provider/provider.dart';

class EditUser extends StatelessWidget {
  const EditUser({Key? key}) : super(key: key);

  Widget table(List<String> titles, List<String> values) {
    return Column(children: [
      const SizedBox(height: 5),
      Row(
        children: titles.map((e) => P2(e, color: Colors.blue)).toList(),
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
      ),
      Row(
        children: values.map((e) => P2(e)).toList(),
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
      )
    ]);
  }

  @override
  Widget build(BuildContext context) {
    var config = Provider.of<Config>(context);
    var auth = Provider.of<Auth>(context, listen: false);
    final uid = auth.user?.uid;
    if (uid == null) return loadingWigit;
    final doc = config.doc;
    if (doc == null) return loadingWigit;
    final users = doc.users.where((element) => element.uid != uid);
    return BuildListPage<UserInfo>(
      wrapScaffold: true,
      noDataText: "No User Found",
      list: users,
      buildChild: (context, user) {
        return ListTilePage(
          onClick: () => openUserPage(context, user, doc),
          title: user.name,
          preview: Preview.info(
            ["Email", "Role"],
            [user.email, user.claims.roleIs],
          ),
        );
      },
      floatingActionButton: FloatingActionButton(
        onPressed: () => openCreateUesrPage(context, doc),
        child: const Icon(Icons.add),
      ),
    );
  }
}

void openCreateUesrPage(BuildContext context, ConfigDoc configDoc) {
  Navigator.push(context, MaterialPageRoute(builder: (context) {
    return ChangeNotifierProvider(
      create: (context) => CreateProfile(context, configDoc),
      child: const AddProfile(),
    );
  }));
}

void openUserPage(
  BuildContext context,
  UserInfo userInfo,
  ConfigDoc configDoc,
) {
  Navigator.push(context, MaterialPageRoute(builder: (context) {
    return ChangeNotifierProvider(
      create: (context) => EditProfile(context, userInfo, configDoc, true),
      child: const ShowProfile(myProfile: false),
    );
  }));
}
