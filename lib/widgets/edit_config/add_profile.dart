import 'package:flutter/material.dart';
import 'package:vdp/main.dart';
import 'package:vdp/providers/apis/custom/edit_claims.dart';
import 'package:vdp/providers/apis/profile.dart';
import 'package:vdp/utils/page_utils.dart';
import 'package:vdp/utils/loading.dart';
import 'package:provider/provider.dart';
import 'package:vdp/utils/typography.dart';

class AddProfile extends StatelessWidget {
  const AddProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var createProfile = Provider.of<CreateProfile>(context, listen: false);
    return BuildPageBody(
      title: "Create Profile",
      wrapScaffold: true,
      children: [
        InputField(onChange: createProfile.onNameChange, lable: "Name"),
        InputField(onChange: createProfile.onEmailChange, lable: "Email"),
        const _ShowInfo(),
      ],
      floatingActionButton: const _ActionButton(),
    );
  }
}

class _ShowInfo extends StatelessWidget {
  const _ShowInfo({Key? key}) : super(key: key);

  Widget dropdownButton(
    Roles? roles,
    void Function(Roles? roles) onChange,
  ) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.deepPurple,
          style: BorderStyle.solid,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(8),
      width: double.infinity,
      child: DropdownButton<Roles>(
        borderRadius: BorderRadius.circular(10),
        value: roles,
        icon: const IconH1(
          Icons.add_moderator_outlined,
          color: Colors.deepPurple,
        ),
        elevation: 16,
        style: TextStyle(color: Colors.deepPurple, fontSize: fontSizeOf.h1),
        // itemHeight: fontSizeOf.x1,
        onChanged: onChange,
        items: const [
          DropdownMenuItem(
            value: Roles.manager,
            child: Center(child: H1("Manager")),
          ),
          DropdownMenuItem(
            value: Roles.accountent,
            child: Center(child: H1("Accountent")),
          ),
        ],
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
        InfoCell("Stock", stockInfo?.name),
        const SizedBox(height: 30),
        InfoCell("Cash Counter", cashCounterInfo?.name)
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
