import 'package:flutter/material.dart';
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
        title: const Text("Select Collection Name"),
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
        length: collectionNames.length,
        builder: (index) {
          var item = collectionNames.elementAt(index);
          return GridItem(
            onPress: () {
              onSelect(item);
              if (canPop) Navigator.pop(context);
            },
            title: item,
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
    if (queryInLowerCase.isNotEmpty) {
      final _matchQuery = [
        ListTile(
          onTap: () => close(context, query),
          title: Text(
            query,
            style: const TextStyle(color: Colors.green),
          ),
        )
      ];
      for (var element in _searchTerms.entries) {
        if (element.key.contains(queryInLowerCase)) {
          _matchQuery.add(
            ListTile(
              onTap: () => close(context, element.value),
              title: Text(element.value),
            ),
          );
        }
      }
      return ListView.builder(
        itemCount: _matchQuery.length,
        itemBuilder: (context, index) => _matchQuery[index],
      );
    }
    return const SizedBox();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return buildResults(context);
  }
}
