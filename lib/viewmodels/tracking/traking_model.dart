import 'package:jagomart/models/models.dart';
import 'package:jagomart/models/tracking.dart';

class TrackingViewModel {
  TrackingModel _tracking;
  TrackingViewModel({TrackingModel tracking}) : _tracking = tracking;

  String get id {
    return _tracking.id;
  }

  String get transid {
    return _tracking.transid;
  }

  String get message {
    return _tracking.message;
  }

  String get desc {
    return _tracking.desc;
  }

  String get date {
    return _tracking.date;
  }

  String get created {
    return _tracking.created;
  }
}
