import 'dart:async';
import 'dart:convert';
import 'dart:isolate';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:mbm_elearning/Data/Repository/sheet_scrap.dart';
import 'package:mbm_elearning/Data/model/admins_model.dart';
import 'package:mbm_elearning/Data/model/blog_model.dart';
import 'package:mbm_elearning/Data/model/events_model.dart';
import 'package:mbm_elearning/Data/model/explore_model.dart';
import 'package:mbm_elearning/Data/model/useful_links_model.dart';
import 'package:mbm_elearning/Presentation/Constants/constants.dart';
import 'package:mbm_elearning/Presentation/Screens/Dashboard/Home/dashboard.dart';

class ScrapTableProvider with ChangeNotifier {
  Map? banner1;
  Map? banner2;
  Map? banner3;
  final Set<Map<String, dynamic>> _materials = {};
  Set<Map<String, dynamic>> get materials => _materials;
  final Set<BlogModel> _blogPosts = {};
  Set<BlogModel> get blogPosts => _blogPosts;
  final Set<EventsModel> _events = {};
  Set<EventsModel> get events => _events;
  final Set<ExploreModel> _explores = {};
  Set<ExploreModel> get explores => _explores;
  final Set<UsefulLinksModel> _usefulLinks = {};
  Set<UsefulLinksModel> get usefulLinks => _usefulLinks;
  final Set<AdminsModel> _admins = {};
  Set<AdminsModel> get admins => _admins;
  bool isGettingData = false;
  bool isGettingMaterialData = false;
  bool isGettingBlogPostsData = false;
  bool isGettingEventsData = false;
  bool isGettingExploreData = false;
  bool isGettingUsefulLinksData = false;
  bool isGettingAdminsData = false;

  void clearAll() {
    scrapSubscriptionIsGettingData.close();
  }

  bool checkIsMeSuperAdmin() {
    return _admins
        .where((AdminsModel element) =>
            getContains(element.uid!, FirebaseAuth.instance.currentUser!.uid) &&
            getContains(element.status!, 'true'))
        .toSet()
        .isNotEmpty;
  }

  updateGettingBlogPostsStatus(bool status) {
    isGettingBlogPostsData = status;
    notifyListeners();
  }

  updateGettingEventsStatus(bool status) {
    isGettingEventsData = status;
    notifyListeners();
  }

  updateGettingExploreStatus(bool status) {
    isGettingExploreData = status;
    notifyListeners();
  }

  updateGettingUsefulLinksStatus(bool status) {
    isGettingUsefulLinksData = status;
    notifyListeners();
  }

  updateGettingMaterialStatus(bool status) {
    isGettingMaterialData = status;
    notifyListeners();
  }

  bool checkIsNotEmpty() {
    if (_materials.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> scrapAllData() async {
    scrapSubscriptionIsGettingData.sink.add(true);
    if (_materials.isNotEmpty) {
      _materials.clear();
    }
    if (_blogPosts.isNotEmpty) {
      _blogPosts.clear();
    }
    if (_events.isNotEmpty) {
      _events.clear();
    }
    if (_explores.isNotEmpty) {
      _explores.clear();
    }
    if (_usefulLinks.isNotEmpty) {
      _usefulLinks.clear();
    }
    if (_admins.isNotEmpty) {
      _admins.clear();
    }
    bool scrapMt = true;
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      if (user.photoURL!.contains(student) ||
          user.photoURL!.contains(teacher)) {
        scrapMt = true;
      } else {
        scrapMt = false;
      }
    }
    isGettingData = true;
    List data = await Scrap.scrapAllData(scrapMt: scrapMt);
    if (scrapMt) {
      _materials.addAll(data[0] as Set<Map<String, dynamic>>);
    }
    _blogPosts.addAll(data[1] as Set<BlogModel>);
    _explores.addAll(data[2] as Set<ExploreModel>);
    _events.addAll(data[3] as Set<EventsModel>);
    _usefulLinks.addAll(data[4] as Set<UsefulLinksModel>);
    _admins.addAll(data[5] as Set<AdminsModel>);
    isGettingData = false;
    scrapSubscriptionIsGettingData.sink.add(false);
    notifyListeners();
  }

  Future<void> updateScrapMaterial() async {
    if (_materials.isNotEmpty) {
      _materials.clear();
    }
    updateGettingMaterialStatus(true);
    _materials.addAll(await Scrap.scrapMaterial());
    _materials.toSet();
    updateGettingMaterialStatus(false);
    notifyListeners();
  }

  Future<void> updateScrapBlogPosts() async {
    await Future.delayed(Duration(seconds: 1));
    if (_blogPosts.isNotEmpty) {
      _blogPosts.clear();
    }
    updateGettingBlogPostsStatus(true);
    Set<BlogModel> data = await Scrap.scrapBlogPosts();
    _blogPosts.addAll(data);
    _blogPosts.toSet();
    updateGettingBlogPostsStatus(false);
    notifyListeners();
  }

  BlogModel? getBlogPostById(int id) {
    Iterable<BlogModel> out = _blogPosts.where((element) => element.id == id);
    if (out.isNotEmpty) {
      return out.first;
    }
    return null;
  }

  Future<void> updateScrapEvents() async {
    if (_events.isNotEmpty) {
      _events.clear();
    }
    updateGettingEventsStatus(true);
    _events.addAll(await Scrap.scrapEvents());
    _events.toSet();
    updateGettingEventsStatus(false);
    notifyListeners();
  }

  EventsModel? getEventById(int id) {
    Iterable<EventsModel> out = _events.where((element) => element.id == id);
    if (out.isNotEmpty) {
      return out.first;
    }
    return null;
  }

  Future<void> updateScrapExplore() async {
    if (_explores.isNotEmpty) {
      _explores.clear();
    }
    updateGettingExploreStatus(true);
    _explores.addAll(await Scrap.scrapExplores());
    _explores.toSet();
    updateGettingExploreStatus(false);
    notifyListeners();
  }

  ExploreModel? getExploreById(int id) {
    Iterable<ExploreModel> out = _explores.where((element) => element.id == id);
    if (out.isNotEmpty) {
      return out.first;
    }
    return null;
  }

  Future<void> updateScrapUsefulLinks() async {
    if (_usefulLinks.isNotEmpty) {
      _usefulLinks.clear();
    }
    updateGettingUsefulLinksStatus(true);
    _usefulLinks.addAll(await Scrap.scrapUsefullinks());
    _usefulLinks.toSet();
    updateGettingUsefulLinksStatus(false);
    notifyListeners();
  }

  Set<Map<String, dynamic>> getMaterialsBySemesterAndBranch(
      String semester, String type,
      {String? branch}) {
    if (branch == null || branch == '') {
      return _materials
          .where((element) =>
              getContains(element["mtsem"], semester) &&
              getContains(element["mttype"], type) &&
              getContains(element["approve"], 'true'))
          .toSet();
    } else {
      return _materials
          .where((element) =>
              getContains(element["mtsem"], semester) &&
              getContains(element["mttype"], type) &&
              element["branch"] == branch &&
              getContains(element["approve"], 'true'))
          .toSet();
    }
  }

  Set<Map<String, dynamic>> getMaterialsByUserid(String uid) {
    return _materials
        .where((element) => element["uploaded_by_user_uid"] == uid)
        .toSet();
  }

  Set<Map<String, dynamic>> getUnapproveMaterials() {
    return _materials
        .where((element) => getContains(element["approve"], 'false'))
        .toSet();
  }

  Set<Map<String, dynamic>> getMaterialsByQuary(String quary) {
    return _materials
        .where((element) =>
            getContains(element["mtname"], quary) ||
            getContains(element["desc"], quary) ||
            getContains(element["mtsem"], quary) ||
            getContains(element["mtsub"], quary) ||
            getContains(element["mttype"], quary) ||
            getContains(element["branch"], quary) &&
                getContains(element["approve"], 'true'))
        .toSet();
  }

  getCustomAds() async {
    List<Map<dynamic, dynamic>> data = await Scrap.getCustomAds();
    Map ads = data[0];
    banner1 = jsonDecode(ads['banner1']);
    banner2 = jsonDecode(ads['banner2']);
    banner3 = jsonDecode(ads['banner3']);
    notifyListeners();
  }
}

bool getContains(String a, String q) {
  return a.toString().toLowerCase().contains(q.toString().toLowerCase());
}
