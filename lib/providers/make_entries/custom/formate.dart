const _trailingLength = 3;
const _upFrontLength = 7;

String formate(double val) {
  var _unFormated = val.toString();
  var _formated = "";
  int _i;
  var _isNeg = false;
  if (val < 0) {
    _isNeg = true;
    _unFormated = _unFormated.substring(1);
  }

  var _trailing = "";
  var _split = _unFormated.split(".");
  if (_split.length != 1 && _split.last != "0") {
    var v = _split.last;
    if (v.length > _trailingLength) {
      _trailing = "." + v.substring(0, _trailingLength);
    } else {
      _trailing = "." + v;
    }
  }
  _unFormated = _split.first;

  if (_unFormated.length > _upFrontLength) {
    _unFormated = _unFormated.substring(0, _upFrontLength);
  }

  if (_unFormated.length < 4) {
    _formated = _unFormated;
  } else {
    _i = _unFormated.length - 3;
    _formated = _unFormated.substring(_i) + _formated;
    _unFormated = _unFormated.substring(0, _i);

    while (_unFormated.length > 2) {
      _i = _unFormated.length - 2;
      _formated = _unFormated.substring(_i) + "," + _formated;
      _unFormated = _unFormated.substring(0, _i);
    }
    if (_unFormated.isNotEmpty) {
      _formated = _unFormated + "," + _formated;
    }
  }

  if (_isNeg) {
    _formated = "-" + _formated;
  }
  return _formated + _trailing;
}
