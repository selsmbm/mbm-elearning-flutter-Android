import 'package:flutter/widgets.dart';
import 'package:mbm_elearning/Data/Repository/sheet_scrap.dart';
import 'package:mbm_elearning/Data/model/blog_model.dart';
import 'package:mbm_elearning/Data/model/events_model.dart';
import 'package:mbm_elearning/Data/model/explore_model.dart';
import 'package:mbm_elearning/Data/model/useful_links_model.dart';

class ScrapTableProvider with ChangeNotifier {
  final List<Map<String, dynamic>> _materials = [];
  List<Map<String, dynamic>> get materials => _materials;
  final List<BlogModel> _blogPosts = [];
  List<BlogModel> get blogPosts => _blogPosts;
  final List<EventsModel> _events = [];
  List<EventsModel> get events => _events;
  final List<ExploreModel> _explores = [];
  List<ExploreModel> get explores => _explores;
  final List<UsefulLinksModel> _usefulLinks = [];
  List<UsefulLinksModel> get usefulLinks => _usefulLinks;
  bool isGettingData = false;
  bool isGettingMaterialData = false;
  bool isGettingBlogPostsData = false;
  bool isGettingEventsData = false;
  bool isGettingExploreData = false;
  bool isGettingUsefulLinksData = false;

  bool checkIsNotEmpty() {
    if (_materials.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> scrapAllData() async {
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
    isGettingData = true;
    List data = await Scrap.scrapAllData();
    _materials.addAll(data[0] as List<Map<String, dynamic>>);
    _blogPosts.addAll(data[1] as List<BlogModel>);
    _explores.addAll(data[2] as List<ExploreModel>);
    _events.addAll(data[3] as List<EventsModel>);
    _usefulLinks.addAll(data[4] as List<UsefulLinksModel>);
    isGettingData = false;
    notifyListeners();
  }

  Future<void> updateScrapMaterial() async {
    if (_materials.isNotEmpty) {
      _materials.clear();
    }
    isGettingMaterialData = true;
    _materials.addAll(await Scrap.scrapMaterial());
    isGettingMaterialData = false;
    notifyListeners();
  }

  Future<void> updateScrapBlogPosts() async {
    if (_blogPosts.isNotEmpty) {
      _blogPosts.clear();
    }
    isGettingBlogPostsData = true;
    _blogPosts.addAll(await Scrap.scrapBlogPosts());
    isGettingBlogPostsData = false;
    notifyListeners();
  }

  Future<void> updateScrapEvents() async {
    if (_events.isNotEmpty) {
      _events.clear();
    }
    isGettingEventsData = true;
    _events.addAll(await Scrap.scrapEvents());
    isGettingEventsData = false;
    notifyListeners();
  }

  Future<void> updateScrapExplore() async {
    if (_explores.isNotEmpty) {
      _explores.clear();
    }
    isGettingExploreData = true;
    _explores.addAll(await Scrap.scrapExplores());
    isGettingExploreData = false;
    notifyListeners();
  }

  Future<void> updateScrapUsefulLinks() async {
    if (_usefulLinks.isNotEmpty) {
      _usefulLinks.clear();
    }
    isGettingUsefulLinksData = true;
    _usefulLinks.addAll(await Scrap.scrapUsefullinks());
    isGettingUsefulLinksData = false;
    notifyListeners();
  }

  List<Map<String, dynamic>> getMaterialsBySemesterAndBranch(
      String semester, String type,
      {String? branch}) {
    if (branch == null || branch == '') {
      return _materials
          .where((element) =>
              getContains(element["mtsem"], semester) &&
              getContains(element["mttype"], type) &&
              getContains(element["approve"], 'true'))
          .toList();
    } else {
      return _materials
          .where((element) =>
              getContains(element["mtsem"], semester) &&
              getContains(element["mttype"], type) &&
              element["branch"] == branch &&
              getContains(element["approve"], 'true'))
          .toList();
    }
  }

  List<Map<String, dynamic>> getMaterialsByUserid(String uid) {
    return _materials
        .where((element) => element["uploaded_by_user_uid"] == uid)
        .toList();
  }

  List<Map<String, dynamic>> getUnapproveMaterials() {
    return _materials
        .where((element) => getContains(element["approve"], 'false'))
        .toList();
  }

  List<Map<String, dynamic>> getMaterialsByQuary(String quary) {
    return _materials
        .where((element) =>
            getContains(element["mtname"], quary) ||
            getContains(element["desc"], quary) ||
            getContains(element["mtsem"], quary) ||
            getContains(element["mtsub"], quary) ||
            getContains(element["mttype"], quary) ||
            getContains(element["branch"], quary) &&
                getContains(element["approve"], 'true'))
        .toList();
  }
}

bool getContains(String a, String q) {
  return a.toString().toLowerCase().contains(q.toString().toLowerCase());
}
