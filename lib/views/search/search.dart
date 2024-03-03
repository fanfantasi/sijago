import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jagomart/config/koneksi.dart';
import 'package:jagomart/database/searchmodel.dart';
import 'package:jagomart/helpers/app_colors.dart';
import 'package:jagomart/helpers/shimmer.dart';
import 'package:jagomart/viewmodels/bestseller/bestseller_view_model.dart';
import 'package:jagomart/viewmodels/items/items_model.dart';
import 'package:jagomart/viewmodels/search/historysearch_bloc.dart';
import 'package:jagomart/viewmodels/search/search_view_model.dart';
import 'package:jagomart/views/items/items.dart';
import 'package:themify_flutter/themify_flutter.dart';
import 'package:flare_flutter/flare_actor.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  ScrollController _scrollViewController = new ScrollController();
  final TextEditingController _searchQuery = TextEditingController();
  bool _isSearching = false;
  bool isLoading = false;
  final searchBloc = SearchBloc();
  final historyBloc = HistorySearchBloc();
  final bestsellerBloc = BestSellerBloc();
  int currentpage = 1;
  int pageCount = 1;

  @override
  void initState() {
    historyBloc.getHistory();
    bestsellerBloc.getBestSellerTop(pageCount, Config.nearby);
    _scrollViewController = new ScrollController(initialScrollOffset: 5.0)
      ..addListener(_scrollListener);
    super.initState();
  }

  @override
  void dispose() {
    _scrollViewController.dispose();
    super.dispose();
  }

  performSearch(String query) {
    if (query.isEmpty) {
      setState(() {
        _isSearching = false;
      });
    }

    if (this._searchQuery.text == query && this.mounted) {
      setState(() {
        _isSearching = true;
        searchBloc.getSearchTop(currentpage, Config.nearby, query);
        isLoading = false;
      });
    }
  }

  _scrollListener() {
    if (_scrollViewController.offset >=
            _scrollViewController.position.maxScrollExtent &&
        !_scrollViewController.position.outOfRange) {
      setState(() {
        isLoading = true;
      });

      if (isLoading) {
        if (_searchQuery.text.isEmpty) {
          pageCount = pageCount + 1;
          getDataBestSeller(pageCount);
        } else {
          currentpage = currentpage + 1;
          getData(currentpage);
        }
      }
    }
  }

  void getDataBestSeller(pageCount) async {
    bool search = await bestsellerBloc.getBestSeller(pageCount, Config.nearby);
    if (!search) {
      setState(() {
        isLoading = false;
      });
    }
  }

  void getData(pageCount) async {
    bool search =
        await searchBloc.getSearch(pageCount, Config.nearby, _searchQuery.text);
    if (!search) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Container(
            height: 60.0,
            padding: EdgeInsets.only(
              top: 10.0,
              bottom: 10.0,
            ),
            child: TextField(
              autofocus: true,
              controller: _searchQuery,
              decoration: InputDecoration(
                hintText: "Mau Cari Apa ...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: Colors.black12,
                    width: .3,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: Colors.black12,
                    width: 1,
                  ),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                suffixIcon: IconButton(
                  icon: Icon(Themify.search),
                  onPressed: () {
                    performSearch(_searchQuery.text);
                    if (_searchQuery.text.isNotEmpty) {
                      historyBloc.insertHistory(_searchQuery.text);
                    }
                  },
                  iconSize: 25.0,
                ),
              ),
              onSubmitted: (value) {
                performSearch(value);
                if (value.isNotEmpty) {
                  historyBloc.insertHistory(value);
                }
              },
            )),
      ),
      body: SingleChildScrollView(
          controller: _scrollViewController,
          physics: BouncingScrollPhysics(),
          child: buildBodySearch(context)),
    );
  }

  Widget buildBodySearch(BuildContext context) {
    if (_isSearching) {
      return StreamBuilder(
        stream: searchBloc.searchStream,
        builder: (context, AsyncSnapshot snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5.0),
                  color: Colors.white,
                  child: ShimmerItemVertical(count: 12));
            default:
              if (snapshot.hasError) {
                return Container();
              } else if (snapshot.data == null) {
                return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5.0),
                    color: Colors.white,
                    child: ShimmerItemVertical(count: 12));
              }

              return (snapshot.data.length == 0)
                  ? Stack(
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height / 1,
                          child: FlareActor(
                            "assets/Empty.flr",
                            animation: "empty",
                            fit: BoxFit.fitHeight,
                            alignment: Alignment.center,
                          ),
                        ),
                        Positioned(
                          top: 50,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width,
                                child: AutoSizeText(
                                  'Data ${_searchQuery.text}',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.aclonica(
                                      color: Colors.black54, fontSize: 18),
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                child: AutoSizeText(
                                  'tidak ada di kami.',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.aclonica(
                                      color: Colors.black54, fontSize: 18),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 8.0),
                      child: ItemsPage(
                        vi: snapshot.data,
                        isLoading: isLoading,
                        scrollViewController: _scrollViewController,
                      ));
          }
        },
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "History Pencarian Saya",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      color: Colors.black87,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600),
                ),
                InkWell(
                  onTap: () {
                    historyBloc.removeAllHistory();
                  },
                  child: Text(
                    "Hapus Semua",
                    style: TextStyle(
                        fontStyle: FontStyle.italic,
                        color: Theme.of(context).primaryColor),
                  ),
                )
              ],
            ),
          ),
          StreamBuilder<List<SearchItem>>(
            stream: historyBloc.isHistory,
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Wrap(
                      children: List.generate(3, (i) {
                    return Padding(
                      padding: const EdgeInsets.only(
                          left: 5.0, right: 5.0, bottom: 5.0),
                      child: Chip(
                        label: new Text('Loading'),
                        labelPadding: EdgeInsets.all(2.0),
                        deleteIcon: Icon(Themify.close),
                      ),
                    );
                  }));
                default:
                  if (snapshot.hasError) {
                    return Container(child: Text('Error'));
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      (snapshot.data.length == 0)
                          ? Container(
                              child: Image.asset(
                                'images/noresult.gif',
                                scale: 1,
                              ),
                            )
                          : Wrap(
                              children:
                                  List.generate(snapshot.data.length, (i) {
                              return Padding(
                                padding: const EdgeInsets.only(
                                    left: 5.0, right: 5.0, bottom: 5.0),
                                child: InkWell(
                                  onTap: () {
                                    _searchQuery.text = snapshot.data[i].item;
                                    performSearch(_searchQuery.text);
                                  },
                                  child: Chip(
                                    label: new Text('${snapshot.data[i].item}'),
                                    onDeleted: () {
                                      setState(() {});
                                    },
                                    labelPadding: EdgeInsets.all(2.0),
                                    deleteIcon: Icon(
                                      Themify.trash,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                              );
                            })),
                      SizedBox(
                        height: 10.0,
                      ),
                    ],
                  );
              }
            },
          ),
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            )),
            child: Container(
              margin: const EdgeInsets.all(10.0),
              child: Column(children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                      width: 3,
                      height: 20,
                      color: jagoRed,
                    ),
                    SizedBox(
                      width: 5.0,
                    ),
                    Flexible(
                      child: AutoSizeText("Best Seller",
                          maxLines: 1,
                          maxFontSize: 22,
                          overflow: TextOverflow.fade,
                          style: GoogleFonts.lato(
                              color: Colors.black87,
                              fontSize: 16,
                              fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10.0,
                ),
              ]),
            ),
          ),
          StreamBuilder(
              stream: bestsellerBloc.bestsellerStream,
              builder: (context, AsyncSnapshot<List<ItemsViewModel>> snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 5.0),
                        color: Colors.white,
                        child: ShimmerItemVertical(count: 12));
                    break;

                  default:
                    if (snapshot.hasError) {
                      return Container();
                    }
                    return ItemsPage(
                      vi: snapshot.data,
                      isLoading: isLoading,
                      scrollViewController: _scrollViewController,
                    );
                }
              })
        ],
      );
    }
  }
}
