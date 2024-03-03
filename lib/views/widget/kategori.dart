import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jagomart/helpers/app_colors.dart';
import 'package:jagomart/helpers/kategori.dart';
import 'package:jagomart/helpers/link_helper.dart';
import 'package:jagomart/viewmodels/kategori/kategori_view_model.dart';
import 'package:jagomart/views/kategori/kategori.dart';
import 'package:jagomart/views/kategoriitem/kategoriitem.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:themify_flutter/themify_flutter.dart';

class KategoriWidget extends StatefulWidget {
  final int status;
  KategoriWidget({@required this.status});
  @override
  _KategoriWidgetState createState() => _KategoriWidgetState();
}

class _KategoriWidgetState extends State<KategoriWidget> {
  //Loding Kategori
  Widget _kategori(KategoriListViewModel vk) {
    switch (vk.loadingStatus) {
      case LoadingStatus.searching:
        return Shimmer.fromColors(
            baseColor: Colors.grey[300],
            highlightColor: Colors.grey[100],
            child: GridView.count(
                crossAxisCount: 4,
                shrinkWrap: true,
                children: List.generate(4, (i) {
                  return Container(
                      width: 80,
                      child: Column(
                        children: <Widget>[
                          CircleAvatar(
                            radius: 30.0,
                            backgroundColor: Colors.grey[300],
                            child: CircleAvatar(
                              radius: 25.0,
                              backgroundColor: Colors.grey,
                            ),
                          ),
                          Text(
                            'Loading',
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      ));
                })));
      case LoadingStatus.completed:
        if (widget.status == 1) {
          return GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
            ),
            itemCount: 4,
            addAutomaticKeepAlives: true,
            itemBuilder: (context, i) {
              if (i == 3) {
                return InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      PageRouteBuilder(
                        opaque: false,
                        pageBuilder: (_, __, ___) => KategoriPage(),
                      ),
                    );
                  },
                  child: Container(
                    width: 70,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        CircleAvatar(
                          radius: 30.0,
                          backgroundColor: Colors.grey[100],
                          child: CircleAvatar(
                            radius: 25.0,
                            backgroundColor: jagoRed,
                            child: Icon(
                              Themify.layout_grid2,
                              color: jagoWhite,
                            ),
                          ),
                        ),
                        Text(
                          'Lainnya',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.lato(color: Colors.black87),
                        )
                      ],
                    ),
                  ),
                );
              } else {
                return InkWell(
                  onTap: () {
                    push(
                        context,
                        KategoriItemPage(
                          id: vk.kategori[i].id.toString(),
                          title: vk.kategori[i].kategori,
                        ));
                  },
                  child: KategoriItem(
                    images: vk.kategori[i].icon,
                    title: vk.kategori[i].kategori,
                    textcolor: Colors.black87.withOpacity(0.7),
                  ),
                );
              }
            },
          );
        } else {
          return GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
              ),
              itemCount: vk.kategori?.length ?? 0,
              addAutomaticKeepAlives: true,
              itemBuilder: (context, i) {
                return InkWell(
                  onTap: () {
                    push(
                        context,
                        KategoriItemPage(
                          id: vk.kategori[i].id.toString(),
                          title: vk.kategori[i].kategori,
                        ));
                  },
                  child: KategoriItem(
                    images: vk.kategori[i].icon,
                    title: vk.kategori[i].kategori,
                    textcolor: Colors.black87.withOpacity(0.5),
                  ),
                );
              });
        }
        break;

      case LoadingStatus.empty:
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    var vk = Provider.of<KategoriListViewModel>(context);
    return _kategori(vk);
  }
}
