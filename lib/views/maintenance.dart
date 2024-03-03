import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flare_flutter/flare_actor.dart';

class MaintenancePage extends StatelessWidget {
  final String tag;
  MaintenancePage({@required this.tag});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(tag),
      direction: DismissDirection.vertical,
      onDismissed: (direction) {
        Navigator.pop(context, Duration(microseconds: 0));
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              )),
          margin: const EdgeInsets.only(top: kToolbarHeight * 2),
          child: Center(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Align(
                      heightFactor: 4,
                      alignment: Alignment.center,
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
                  Expanded(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Hero(
                        tag: tag,
                        child: Container(
                          width: MediaQuery.of(context).size.width / 1.01,
                          height: MediaQuery.of(context).size.height / 1.5,
                          child: FlareActor(
                            "assets/maintenance.flr",
                            animation: "delivery",
                            fit: BoxFit.fitHeight,
                            alignment: Alignment.center,
                          ),
                        ),
                      ),
                      AutoSizeText(
                        'Masih Dalam Proses',
                        style: GoogleFonts.lato(fontSize: 18.0),
                      ),
                    ],
                  ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
