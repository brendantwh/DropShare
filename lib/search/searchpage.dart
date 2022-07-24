import '../listings/listinggridsearch.dart';
import 'search.dart';
import 'package:flutter/cupertino.dart';
import 'dart:ui' as ui;
import 'dart:io';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController searchController = TextEditingController();
  Widget found = Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
      child: const Text(
        'Enter search query',
        style: const TextStyle(fontWeight: FontWeight.w500, color: CupertinoColors.systemGrey, fontSize: 14),
      )
  );
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
    double pfPadding = Platform.isIOS ? 90 : 68;

    //Variables for filtering
    var lst;
    var data = ModalRoute.of(context)?.settings.arguments;

    if (data is List) {
      lst = data;
    }

    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
            middle: Text('Search', style: TextStyle(fontFamily: CupertinoTheme.of(context).textTheme.textStyle.fontFamily), textScaleFactor: 1),
            trailing: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, 'filter');
              },
              child: const Icon(CupertinoIcons.slider_horizontal_3)),
        ),
        child: SafeArea(
          top: false,
          minimum: const EdgeInsets.fromLTRB(0, 0, 0, 34),
          child: Stack(
            children: [
              Container(
                  margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: ListingGridSearch(searchResults: searchRes, padding: EdgeInsets.only(top: pfPadding + 105))
              ),
              ClipRect(
                child: BackdropFilter(
                    filter: ui.ImageFilter.blur(sigmaX: 7.5, sigmaY: 7.5),
                    child: Container(
                        width: double.infinity,
                        height: 90,
                        margin: EdgeInsets.fromLTRB(0, pfPadding, 0, 0),
                        decoration: const BoxDecoration(
                            color: Color(0xF7FFFFFF),
                            border: Border(
                                bottom: BorderSide(
                                    width: 0,
                                    color: CupertinoColors.opaqueSeparator)
                            )
                        ),
                        child: Column(
                          children: [
                            Container(
                                margin: const EdgeInsets.fromLTRB(20, 10, 20, 15),
                                child: CupertinoSearchTextField(
                                  autofocus: true,
                                  controller: searchController,
                                  placeholder: data == null ? 'Search for listings' : 'Search for listings with filter',
                                  suffixMode: OverlayVisibilityMode.editing,
                                  onSubmitted: (val) {
                                    if (val.isEmpty) {

                                    } else {

                                      if (lst != null) {
                                        search = Search.userSearchAllClient.collection('search_listings').documents.search(
                                            {
                                              'q': val,
                                              'query_by': 'title',
                                              'sort_by': 'time:desc',
                                              'filter_by': 'sold:=false && location:=${lst[0]} && price:[${lst[1].start}..${lst[1].end}]',
                                            }
                                        );
                                      } else {
                                        search = Search.userSearchAllClient.collection('search_listings').documents.search(
                                            {
                                              'q': val,
                                              'query_by': 'title',
                                              'sort_by': 'time:desc',
                                              'filter_by': 'sold:=false',
                                            }
                                        );
                                      }

                                      search.then((res) {
                                        found = Container(
                                            alignment: Alignment.centerLeft,
                                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                                            child: Text(
                                              '${res['found']} ${res['found'] == 1 ? 'listing' : 'listings'} found',
                                              style: const TextStyle(fontWeight: FontWeight.w500, color: CupertinoColors.systemGrey, fontSize: 14),
                                            )
                                        );
                                        searchRes = res['hits'];
                                        setState(() {});
                                      });
                                    }
                                  },
                                )
                            ),
                            found
                          ],
                        )
                    )
                ),
              )
            ],
          )
        )
    );
  }
}
