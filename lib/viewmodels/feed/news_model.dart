import 'package:jagomart/models/models.dart';

class NewsViewModel {
  NewsModel _news;
  NewsViewModel({NewsModel news}) : _news = news;

  String get id {
    return _news.id;
  }

  String get link {
    return _news.link;
  }

  int get like {
    return _news.like;
  }

  String get itemid {
    return _news.itemid;
  }

  bool get isliked {
    return _news.isliked;
  }
}
