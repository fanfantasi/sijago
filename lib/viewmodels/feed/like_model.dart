import 'package:jagomart/models/models.dart';

class LikeViewModel {
  LikeModel _like;
  LikeViewModel({LikeModel like}) : _like = like;

  int get id {
    return _like.id;
  }

  int get like {
    return _like.like;
  }
}
