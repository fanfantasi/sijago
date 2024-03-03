import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jagomart/viewmodels/viewmodels.dart';
import 'package:jagomart/views/widget/kategori.dart';
import 'package:provider/provider.dart';

class KategoriPage extends StatefulWidget {
  @override
  _KategoriPageState createState() => _KategoriPageState();
}

class _KategoriPageState extends State<KategoriPage> {
  @override
  void initState() {
    Provider.of<KategoriListViewModel>(context, listen: false).getkategori();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key('kategoriwidget'),
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
          child: Column(
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
              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(left: 15.0),
                height: 40.0,
                color: Colors.grey[200],
                child:
                    Text('Kategori', style: GoogleFonts.lato(fontSize: 16.0)),
              ),
              Padding(
                  padding:
                      const EdgeInsets.only(top: 5.0, left: 5.0, right: 5.0),
                  child: KategoriWidget(status: 2)),
            ],
          ),
        ),
      ),
    );
  }
}
