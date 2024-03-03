import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jagomart/helpers/app_colors.dart';
import 'package:jagomart/helpers/date_util.dart';
import 'package:jagomart/viewmodels/tracking/tracking_view_model.dart';
import 'package:jagomart/viewmodels/tracking/traking_model.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:timeline_tile/timeline_tile.dart';

class TrackingPage extends StatefulWidget {
  TrackingPage({this.title, this.transid});
  final title;
  final transid;
  @override
  _TrackingPageState createState() => _TrackingPageState();
}

enum _DeliveryStatus { done, doing, todo }

class _TrackingPageState extends State<TrackingPage> {
  final trackingBloc = TrackingBloc();

  @override
  void initState() {
    trackingBloc.getTracking(widget.transid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${widget.title}',
          style: GoogleFonts.lato(),
        ),
      ),
      body: StreamBuilder(
        stream: trackingBloc.trackingStream,
        builder: (context, AsyncSnapshot<List<TrackingViewModel>> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(
                child: Container(
                  color: Colors.transparent,
                  width: 65,
                  height: 65,
                  padding: EdgeInsets.all(12.0),
                  child: LoadingIndicator(
                      color: jagoRed,
                      indicatorType: Indicator.circleStrokeSpin),
                ),
              );
              break;

            default:
              if (snapshot.hasError) {
                return Container();
              }

              final currentStep = 0;

              return Stack(
                children: [
                  Positioned.fill(
                    bottom: null,
                    child: new ClipPath(
                      clipper: new DialogonalClipper(),
                      child: new Image.asset(
                        'images/tracking.png',
                        fit: BoxFit.cover,
                        height: 256.0,
                        colorBlendMode: BlendMode.srcOver,
                        color: new Color.fromARGB(120, 162, 162, 162),
                      ),
                    ),
                  ),
                  Padding(
                    padding: new EdgeInsets.only(top: 256.0),
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: new EdgeInsets.only(left: 64.0),
                          child: new Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              new Text(
                                'Tracking Pesanan',
                                style: new TextStyle(fontSize: 34.0),
                              ),
                              new Text(
                                '${tanggalbooking(DateTime.now())}',
                                style: new TextStyle(
                                    color: Colors.grey, fontSize: 12.0),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                            child: ListView(
                                physics: BouncingScrollPhysics(),
                                children:
                                    List.generate(snapshot.data.length, (i) {
                                  final step = snapshot.data[i];
                                  var indicatorSize = 30.0;
                                  var beforeLineStyle = LineStyle(
                                    color: Colors.grey.withOpacity(0.8),
                                  );
                                  _DeliveryStatus status;
                                  LineStyle afterLineStyle;
                                  if (i == currentStep) {
                                    status = _DeliveryStatus.doing;
                                    beforeLineStyle = const LineStyle(
                                        thickness: 3, color: Color(0xFF747888));
                                  } else if (i > currentStep) {
                                    status = _DeliveryStatus.done;
                                    beforeLineStyle = const LineStyle(
                                        thickness: 3, color: Color(0xFF747888));
                                  } else {
                                    beforeLineStyle = const LineStyle(
                                        thickness: 3, color: Color(0xFF747888));
                                    status = _DeliveryStatus.todo;
                                  }

                                  return TimelineTile(
                                    axis: TimelineAxis.vertical,
                                    alignment: TimelineAlign.manual,
                                    lineXY: 0.3,
                                    isFirst: i == 0,
                                    isLast: i == snapshot.data.length - 1,
                                    beforeLineStyle: beforeLineStyle,
                                    afterLineStyle: afterLineStyle,
                                    indicatorStyle: IndicatorStyle(
                                      width: indicatorSize,
                                      height: indicatorSize,
                                      indicator:
                                          _IndicatorDelivery(status: status),
                                    ),
                                    startChild: _StartChildDelivery(
                                      index: snapshot.data.length - i,
                                      current: i == currentStep,
                                    ),
                                    endChild: _EndChildDelivery(
                                      text: step.message,
                                      date: step.created,
                                      current: i == currentStep,
                                    ),
                                  );
                                })))
                      ],
                    ),
                  )
                ],
              );
          }
        },
      ),
    );
  }
}

class _StartChildDelivery extends StatelessWidget {
  const _StartChildDelivery({
    Key key,
    this.index,
    @required this.current,
  }) : super(key: key);
  final bool current;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Container(
        child: Center(
          child: Image.asset(
            'images/tracking/$index.png',
            height: 44,
            color: current ? const Color(0xFF2ACA8E) : Colors.grey,
          ),
        ),
      ),
    );
  }
}

class _EndChildDelivery extends StatelessWidget {
  const _EndChildDelivery({
    Key key,
    @required this.text,
    @required this.current,
    @required this.date,
  }) : super(key: key);

  final String text;
  final String date;
  final bool current;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 150),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 100),
        child: Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: Text(
                  '$text',
                  style: GoogleFonts.lato(
                    fontSize: 16,
                    color: current ? const Color(0xFF2ACA8E) : Colors.grey,
                    fontWeight: current ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
              Flexible(
                child: Text(
                  '${tanggal(DateTime.parse(date))}',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.lato(
                    fontSize: 12,
                    color: current ? const Color(0xFF2ACA8E) : Colors.grey,
                    fontStyle: FontStyle.italic,
                    fontWeight: current ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DialogonalClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = new Path();
    path.lineTo(0.0, size.height - 60.0);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

class _IndicatorDelivery extends StatelessWidget {
  const _IndicatorDelivery({Key key, this.status, this.message})
      : super(key: key);

  final _DeliveryStatus status;
  final String message;

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case _DeliveryStatus.done:
        return Container(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFFb5043f),
          ),
          child: const Center(
            child: Icon(Icons.check, color: Colors.white),
          ),
        );
      case _DeliveryStatus.doing:
        return Container(
          decoration:
              const BoxDecoration(shape: BoxShape.circle, color: Colors.green),
          child: const Center(
            child: Icon(Icons.check, color: Colors.white),
          ),
        );
      case _DeliveryStatus.todo:
        return Container(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFF747888),
          ),
          child: Center(
            child: Container(
              width: 10,
              height: 10,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF5D6173),
              ),
            ),
          ),
        );
    }
    return Container();
  }
}
