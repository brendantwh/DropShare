import '../listings/listinggridsearch.dart';
import 'search.dart';
import 'package:flutter/cupertino.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController searchController = TextEditingController();
  Widget found = Container();
  List<dynamic> searchRes = [];
  var search = Search.userSearchAllClient.collection('search_listings').documents.search({
    'q': '*',
    'query_by': 'title'
  });

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
            middle: Text('Search', style: TextStyle(fontFamily: CupertinoTheme.of(context).textTheme.textStyle.fontFamily))
        ),
        child: SafeArea(
          minimum: const EdgeInsets.fromLTRB(20, 15, 20, 34),
          child: Column(
            children: [
              Container(
                  margin: const EdgeInsets.only(top: 15, bottom: 10),
                  child: CupertinoSearchTextField(
                    controller: searchController,
                    placeholder: 'Search for listings',
                    suffixMode: OverlayVisibilityMode.editing,
                    onSubmitted: (val) {
                      if (val.isEmpty) {

                      } else {
                        search = Search.userSearchAllClient.collection('search_listings').documents.search(
                            {
                              'q': val,
                              'query_by': 'title',
                              'sort_by': 'time:desc'
                            }
                        );
                        search.then((res) {
                          found = Container(
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Text(
                              '${res['found']} ${res['found'] == 1 ? 'listing' : 'listings'} found',
                              style: const TextStyle(fontWeight: FontWeight.w500, color: CupertinoColors.systemGrey),
                              textScaleFactor: 0.87,
                            )
                          );
                          searchRes = res['hits'];
                          setState(() {});
                        });
                      }
                    },
                  )
              ),
              found,
              Flexible(
                  child: ListingGridSearch(searchResults: searchRes)
              )
            ],
          ),
        )
    );
  }
}
