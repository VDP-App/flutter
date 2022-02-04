import 'package:flutter/material.dart';
import 'package:vdp/widgets/edit_config/show_profile.dart';
import 'package:vdp/providers/apis/auth.dart';
import 'package:vdp/providers/apis/profile.dart';
import 'package:vdp/providers/doc/config.dart';
import 'package:vdp/utils/loading.dart';
import 'package:provider/provider.dart';

class MyProfile extends StatelessWidget {
  const MyProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var auth = Provider.of<Auth>(context, listen: false);
    var config = Provider.of<Config>(context);
    final doc = config.doc;
    if (doc == null) return loadingWigit;
    var userInfo = doc.getUserInfo(auth.user?.uid);
    if (userInfo == null) {
      return const Center(
        child: Text(
          "No User Found",
          style: TextStyle(fontSize: 50),
        ),
      );
    }
    return ChangeNotifierProxyProvider<Config, EditProfile>(
      create: (context) => EditProfile(context, userInfo, doc),
      update: (context, _, previous) {
        if (previous == null) {
          previous = EditProfile(context, userInfo, doc);
        } else {
          previous.userInfo = userInfo;
        }
        return previous;
      },
      child: const ShowProfile(myProfile: true),
    );
  }
}
