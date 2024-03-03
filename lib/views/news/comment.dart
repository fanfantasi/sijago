import 'package:emoji_picker/emoji_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:jagomart/viewmodels/viewmodels.dart';
import 'package:jagomart/helpers/shimmer.dart';
import 'package:jagomart/views/widget/card_comment.dart';
import 'package:jagomart/helpers/date_util.dart';
import 'package:themify_flutter/themify_flutter.dart';

class CommentPage extends StatefulWidget {
  final newsid;
  CommentPage({Key key, @required this.newsid}) : super(key: key);
  @override
  _CommentPageState createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  ScrollController _scrollViewController = new ScrollController();
  TextEditingController _textEditingController;
  int currentPage = 1;
  bool isShowSticker;

  @override
  void initState() {
    Provider.of<CommentListViewModel>(context, listen: false)
        .getcomment(currentPage, widget.newsid);
    _scrollViewController = ScrollController()..addListener(_scrollListener);
    super.initState();
    isShowSticker = false;
    _textEditingController = TextEditingController();
  }

  Future<bool> onBackPress() {
    if (isShowSticker) {
      setState(() {
        isShowSticker = false;
      });
    } else {
      Navigator.pop(context);
    }

    return Future.value(false);
  }

  @override
  void dispose() {
    super.dispose();
    _scrollViewController.dispose();
  }

  void _scrollListener() {
    if (_scrollViewController.position.pixels ==
        _scrollViewController.position.maxScrollExtent) {}
  }

  Widget _comment(CommentListViewModel vc) {
    switch (vc.loadingStatus) {
      case LoadingStatusKomentar.searching:
        return Expanded(
          child: Shimmer.fromColors(
              baseColor: Colors.grey[300],
              highlightColor: Colors.grey[100],
              child: ListView.builder(
                  itemCount: 8,
                  itemBuilder: (context, i) {
                    return ShimmerComment();
                  })),
        );
        break;

      case LoadingStatusKomentar.completed:
        return Expanded(
          child: ListView.builder(
            reverse: true,
            physics: BouncingScrollPhysics(),
            itemCount: vc.komentar?.length ?? 0,
            itemBuilder: (context, i) {
              return CardComment(
                pic: vc.komentar[i].avatar,
                username: vc.komentar[i].customer,
                comment: vc.komentar[i].komentar,
                created: tanggal(DateTime.parse(vc.komentar[i].created)),
              );
            },
          ),
        );
      case LoadingStatusKomentar.empty:
      default:
        return Expanded(
          child: ListView.builder(
            reverse: true,
            physics: BouncingScrollPhysics(),
            itemCount: vc.komentar?.length ?? 0,
            itemBuilder: (context, i) {
              return CardComment(
                pic: vc.komentar[i].avatar,
                username: vc.komentar[i].customer,
                comment: vc.komentar[i].komentar,
                created: tanggal(DateTime.parse(vc.komentar[i].created)),
              );
            },
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    var vc = Provider.of<CommentListViewModel>(context);
    return Dismissible(
        key: Key(widget.newsid),
        direction: DismissDirection.vertical,
        onDismissed: (direction) {
          Navigator.pop(context, Duration(microseconds: 0));
        },
        child: Scaffold(
            body: WillPopScope(
          child: Stack(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Align(
                      heightFactor: 4,
                      alignment: Alignment.bottomCenter,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            SizedBox(height: 2),
                            Align(
                                alignment: Alignment.topCenter,
                                child: Container(
                                  width: 46,
                                  height: 3,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(2),
                                      color: Colors.grey),
                                )),
                            SizedBox(height: 2),
                            Align(
                                alignment: Alignment.topCenter,
                                child: Container(
                                  width: 36,
                                  height: 3,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(2),
                                      color: Colors.grey),
                                )),
                          ])),

                  _comment(vc),

                  // Input content
                  buildInput(),

                  // Sticker
                  (isShowSticker ? buildSticker() : Container()),
                ],
              ),
            ],
          ),
          onWillPop: onBackPress,
        )));
  }

  Widget buildSticker() {
    return EmojiPicker(
      rows: 3,
      columns: 7,
      buttonMode: ButtonMode.MATERIAL,
      recommendKeywords: ["racing", "horse", "face", "happy", "party", "sad"],
      numRecommended: 50,
      onEmojiSelected: (emoji, category) {
        _textEditingController.text = _textEditingController.text + emoji.emoji;
        _textEditingController.selection = TextSelection.fromPosition(
            TextPosition(offset: _textEditingController.text.length));
      },
    );
  }

  Widget buildInput() {
    return Consumer<CommentListViewModel>(builder: (context, globalProv, _) {
      return Container(
        child: Row(
          children: <Widget>[
            Material(
              child: new Container(
                margin: new EdgeInsets.symmetric(horizontal: 1.0),
                child: new IconButton(
                  icon: new Icon(Themify.face_smile, color: Colors.blueGrey),
                  onPressed: () {
                    setState(() {
                      isShowSticker = !isShowSticker;
                    });
                  },
                  color: Colors.black87,
                ),
              ),
              color: Colors.white,
            ),

            // Edit text
            Flexible(
              child: Container(
                child: TextField(
                  controller: _textEditingController,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  style:
                      GoogleFonts.lato(color: Colors.blueGrey, fontSize: 14.0),
                  decoration: InputDecoration.collapsed(
                    hintText: 'Tulis komentar anda...',
                    hintStyle: TextStyle(color: Colors.blueGrey),
                  ),
                ),
              ),
            ),

            // Button send message
            Material(
              child: new Container(
                margin: new EdgeInsets.symmetric(horizontal: 8.0),
                child: new IconButton(
                  icon: new Icon(Icons.send),
                  onPressed: () {
                    if (_textEditingController.text.isNotEmpty) {
                      globalProv
                          .insertComment(
                              widget.newsid, _textEditingController.text)
                          .then((value) {
                        globalProv.addComment(value);
                      });
                      setState(() {
                        _textEditingController.clear();
                      });
                    }
                  },
                  color: Colors.blueGrey,
                ),
              ),
              color: Colors.white,
            ),
          ],
        ),
        width: double.infinity,
        height: 50.0,
        decoration: new BoxDecoration(
            border: new Border(
                top: new BorderSide(color: Colors.blueGrey, width: 0.5)),
            color: Colors.white),
      );
    });
  }
}

class CommentForm extends StatefulWidget {
  final newsid;
  CommentForm({@required this.newsid});

  @override
  _CommentFormState createState() => _CommentFormState();
}

class _CommentFormState extends State<CommentForm> {
  TextEditingController _textEditingController;
  @override
  void initState() {
    _textEditingController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CommentListViewModel>(
      builder: (context, globalProv, _) {
        return Container(
          color: Colors.grey.withAlpha(50),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.white,
                    ),
                    child: TextField(
                      onSubmitted: (value) {
                        if (value.isNotEmpty) {
                          globalProv
                              .insertComment(widget.newsid, value)
                              .then((value) {
                            globalProv.addComment(value);
                          });
                          setState(() {
                            _textEditingController.clear();
                          });
                        }
                      },
                      controller: _textEditingController,
                      decoration: InputDecoration(
                          hintText: 'Tulis Komentar anda ....',
                          border: InputBorder.none,
                          hintStyle: TextStyle(color: Colors.grey)),
                    ),
                  ),
                ),
                Container(
                  child: IconButton(
                    onPressed: () {
                      if (_textEditingController.text.isNotEmpty) {
                        globalProv
                            .insertComment(
                                widget.newsid, _textEditingController.text)
                            .then((value) {
                          globalProv.addComment(value);
                        });
                        setState(() {
                          _textEditingController.clear();
                        });
                      }
                    },
                    icon: Icon(Icons.send),
                    color: Theme.of(context).primaryColor,
                    iconSize: 35,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
