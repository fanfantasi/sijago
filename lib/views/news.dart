import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:flutter_link_preview/flutter_link_preview.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jagomart/helpers/app_colors.dart';
import 'package:jagomart/viewmodels/feed/news_model.dart';
import 'package:jagomart/viewmodels/viewmodels.dart';
import 'package:jagomart/views/errorpage.dart';
import 'package:jagomart/views/items/relatednews.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:themify_flutter/themify_flutter.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:jagomart/views/news/comment.dart';

class NewsPage extends StatefulWidget {
  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  ScrollController _scrollViewController = new ScrollController();
  bool isLoading = false;
  int currentPage = 1;
  final newsBloc = NewsBloc();

  @override
  void initState() {
    newsBloc.getnewstop(currentPage);
    _scrollViewController = ScrollController()..addListener(_scrollListener);
    super.initState();
  }

  _scrollListener() {
    if (_scrollViewController.offset >=
            _scrollViewController.position.maxScrollExtent &&
        !_scrollViewController.position.outOfRange) {
      setState(() {
        isLoading = true;
      });

      if (isLoading) {
        currentPage = currentPage + 1;
        getData(currentPage);
      }
    }
  }

  void getData(currentPage) async {
    bool news = await newsBloc.getnews(currentPage);
    if (!news) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _scrollViewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: SafeArea(
            child: Column(
          children: [
            Container(
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: Offset(0, 0),
                )
              ], color: Colors.white),
              height: 60.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Row(
                      children: <Widget>[
                        Image.asset(
                          'images/feeds.png',
                          fit: BoxFit.contain,
                          height: 24,
                        ),
                        SizedBox(
                          width: 5.0,
                        ),
                        Text(
                          'FEEDS',
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1
                              .copyWith(fontSize: 18.0, color: jagoRed),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
                child: RefreshIndicator(
                    onRefresh: _refresh,
                    child: SingleChildScrollView(
                        controller: _scrollViewController,
                        physics: const NeverScrollableScrollPhysics(),
                        child: StreamBuilder(
                          stream: newsBloc.newsStream,
                          builder: (context,
                              AsyncSnapshot<List<NewsViewModel>> snapshot) {
                            switch (snapshot.connectionState) {
                              case ConnectionState.waiting:
                                return Container(
                                  height: MediaQuery.of(context).size.height -
                                      (kToolbarHeight * 3),
                                  child: Center(
                                      child: Container(
                                    height: 35,
                                    child: LoadingIndicator(
                                      indicatorType: Indicator.circleStrokeSpin,
                                      color: jagoRed,
                                    ),
                                  )),
                                );

                              default:
                                if (snapshot.hasError) {
                                  return ErrorPage(
                                      MediaQuery.of(context).size.height -
                                          (kToolbarHeight * 2));
                                }

                                return ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: snapshot.data.length + 1,
                                    itemBuilder: (context, i) {
                                      if (i == snapshot.data.length) {
                                        if (isLoading) {
                                          return Container(
                                            height: 100,
                                            child: Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            ),
                                          );
                                        }
                                      }

                                      if (i == snapshot.data.length) {
                                        return InkWell(
                                          onTap: () {
                                            _scrollViewController.animateTo(
                                                (0.0 * i),
                                                duration: const Duration(
                                                    milliseconds: 300),
                                                curve: Curves.easeOut);
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.only(
                                                top: 10.0),
                                            width: double.infinity,
                                            height: 100,
                                            child: Column(
                                              children: [
                                                Icon(
                                                  Themify.angle_double_up,
                                                  color: Colors.grey,
                                                  size: 24,
                                                ),
                                                AutoSizeText(
                                                    'Batas Akhir Feeds Si Jago',
                                                    maxLines: 2,
                                                    overflow: TextOverflow.fade,
                                                    style: GoogleFonts.acme(
                                                      color: Colors.white,
                                                      fontSize: 24,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      shadows: [
                                                        Shadow(
                                                          blurRadius: 1.0,
                                                          color: Colors.black54,
                                                          offset:
                                                              Offset(1.0, 1.0),
                                                        ),
                                                      ],
                                                    )),
                                              ],
                                            ),
                                          ),
                                        );
                                      }
                                      return _buildCustomLinkPreview(
                                          context, snapshot.data[i]);
                                    });
                            }
                          },
                        ))))
          ],
        )),
      ),
    );
  }

  Future<void> _refresh() async {
    setState(() {
      currentPage = 1;
    });
    await newsBloc.getnewstop(currentPage);
  }

  Future<void> _launchURL(BuildContext context, String url) async {
    try {
      await launch(
        '$url',
        option: CustomTabsOption(
          enableDefaultShare: true,
          enableUrlBarHiding: true,
          showPageTitle: true,
          extraCustomTabs: const <String>[
            // ref. https://play.google.com/store/apps/details?id=org.mozilla.firefox
            'org.mozilla.firefox',
            // ref. https://play.google.com/store/apps/details?id=com.microsoft.emmx
            'com.microsoft.emmx',
          ],
        ),
      );
    } catch (e) {
      // An exception is thrown if browser app is not installed on Android device.
      debugPrint(e.toString());
    }
  }

  Widget _buildCustomLinkPreview(BuildContext context, NewsViewModel vn) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          _launchURL(context, vn.link);
        },
        child: Container(
          child: FlutterLinkPreview(
            url: vn.link,
            builder: (info) {
              if (info == null) return const SizedBox();
              if (info is WebImageInfo) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: FadeInImage.memoryNetwork(
                    placeholder: kTransparentImage,
                    image: info.image,
                    fit: BoxFit.contain,
                  ),
                );
              }

              final WebInfo webInfo = info;
              if (!WebAnalyzer.isNotEmpty(webInfo.title))
                return const SizedBox();
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color(0xFFF0F1F2),
                ),
                padding:
                    const EdgeInsets.symmetric(vertical: 2.0, horizontal: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Column(
                      children: [
                        Row(
                          children: <Widget>[
                            Container(
                              width: 35,
                              height: 35,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: FadeInImage.memoryNetwork(
                                  placeholder: kTransparentImage,
                                  image: webInfo.icon ?? "",
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                webInfo.title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.lato(
                                    fontSize: 16,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        if (WebAnalyzer.isNotEmpty(webInfo.description)) ...[
                          const SizedBox(height: 8),
                          Text(
                            webInfo.description,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                        if (WebAnalyzer.isNotEmpty(webInfo.image)) ...[
                          const SizedBox(height: 8),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: FadeInImage.memoryNetwork(
                              placeholder: kTransparentImage,
                              image: webInfo.image,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ],
                      ],
                    ),
                    Divider(),
                    RelatedNewsPage(
                      tags: vn.itemid,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        FlatButton(
                          child: Row(
                            children: <Widget>[
                              Icon(Icons.thumb_up,
                                  size: 16.0,
                                  color:
                                      (vn.isliked) ? jagoRed : Colors.black87),
                              SizedBox(
                                width: 5.0,
                              ),
                              Text(
                                '${(vn.like == 0) ? '' : vn.like} Suka',
                                style: TextStyle(
                                    color: (vn.isliked)
                                        ? jagoRed
                                        : Colors.black87),
                              )
                            ],
                          ),
                          onPressed: () async {
                            await newsBloc.isButtonliked(vn);
                          },
                        ),
                        FlatButton(
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.comment,
                                size: 16.0,
                                color: Colors.black54,
                              ),
                              SizedBox(
                                width: 5.0,
                              ),
                              Text(
                                'Komentar',
                                style: TextStyle(color: Colors.black87),
                              )
                            ],
                          ),
                          onPressed: () {
                            Navigator.of(context).push(
                              PageRouteBuilder(
                                opaque: false,
                                pageBuilder: (_, __, ___) => CommentPage(
                                  newsid: vn.id,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
