import 'package:flutter/material.dart';
import 'package:vdp/documents/config.dart';
import 'package:vdp/documents/utils/config_info.dart';
import 'package:vdp/providers/apis/custom/edit_claims.dart';
import 'package:vdp/utils/cloud_functions.dart';
import 'package:vdp/utils/modal.dart';

extension EmailValidator on String {
  bool get isEmail {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }

  bool get isNotEmail => !isEmail;
}

class CreateProfile extends Modal with ChangeNotifier {
  String _email = "";
  String _name = "";
  late final EditClaims claims;
  final _applyRoleOnCloud = ApplyRoleOnCloud();
  var _loading = false;

  bool get loading => _loading;
  bool get isNotReady =>
      claims.isNotReady || _email.isNotEmail || _name.isEmpty;
  bool get isReady => claims.isReady && _email.isEmail && _name.isNotEmpty;

  CreateProfile(BuildContext context, ConfigDoc configDoc) : super(context) {
    claims = EditClaims(context, configDoc);
  }

  void onEmailChange(String email) {
    _email = email;
    notifyListeners();
  }

  void onNameChange(String name) {
    _name = name;
    notifyListeners();
  }

  void onRoleChange(Roles? roles) async {
    if (roles == null) return;
    await claims.onChange(roles);
    notifyListeners();
  }

  Future<void> createUser() async {
    if (_loading || isNotReady) return;
    _loading = true;
    notifyListeners();
    if (claims.isManager) {
      await handleCloudCall(_applyRoleOnCloud.makeManager(
        _email,
        claims.stockID,
        _name,
      ));
    } else if (claims.isAccountent) {
      await handleCloudCall(_applyRoleOnCloud.makeAccountent(
        _email,
        claims.stockID,
        claims.cashCounterID,
        _name,
      ));
    }
    Navigator.pop(context);
  }
}

class EditProfile extends Modal with ChangeNotifier {
  UserInfo _userInfo;
  final _editShopOnCloud = EditShopOnCloud();
  final _applyRoleOnCloud = ApplyRoleOnCloud();
  String? _text;
  final bool popOnSuccess;
  final ConfigDoc configDoc;

  var _loading = false;
  var _deleteLoading = false;

  EditProfile(
    BuildContext context,
    this._userInfo,
    this.configDoc, [
    this.popOnSuccess = false,
  ]) : super(context);

  void onChanged(String string) {
    _text = string;
    notifyListeners();
  }

  set userInfo(UserInfo newUserInfo) {
    _userInfo = newUserInfo;
    notifyListeners();
  }

  UserInfo get userInfo => _userInfo;
  bool get loading => _loading;
  bool get deleteLoading => _deleteLoading;

  bool get isReady => _text != _userInfo.name && (_text?.isNotEmpty ?? false);
  bool get isNotReady => _text == _userInfo.name || (_text?.isEmpty ?? true);

  Future<void> applyChanges() async {
    if (_loading || _deleteLoading || isNotReady) return;
    _loading = true;
    notifyListeners();
    await handleCloudCall(
      _editShopOnCloud.editName(_text as String, _userInfo.uid),
    );
    if (popOnSuccess) return Navigator.pop(context);
    _loading = false;
    notifyListeners();
  }

  Future<void> removeUser() async {
    if (_loading || _deleteLoading) return;
    _deleteLoading = true;
    notifyListeners();
    await handleCloudCall(_applyRoleOnCloud.removeUser(_userInfo.email));
    Navigator.pop(context);
  }
}
