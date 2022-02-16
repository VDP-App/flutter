import 'package:flutter/material.dart';
import 'package:vdp/documents/product.dart';
import 'package:vdp/layout.dart';
import 'package:vdp/widgets/selectors/grid_selector.dart';

class SelectCollection extends StatelessWidget {
  const SelectCollection({
    Key? key,
    required this.collectionNames,
    required this.onSelect,
    required this.editMode,
    this.canPop = true,
  }) : super(key: key);
  final Iterable<String> collectionNames;
  final void Function(String selectedCollection) onSelect;
  final bool editMode;
  final bool canPop;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: appBarTitle("Select Collection Name"),
        actions: [
          if (editMode)
            IconButton(
                onPressed: () {
                  showSearch(
                    context: context,
                    delegate: CustomDelegate(
                      searchTerms: collectionNames.toList(),
                    ),
                  ).then((value) {
                    if (value != null && value.isNotEmpty) {
                      onSelect(value);
                      if (canPop) Navigator.pop(context);
                    }
                  });
                },
                icon: const Icon(Icons.manage_search)),
        ],
      ),
      body: GridSelector(
        color: Colors.pink,
        count: 3,
        length: collectionNames.length + (editMode ? 0 : 1),
        builder: (index) {
          if (!editMode) {
            if (index == 0) {
              return GridItem(
                onPress: () {
                  onSelect(allCollectionNameKey);
                  if (canPop) Navigator.pop(context);
                },
                title: allCollectionNameKey,
                color: Colors.blue,
              );
            }
            index -= 1;
          }
          var collName = collectionNames.elementAt(index);
          return GridItem(
            onPress: () {
              onSelect(collName);
              if (canPop) Navigator.pop(context);
            },
            title: collName,
          );
        },
      ),
    );
  }
}

class CustomDelegate extends SearchDelegate<String?> {
  final _searchTerms = <String, String>{};

  CustomDelegate({required List<String> searchTerms}) : super() {
    for (var element in searchTerms) {
      _searchTerms[element.toLowerCase()] = element;
    }
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(onPressed: () => query = "", icon: const Icon(Icons.clear))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () => close(context, null),
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final queryInLowerCase = query.toLowerCase();
    if (!queryInLowerCase.contains("#")) {
      final _matchQuery = [
        if (queryInLowerCase.isNotEmpty)
          GridItem(
            onPress: () => close(context, query),
            title: query,
            color: Colors.blue,
          ),
      ];
      for (var e in _searchTerms.entries) {
        if (e.key.contains(queryInLowerCase)) {
          _matchQuery.add(
            GridItem(onPress: () => close(context, e.value), title: e.value),
          );
        }
      }
      return GridSelector(
        color: Colors.pink,
        count: 3,
        length: _matchQuery.length,
        builder: (index) => _matchQuery[index],
      );
    }
    return const SizedBox();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return buildResults(context);
  }
}
