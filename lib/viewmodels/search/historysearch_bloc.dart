import 'package:jagomart/database/database.dart';
import 'package:jagomart/database/searchmodel.dart';
import 'package:rxdart/rxdart.dart';

class HistorySearchBloc {
  final PublishSubject _isHistory = PublishSubject<List<SearchItem>>();

  Stream<List<SearchItem>> get isHistory => _isHistory.stream;

  void dispose() async {
    await _isHistory.drain();
    _isHistory.close();
  }

  void getHistory() async {
    List<SearchItem> _history = await DBProvider.db.getSearch();
    _isHistory.sink.add(_history);
  }

  void insertHistory(value) async {
    List<SearchItem> _history = await DBProvider.db.getSearchByItem(value);
    if (_history.length == 0) {
      await DBProvider.db.newSearch(SearchItem(item: value));
    }
    getHistory();
  }

  void removeHistoryBy(id) async {
    await DBProvider.db.deleteHistoryBy(id);
    getHistory();
  }

  void removeAllHistory() async {
    await DBProvider.db.deleteAllHistory();
    getHistory();
  }
}
