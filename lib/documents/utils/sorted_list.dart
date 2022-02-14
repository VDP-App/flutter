enum Comparator { isGreater, isEqual, isLess }

abstract class CompareClass<X> {
  const CompareClass();
  Comparator compare(X e);
}

class SortedList<E extends CompareClass<E>> {
  final _list = <E>[];
  final bool inAscending;

  SortedList({this.inAscending = true});

  List<E> toList() => [..._list];

  int nearestIndexOf(E e, [int startIndex = 0, int? endIndex]) {
    if (_list.isEmpty) return 0;
    endIndex ??= _list.length;
    if (startIndex > endIndex || startIndex < 0 || endIndex > _list.length) {
      return -1;
    }
    if (startIndex == endIndex) return startIndex;
    final mid = (startIndex + endIndex) ~/ 2;
    switch (e.compare(_list.elementAt(mid))) {
      case Comparator.isEqual:
        return mid;
      case Comparator.isGreater:
        if (inAscending) return nearestIndexOf(e, mid + 1, endIndex);
        return nearestIndexOf(e, startIndex, mid);
      case Comparator.isLess:
        if (inAscending) return nearestIndexOf(e, startIndex, mid);
        return nearestIndexOf(e, mid + 1, endIndex);
    }
  }

  void add(E e) => _list.insert(nearestIndexOf(e), e);
  void addAll(Iterable<E> es) {
    for (var e in es) {
      _list.insert(nearestIndexOf(e), e);
    }
  }

  List<E> customAdd<X>(Iterable<X> itrator, E Function(X x) convertor) {
    for (var x in itrator) {
      var e = convertor(x);
      _list.insert(nearestIndexOf(e), e);
    }
    return [..._list];
  }
}
