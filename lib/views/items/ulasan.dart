import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:jagomart/helpers/date_util.dart';
import 'package:jagomart/viewmodels/ulasan/ulasan_model.dart';
import 'package:jagomart/viewmodels/ulasan/ulasan_view_model.dart';
import 'package:shimmer/shimmer.dart';
import 'package:themify_flutter/themify_flutter.dart';

class UlasanPage extends StatefulWidget {
  final UlasanBloc ulasanBloc;
  UlasanPage({Key key, this.ulasanBloc}) : super(key: key);
  @override
  _UlasanPageState createState() => _UlasanPageState();
}

class _UlasanPageState extends State<UlasanPage> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: widget.ulasanBloc.ulasanStream,
      builder: (context, AsyncSnapshot<List<UlasanViewModel>> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return Text('Error', style: TextStyle(color: Colors.white));
          case ConnectionState.waiting:
            return SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, i) {
                  return Shimmer.fromColors(
                      baseColor: Colors.grey[300],
                      highlightColor: Colors.grey[100],
                      child: ListTile(
                          leading: CircleAvatar(
                            radius: 25.0,
                            backgroundColor: Colors.white,
                          ),
                          title: Padding(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: Container(
                              height: 10.0,
                              width: MediaQuery.of(context).size.width / 3.2,
                              color: Colors.white,
                            ),
                          ),
                          subtitle: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 5.0, bottom: 5.0),
                                child: Container(
                                  height: 10.0,
                                  width:
                                      MediaQuery.of(context).size.width / 2.2,
                                  color: Colors.white,
                                ),
                              ),
                              Container(
                                height: 50.0,
                                color: Colors.white,
                              ),
                            ],
                          )));
                },
                childCount: 2,
              ),
            );
          default:
            if (snapshot.hasError) {
              return new Center(
                child: Text('Error Data'),
              );
            }
            return snapshot.data.length == 0
                ? SliverList(
                    delegate: SliverChildListDelegate([
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Text('Belum Ada Ulasan untuk produk ini.'),
                        ),
                      )
                    ]),
                  )
                : SliverList(
                    delegate:
                        SliverChildBuilderDelegate((BuildContext context, i) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 25.0,
                            backgroundImage: NetworkImage(
                              "${snapshot.data[i].avatar}",
                            ),
                          ),
                          title: Text("${snapshot.data[i].customer}"),
                          subtitle: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  RatingBar.builder(
                                    initialRating: snapshot.data[i].rating ==
                                            null
                                        ? 0.0
                                        : double.parse(
                                            snapshot.data[i].rating.toString()),
                                    minRating: 1,
                                    direction: Axis.horizontal,
                                    allowHalfRating: true,
                                    itemCount: 5,
                                    itemPadding:
                                        EdgeInsets.symmetric(horizontal: 2.0),
                                    itemSize: 14.0,
                                    itemBuilder: (context, _) => Icon(
                                      Themify.star,
                                      color: Colors.green,
                                    ),
                                    onRatingUpdate: (rating) {
                                      print(rating);
                                    },
                                  ),
                                  SizedBox(width: 10.0),
                                  Text(
                                    tanggal(
                                        DateTime.parse(snapshot.data[i].date)),
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 7.0),
                              Text(
                                "${snapshot.data[i].remarks}",
                              ),
                            ],
                          ),
                        ),
                      );
                    }, childCount: snapshot.data?.length ?? 0),
                  );
        }
      },
    );
  }
}
