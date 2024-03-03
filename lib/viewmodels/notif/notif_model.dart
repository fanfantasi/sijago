import 'package:jagomart/models/models.dart';

class NotifViewModel {
  NotifModel _notif;
  NotifViewModel({NotifModel notif}) : _notif = notif;

  String get id {
    return _notif.id;
  }

  String get notifid {
    return _notif.notifid;
  }

  String get title {
    return _notif.title;
  }

  String get message {
    return _notif.message;
  }

  String get image {
    return _notif.image;
  }

  int get read {
    return _notif.read;
  }

  int get status {
    return _notif.status;
  }

  String get created {
    return _notif.created;
  }
}
