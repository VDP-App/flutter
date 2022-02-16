import 'package:flutter/material.dart';
import 'package:vdp/providers/apis/profile.dart';
import 'package:vdp/utils/page_utils.dart';
import 'package:vdp/utils/loading.dart';
import 'package:provider/provider.dart';
import 'package:vdp/utils/typography.dart';

class ShowProfile extends StatelessWidget {
  const ShowProfile({Key? key, required this.myProfile}) : super(key: key);
  final bool myProfile;

  Container get title {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(10),
      child: myProfile
          ? const P3(
              "Your Profile",
              fontWeight: FontWeight.w500,
              color: Colors.purple,
            )
          : const P3(
              "Edit Profile",
              fontWeight: FontWeight.w500,
              color: Colors.purple,
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var editProfile = Provider.of<EditProfile>(context, listen: false);
    var userInfo = editProfile.userInfo;
    var claims = userInfo.claims;
    var stockInfo = editProfile.configDoc.getStockInfo(claims.defaultStockId);
    var cashCounterInfo =
        stockInfo?.getCashCounterInfo(claims.defaultCashCouterId);
    return BuildPageBody(
      topic: "Edit Profile",
      wrapScaffold: !myProfile,
      children: [
        InputField(
          onChange: editProfile.onChanged,
          lable: "Name",
          defaultValue: editProfile.userInfo.name,
        ),
        InfoCell("UID", userInfo.uid),
        InfoCell("Email", userInfo.email),
        InfoCell("Role", userInfo.claims.roleIs),
        InfoCell("Stock", stockInfo?.name ?? "-- * --"),
        InfoCell("Cash Counter", cashCounterInfo?.name ?? "-- * --"),
      ],
      floatingActionButton: myProfile || userInfo.claims.isAdmin
          ? const _ActionButton()
          : Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: const [
                _ActionButton(),
                SizedBox(height: 30),
                _DeleteButton(),
              ],
            ),
    );
  }
}

class _DeleteButton extends StatelessWidget {
  const _DeleteButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var editProfile = Provider.of<EditProfile>(context);
    return FloatingActionButton(
      heroTag: "Delete",
      onPressed: editProfile.removeUser,
      backgroundColor: Colors.red,
      child: editProfile.deleteLoading
          ? loadingIconWigit
          : const Icon(Icons.delete),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var editProfile = Provider.of<EditProfile>(context);
    return Visibility(
      visible: editProfile.isReady,
      child: FloatingActionButton(
        heroTag: "Apply",
        onPressed: editProfile.applyChanges,
        child: editProfile.loading ? loadingIconWigit : const Icon(Icons.check),
      ),
    );
  }
}
