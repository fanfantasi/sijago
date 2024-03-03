import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jagomart/config/web_service.dart';
import 'package:jagomart/models/models.dart';
import 'package:jagomart/viewmodels/feed/like_model.dart';
import 'package:jagomart/viewmodels/feed/news_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewsBloc {
  List<NewsViewModel> news = [];
  List idnews = [];
  List<LikeViewModel> liked = [];
  List<NewsModel> newsLiked = [];
  final StreamController<List<NewsViewModel>> _newsController =
      StreamController<List<NewsViewModel>>.broadcast();
  Stream<List<NewsViewModel>> get newsStream => _newsController.stream;

  void dispose() async {
    await newsStream.drain();
    _newsController.close();
  }

  Future<void> getnewstop(int start) async {
    try {
      List<NewsModel> itemnews = await Webservice().getNews(start);
      this.idnews = itemnews.map((e) => e.id).toList();
      await getlike(idnews.toList());
      this.newsLiked = itemnews;
      for (int i = 0; i < this.liked.length; i++) {
        int index = this.newsLiked.indexWhere(
            (element) => int.parse(element.id) == this.liked[i].like);
        this.newsLiked[index].isliked = !this.newsLiked[index].isliked;
      }
      this.news.clear();
      this.news = this.newsLiked.map((e) => NewsViewModel(news: e)).toList();
      _newsController.sink.add(this.news);
    } catch (e) {
      _newsController.sink.addError(e);
    }
  }

  Future<bool> getnews(int start) async {
    try {
      List<NewsModel> itemnews = await Webservice().getNews(start);
      this.idnews = itemnews.map((e) => e.id).toList();
      await getlike(idnews.toList());
      this.newsLiked = itemnews;
      for (int i = 0; i < this.liked.length; i++) {
        int index = this.newsLiked.indexWhere(
            (element) => int.parse(element.id) == this.liked[i].like);
        this.newsLiked[index].isliked = !this.newsLiked[index].isliked;
      }
      this.news = this.newsLiked.map((e) => NewsViewModel(news: e)).toList();
      if (news.isEmpty) {
        return false;
      } else {
        _newsController.sink.add(this.news);
        return true;
      }
    } catch (e) {
      _newsController.sink.addError(e);
    }
    return null;
  }

  Future<void> getlike(newsid) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    if (token != null) {
      try {
        this.liked.clear();
        List<LikeModel> likenews = await Webservice().getLike(token, newsid);
        this.liked = likenews.map((e) => LikeViewModel(like: e)).toList();
      } catch (e) {
        print(e);
      }
    }
  }

  Future<void> isButtonliked(NewsViewModel newsitem) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    if (token != null) {
      if (newsitem.isliked) {
        int index =
            this.newsLiked.indexWhere((element) => element.id == newsitem.id);
        this.newsLiked[index].isliked = !this.newsLiked[index].isliked;
        this.newsLiked[index].like = newsitem.like - 1;
        await Webservice()
            .getdeletedlike(token, int.parse(newsitem.id), newsitem.like);
        _newsController.sink.add(this.news);
      } else {
        int index =
            this.newsLiked.indexWhere((element) => element.id == newsitem.id);
        this.newsLiked[index].isliked = !this.newsLiked[index].isliked;
        this.newsLiked[index].like = newsitem.like + 1;
        await Webservice()
            .getinitlike(token, int.parse(newsitem.id), newsitem.like);
      }
      this.news = this.newsLiked.map((e) => NewsViewModel(news: e)).toList();
      _newsController.sink.add(this.news);
    } else {
      Fluttertoast.showToast(
          msg: "Silahkan login terlebih dahulu",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          textColor: Colors.white,
          fontSize: 14.0);
    }
  }
}
