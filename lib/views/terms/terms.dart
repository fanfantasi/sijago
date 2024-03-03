import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:jagomart/viewmodels/terms/terms_view_model.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:provider/provider.dart';

class TermsPage extends StatefulWidget {
  final title;
  final field;
  TermsPage({this.title, this.field});
  @override
  _TermsPageState createState() => _TermsPageState();
}

class _TermsPageState extends State<TermsPage> {
  @override
  void initState() {
    Provider.of<TermsListViewModel>(context, listen: false)
        .getterms(widget.field);
    super.initState();
  }

  Widget _terms(TermsListViewModel vt) {
    switch (vt.loadingStatus) {
      case LoadingStatusTerms.searching:
        return Center(
          child: Container(
            color: Colors.transparent,
            width: 65,
            height: 65,
            padding: EdgeInsets.all(12.0),
            child: LoadingIndicator(
              indicatorType: Indicator.circleStrokeSpin,
              color: Theme.of(context).primaryColor,
            ),
          ),
        );
      case LoadingStatusTerms.completed:
        return ListView(
          physics: BouncingScrollPhysics(),
          children: [
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(left: 15.0),
              height: 50.0,
              color: Colors.grey[200],
              child: Text(
                '${widget.title.toString().toUpperCase()}',
                style: Theme.of(context)
                    .textTheme
                    .subtitle2
                    .copyWith(color: Colors.grey[700], fontSize: 12.0),
              ),
            ),
            Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10.0, vertical: 10.0),
                color: Colors.white,
                child: Html(data: vt.terms[0].message)),
          ],
        );
      case LoadingStatusTerms.empty:
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    var vt = Provider.of<TermsListViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        title: Text(
          widget.title,
          style: TextStyle(color: Colors.black87),
        ),
      ),
      body: _terms(vt),
    );
  }
}
