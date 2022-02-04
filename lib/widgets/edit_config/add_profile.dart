import 'package:flutter/material.dart';
import 'package:vdp/providers/apis/custom/edit_claims.dart';
import 'package:vdp/providers/apis/profile.dart';
import 'package:vdp/utils/loading.dart';
import 'package:provider/provider.dart';

class AddProfile extends StatelessWidget {
  const AddProfile({Key? key}) : super(key: key);

  Container editField(
    String label,
    void Function(String string) onChanged,
  ) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
      child: TextField(
        onChanged: onChanged,
        style: const TextStyle(fontSize: 40),
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: label,
        ),
      ),
    );
  }

  Container get title {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(10),
      child: const Text(
        "Create Profile",
        style: TextStyle(
          color: Colors.deepPurple,
          fontWeight: FontWeight.w500,
          fontSize: 30,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var createProfile = Provider.of<CreateProfile>(context, listen: false);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(children: [
          const SizedBox(height: 50),
          title,
          const SizedBox(height: 35),
          editField("Name", createProfile.onNameChange),
          const SizedBox(height: 30),
          editField("Email", createProfile.onEmailChange),
          const SizedBox(height: 30),
          const _ShowInfo(),
        ]),
      ),
      floatingActionButton: const SizedBox(
        child: _ActionButton(),
      ),
    );
  }
}

class _ShowInfo extends StatelessWidget {
  const _ShowInfo({Key? key}) : super(key: key);

  DropdownButton dropdownButton(
      Roles? roles, void Function(Roles? roles) onChange) {
    return DropdownButton<Roles>(
      value: roles,
      icon: const Icon(
        Icons.add_moderator_outlined,
        size: 50,
        color: Colors.deepPurple,
      ),
      elevation: 16,
      style: const TextStyle(
        color: Colors.deepPurple,
        fontSize: 50,
      ),
      itemHeight: 100,
      underline: const SizedBox.shrink(),
      onChanged: onChange,
      items: const [
        DropdownMenuItem(
          value: Roles.manager,
          child: Text("Manager"),
        ),
        DropdownMenuItem(value: Roles.accountent, child: Text("Accountent")),
      ],
    );
  }

  Container infoCell(String lable, String? info) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
      child: Row(
        children: [
          Text(
            "$lable:",
            style: const TextStyle(fontSize: 30, color: Colors.purple),
          ),
          Text(info ?? "-- * --", style: const TextStyle(fontSize: 30)),
        ],
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var createProfile = Provider.of<CreateProfile>(context);
    var claims = createProfile.claims;
    var stockInfo = claims.configDoc.getStockInfo(claims.stockID);
    var cashCounterInfo = stockInfo?.getCashCounterInfo(claims.cashCounterID);
    return Column(
      children: [
        dropdownButton(claims.hasRoleOf, createProfile.onRoleChange),
        const SizedBox(height: 30),
        infoCell("Stock", stockInfo?.name),
        const SizedBox(height: 30),
        infoCell("Cash Counter", cashCounterInfo?.name)
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var createProfile = Provider.of<CreateProfile>(context);
    return Visibility(
      visible: createProfile.isReady,
      child: FloatingActionButton(
        onPressed: createProfile.createUser,
        child:
            createProfile.loading ? loadingIconWigit : const Icon(Icons.check),
      ),
    );
  }
}
