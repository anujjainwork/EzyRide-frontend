import 'package:flutter/material.dart';

class RideCreatedMapProvider extends ChangeNotifier{
  String _duration = '';
  String _distance = '';
  String _id = '';
  Map<String,List<String>> distDurationList = {};

  String get duration => _duration;
  String get distance => _distance;
  String get id => _id;

  void setDuration(String duration){
    _duration = duration;
    notifyListeners();
  }

  void setDistance(String distance){
    _distance = distance;
    notifyListeners();
  }

  void setId(String id){
    _id = id;
    notifyListeners();
  }

  void addDistDurationList(String id, String dist, String duration){
    distDurationList.putIfAbsent(id, () => [dist,duration]);
    notifyListeners();
  }
}