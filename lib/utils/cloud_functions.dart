import 'package:cloud_functions/cloud_functions.dart';
import 'package:vdp/documents/utils/bill.dart';
import 'package:vdp/documents/utils/product.dart';
import 'package:vdp/documents/utils/stock_changes.dart';

class CloudError {
  final String code;
  final String message;
  const CloudError({required this.message, this.code = "Something is wrong"});
}

FirebaseFunctions get _cloudFunction =>
    FirebaseFunctions.instanceFor(region: "asia-south1");
Future<T> _callApi<T>(
  HttpsCallable _api,
  Map<String, dynamic> req, [
  T Function(dynamic)? parser,
]) async {
  dynamic data;
  try {
    data = (await _api.call(req)).data;
  } catch (err) {
    throw CloudError(message: err.toString());
  }
  if (data["err"]) {
    throw CloudError(
      message: data?["val"]?["message"] ?? "Responce got wrong",
      code: data?["val"]?["code"],
    );
  }
  return parser?.call(data["val"]) ?? data["val"];
}

class EditItemOnCloud {
  final _api = _cloudFunction.httpsCallable('editItem');

  Future<void> create(Product item) {
    return _callApi(_api, {
      "type": "create",
      "item": item.toJson(),
      "id": item.id,
    });
  }

  Future<void> remove(Product item) {
    return _callApi(_api, {
      "type": "remove",
      "item": item.toJson(),
      "id": item.id,
    });
  }

  Future<void> update(Product item) {
    return _callApi(_api, {
      "type": "update",
      "item": item.toJson(),
      "id": item.id,
    });
  }
}

class ApplyRoleOnCloud {
  final _api = _cloudFunction.httpsCallable('applyRole');

  Future<void> makeManager(String email, String stockID, String name) {
    return _callApi(_api, {
      "email": email,
      "applyClaims": {"role": "manager", "stockID": stockID},
      "name": name,
    });
  }

  Future<void> makeAccountent(
    String email,
    String stockID,
    String cashCounterID,
    String name,
  ) {
    return _callApi(_api, {
      "email": email,
      "applyClaims": {
        "role": "accountent",
        "stockID": stockID,
        "cashCounterID": cashCounterID
      },
      "name": name,
    });
  }

  Future<void> removeUser(String email) {
    return _callApi(_api, {
      "email": email,
      "name": "name",
    });
  }
}

class EditShopOnCloud {
  final _api = _cloudFunction.httpsCallable('editShop');
  Future<void> createStock(String name) {
    return _callApi(_api, {"type": "createStock", "name": name});
  }

  Future<void> editStock(String name, String stockID) {
    return _callApi(_api, {
      "type": "editStock",
      "name": name,
      "stockID": stockID,
    });
  }

  Future<void> createCashCounter(String name, String stockID) {
    return _callApi(_api, {
      "type": "createCashCounter",
      "name": name,
      "stockID": stockID,
    });
  }

  Future<void> editCashCounter(
    String name,
    String stockID,
    String cashCounterID,
  ) {
    return _callApi(_api, {
      "type": "editCashCounter",
      "name": name,
      "stockID": stockID,
      "cashCounterID": cashCounterID,
    });
  }

  Future<void> editName(String name, String uid) {
    return _callApi(_api, {
      "type": "editName",
      "name": name,
      "uid": uid,
    });
  }
}

class BillingOnCloud {
  final _api = _cloudFunction.httpsCallable('billing');

  Future<int> bill(
    String stockID,
    String cashCounterID,
    Bill bill,
  ) {
    return _callApi<int>(_api, {
      "stockID": stockID,
      "cashCounterID": cashCounterID,
      "bill": bill.toJson(),
    });
  }
}

class CancleBillOnCloud {
  final _api = _cloudFunction.httpsCallable('cancleBill');

  Future<Bill> cancleBill(
    String billNum,
    String stockID,
    String cashCounterID,
  ) {
    return _callApi<Bill>(
      _api,
      {
        "billNum": int.parse(billNum),
        "stockID": stockID,
        "cashCounterID": cashCounterID,
      },
      (x) => Bill.fromJson(Map<String, dynamic>.from(x), "--*--"),
    );
  }
}

class StockChangesOnCloud {
  final _api = _cloudFunction.httpsCallable('stockChanges');

  Future<void> makeChanges(StockChanges stockChanges) {
    return _callApi(_api, stockChanges.toJson());
  }
}

class TransferStockOnCloud {
  final _api = _cloudFunction.httpsCallable('transferStock');

  Future<void> sendTransfer(
    String sendTo,
    StockChanges changes,
  ) {
    return _callApi(_api, changes.toJsonInTransferFormate(sendTo));
  }

  Future<void> reciveTransfer(String uniqueID, String stockID) {
    return _callApi(_api, {
      "type": "recive",
      "stockID": stockID,
      "uniqueID": uniqueID,
    });
  }
}
