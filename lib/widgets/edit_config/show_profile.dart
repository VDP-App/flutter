import 'package:flutter/material.dart';
import 'package:vdp/providers/apis/profile.dart';
import 'package:vdp/utils/loading.dart';
import 'package:provider/provider.dart';

class ShowProfile extends StatelessWidget {
  const ShowProfile({Key? key, required this.myProfile}) : super(key: key);
  final bool myProfile;

  Container infoCell(String lable, String info) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
      child: Row(
        children: [
          Text(
            "$lable:",
            style: const TextStyle(fontSize: 30, color: Colors.purple),
          ),
          Text(info, style: const TextStyle(fontSize: 30)),
        ],
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
      ),
    );
  }

  Container editName(
    TextEditingController controller,
    void Function(String string) onChanged,
  ) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: const TextStyle(fontSize: 40),
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: "Name",
        ),
      ),
    );
  }

  Container get title {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(10),
      child: Text(
        myProfile ? "Your Profile" : "Edit Profile",
        style: const TextStyle(
          color: Colors.deepPurple,
          fontWeight: FontWeight.w500,
          fontSize: 30,
        ),
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
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(children: [
          const SizedBox(height: 50),
          title,
          const SizedBox(height: 35),
          editName(
            TextEditingController(text: editProfile.userInfo.name),
            editProfile.onChanged,
          ),
          const SizedBox(height: 20),
          infoCell("UID", userInfo.uid),
          const SizedBox(height: 20),
          infoCell("Email", userInfo.email),
          const SizedBox(height: 20),
          infoCell("Role", userInfo.claims.roleIs),
          const SizedBox(height: 20),
          infoCell("Stock", stockInfo?.name ?? "-- * --"),
          const SizedBox(height: 20),
          infoCell("Cash Counter", cashCounterInfo?.name ?? "-- * --"),
        ]),
      ),
      floatingActionButton: SizedBox(
        child: myProfile || userInfo.claims.isAdmin
            ? const _ActionButton()
            : Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: const [
                  _ActionButton(),
                  SizedBox(height: 30),
                  _DeleteButton(),
                ],
              ),
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
