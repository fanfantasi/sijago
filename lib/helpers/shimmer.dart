import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:shimmer/shimmer.dart';
import 'package:ticket_pass_package/ticket_pass.dart';

class ShimmerItemHorizontalList extends StatelessWidget {
  final count;
  ShimmerItemHorizontalList({Key key, @required this.count}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      crossAxisCount: 1,
      padding: const EdgeInsets.only(top: 10.0),
      childAspectRatio: 2,
      children: List.generate(count, (index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300],
          highlightColor: Colors.grey[100],
          child: Card(
            color: Colors.white,
          ),
        );
      }),
    );
  }
}

class ShimmerItemVertical extends StatelessWidget {
  final count;
  ShimmerItemVertical({Key key, @required this.count}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StaggeredGridView.countBuilder(
      crossAxisCount: 4,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.only(top: 5.0),
      itemCount: count,
      itemBuilder: (BuildContext context, int index) => Shimmer.fromColors(
        baseColor: Colors.grey[300],
        highlightColor: Colors.grey[100],
        child: Container(
          height: 120,
          width: MediaQuery.of(context).size.width / 2.2,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 5,
                  blurRadius: 10,
                  offset: Offset(0, 5),
                )
              ]),
          padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
          margin: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
        ),
      ),
      staggeredTileBuilder: (int index) =>
          new StaggeredTile.count(2, index.isEven ? 2 : 1.6),
      mainAxisSpacing: 4.0,
      crossAxisSpacing: 4.0,
    );
  }
}

class ShimmerItemHorizontal extends StatelessWidget {
  final count;
  ShimmerItemHorizontal({Key key, @required this.count}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: 10.0),
        height: 220.0,
        width: double.infinity,
        child: ListView(
            scrollDirection: Axis.horizontal,
            children: List.generate(count, (i) {
              return Shimmer.fromColors(
                baseColor: Colors.grey[300],
                highlightColor: Colors.grey[100],
                child: Container(
                  width: MediaQuery.of(context).size.width / 2.2,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 5,
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        )
                      ]),
                  padding: const EdgeInsets.symmetric(
                      vertical: 5.0, horizontal: 5.0),
                  margin: const EdgeInsets.symmetric(
                      horizontal: 2.0, vertical: 2.0),
                ),
              );
            }).toList()));
  }
}

class ShimmerMitra extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: 10.0),
        height: 220.0,
        width: double.infinity,
        child: Shimmer.fromColors(
          baseColor: Colors.grey[300],
          highlightColor: Colors.grey[100],
          child: Container(
              width: MediaQuery.of(context).size.width / 1.08,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 5,
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    )
                  ]),
              padding:
                  const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
              margin: EdgeInsets.all(5)),
        ));
  }
}

class ShimmerInvoice extends StatelessWidget {
  final String text;
  ShimmerInvoice({Key key, @required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: <Widget>[
        Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Center(
                child: Shimmer.fromColors(
              baseColor: Colors.grey[300],
              highlightColor: Colors.grey[100],
              child: TicketPass(
                  width: MediaQuery.of(context).size.width / 1.1,
                  height: MediaQuery.of(context).size.height / 2.5,
                  child: Center(
                    child: Text(
                      text,
                      style: TextStyle(color: Colors.grey[600], fontSize: 24.0),
                    ),
                  )),
            ))),
      ],
    ));
  }
}

class ShimmerComment extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 500,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 30.0,
                )),
            Padding(
              padding: const EdgeInsets.only(top: 0.0),
              child: Container(
                height: 60.0,
                width: MediaQuery.of(context).size.width / 1.4,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(15))),
                child: Text("data"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
