import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vdp/utils/modal.dart';

class Claims {
  final Map<String, dynamic> claims;
  const Claims(this.claims);

  bool get isAdmin => claims["r"] == 0;
  bool get isManager => claims["r"] == 1;
  bool get isAccountent => claims["r"] == 2;

  String? get defaultStockId => claims["s"];
  String? get defaultCashCouterId => claims["c"];

  String get roleIs {
    if (isAdmin) return "Admin";
    if (isManager) return "Manager";
    return "Accountent";
  }

  bool get hasAdminAuthorization => claims["r"] < 1;
  bool get hasManagerAuthorization => claims["r"] < 2;
  bool get hasAccountentAuthorization => claims["r"] < 3;

  bool hasAuthorizationToStock(String id) {
    if (isAdmin) return true;
    if (hasManagerAuthorization) return id == defaultStockId;
    return false;
  }

  bool hasAuthorizationToCashCounter(String stockID, String id) {
    if (isAdmin) return true;
    if (isManager) return stockID == defaultStockId;
    if (isAccountent) return id == defaultCashCouterId;
    return false;
  }
}

class Auth extends Modal with ChangeNotifier {
  var _loadingAuth = true;
  StreamSubscription<User?>? sub;
  User? _user;
  final _auth = FirebaseAuth.instance;
  Claims? _claims;

  Auth(BuildContext context) : super(context) {
    sub = _auth.authStateChanges().listen((user) async {
      if (user == null) {
        _claims = _user = null;
        _loadingAuth = false;
        notifyListeners();
      } else {
        _user = user;
        final res = await user.getIdTokenResult();
        if (_user != null) {
          final claims = res.claims;
          if (claims == null) {
            _logout();
          } else {
            _claims = Claims(claims);
            _loadingAuth = false;
            notifyListeners();
          }
        }
      }
    });
  }

  User? get user => _user;
  bool get isLoggedIn => _user != null;
  bool get isLoading => _loadingAuth;
  Claims? get claims => _claims;

  Future<void> _login(String email, String pass) async {
    _loadingAuth = true;
    notifyListeners();
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: pass,
      );
    } on FirebaseAuthException catch (e) {
      _loadingAuth = false;
      notifyListeners();
      if (e.code == "wrong-password") {
        openModal(
          "Wrong Password",
          "Do want to send an email to '$email' to reset password?",
          onOk: () => _forgotPassword(email),
          okText: "Yes",
        );
      } else {
        openModal(e.code, e.message ?? "Something Went Wrong");
      }
    } catch (e) {
      _loadingAuth = false;
      notifyListeners();
      openModal("Unknown Error Occured", e.toString());
    }
  }

  Future<void> _logout() async {
    _loadingAuth = true;
    notifyListeners();
    try {
      await _auth.signOut();
    } on FirebaseAuthException catch (e) {
      _loadingAuth = false;
      notifyListeners();
      openModal(e.code, e.message ?? "Something Went Wrong");
    } catch (e) {
      _loadingAuth = false;
      notifyListeners();
      openModal("Unknown Error Occured", e.toString());
    }
  }

  Future<void> _forgotPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      openModal(
        "Email Sent",
        "An Email with link was sent to '$email' address for reset password",
      );
    } on FirebaseAuthException catch (e) {
      openModal(e.code, e.message ?? "Something Went Wrong");
    } catch (e) {
      openModal("Unknown Error Occured", e.toString());
    }
  }

  void login({
    required String email,
    required String password,
  }) {
    if (_loadingAuth) return;
    if (isLoggedIn) {
      openModal(
        'Already Loged in',
        'Still wish to login?',
        onOk: () async {
          await _logout();
          _login(email, password);
        },
        okText: "Yes",
      );
    } else {
      _login(email, password);
    }
  }

  void logout() {
    if (!isLoggedIn) {
      openModal("No User Found", "First Login!");
    } else {
      openModal(
        'Are you sure',
        'Still wish to logout?',
        onOk: () => _logout(),
        okText: "Yes",
      );
    }
  }

  void forgotPassword({required String email}) {
    if (_loadingAuth) return;
    openModal(
      'Forgot Password',
      'Send link to "$email" for password change?',
      onOk: () => _forgotPassword(email),
      okText: "Yes",
    );
  }

  @override
  void dispose() {
    super.dispose();
    sub?.cancel();
  }
}
