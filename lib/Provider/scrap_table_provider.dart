import 'dart:async';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:mbm_elearning/Data/Repository/sheet_scrap.dart';
import 'package:mbm_elearning/Data/cache/data_cache.dart';
import 'package:mbm_elearning/Data/model/admins_model.dart';
import 'package:mbm_elearning/Data/model/blog_model.dart';
import 'package:mbm_elearning/Data/model/events_model.dart';
import 'package:mbm_elearning/Data/model/explore_model.dart';
import 'package:mbm_elearning/Data/model/useful_links_model.dart';
import 'package:mbm_elearning/Presentation/Constants/constants.dart';
import 'package:mbm_elearning/Presentation/Screens/Dashboard/Home/dashboard.dart';

const _kCacheMaterial = 'material';
const _kCacheFeeds = 'feeds';
const _kCacheExplore = 'explore';
const _kCacheEvents = 'events';

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
    // Don't re-run if already loaded (e.g. navigating back to splash)
    if (_blogPosts.isNotEmpty || _events.isNotEmpty || _explores.isNotEmpty) {
      scrapSubscriptionIsGettingData.sink.add(false);
      return;
    }

    scrapSubscriptionIsGettingData.sink.add(true);

    bool scrapMt = true;
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      scrapMt = user.photoURL!.contains(student) || user.photoURL!.contains(teacher);
    }

    // --- Load from cache first (no spinners) ---
    bool hasCachedData = false;
    try {
      final cachedMaterial = scrapMt ? await DataCache.load(_kCacheMaterial) : null;
      final cachedFeeds    = await DataCache.load(_kCacheFeeds);
      final cachedExplore  = await DataCache.load(_kCacheExplore);
      final cachedEvents   = await DataCache.load(_kCacheEvents);

      hasCachedData = (cachedFeeds?.isNotEmpty ?? false) ||
          (cachedExplore?.isNotEmpty ?? false) ||
          (cachedEvents?.isNotEmpty ?? false);

      if (hasCachedData) {
        if (scrapMt && cachedMaterial != null) _materials.addAll(cachedMaterial);
        if (cachedFeeds != null)   _blogPosts.addAll(cachedFeeds.map(BlogModel.fromJson));
        if (cachedExplore != null) _explores.addAll(cachedExplore.map(ExploreModel.fromJson));
        if (cachedEvents != null)  _events.addAll(cachedEvents.map(EventsModel.fromJson));

        isGettingData = false;
        scrapSubscriptionIsGettingData.sink.add(false);
        notifyListeners();

        // Refresh in background without clearing existing data
        _refreshAllInBackground(scrapMt: scrapMt);
        return;
      }
    } catch (_) {
      // Cache failed — fall through to network fetch with loading
    }

    // --- No cache: show loading, fetch fresh ---
    isGettingData = true;
    isGettingMaterialData = scrapMt;
    isGettingBlogPostsData = true;
    isGettingExploreData = true;
    isGettingEventsData = true;
    notifyListeners();

    await _fetchAndPopulateAll(scrapMt: scrapMt);

    isGettingData = false;
    isGettingMaterialData = false;
    isGettingBlogPostsData = false;
    isGettingExploreData = false;
    isGettingEventsData = false;
    scrapSubscriptionIsGettingData.sink.add(false);
    notifyListeners();
  }

  Future<void> _fetchAndPopulateAll({required bool scrapMt}) async {
    try {
      final data = await Scrap.scrapAllData(scrapMt: scrapMt);

      // Only clear + replace AFTER data is successfully fetched
      _materials.clear();
      _blogPosts.clear();
      _explores.clear();
      _events.clear();
      _usefulLinks.clear();
      _admins.clear();

      if (scrapMt) {
        final mt = data[0] as Set<Map<String, dynamic>>;
        _materials.addAll(mt);
        _trySaveCache(_kCacheMaterial, mt.toList());
      }
      final feeds = data[1] as Set<BlogModel>;
      _blogPosts.addAll(feeds);
      _trySaveCache(_kCacheFeeds, feeds.map((e) => e.toJson()).toList());

      final explores = data[2] as Set<ExploreModel>;
      _explores.addAll(explores);
      _trySaveCache(_kCacheExplore, explores.map((e) => e.toJson()).toList());

      final events = data[3] as Set<EventsModel>;
      _events.addAll(events);
      _trySaveCache(_kCacheEvents, events.map((e) => e.toJson()).toList());

      _usefulLinks.addAll(data[4] as Set<UsefulLinksModel>);
      _admins.addAll(data[5] as Set<AdminsModel>);
    } catch (_) {
      // Network failed — keep whatever data is currently in memory (cache or previous fetch)
    }
  }

  void _trySaveCache(String key, List<Map<String, dynamic>> data) {
    try {
      DataCache.save(key, data);
    } catch (_) {}
  }

  Future<void> _refreshAllInBackground({required bool scrapMt}) async {
    await _fetchAndPopulateAll(scrapMt: scrapMt);
    notifyListeners();
  }

  Future<void> updateScrapMaterial() async {
    updateGettingMaterialStatus(true);
    try {
      final data = await Scrap.scrapMaterial();
      _materials.clear();
      _materials.addAll(data);
      _trySaveCache(_kCacheMaterial, data.toList());
    } catch (_) {}
    updateGettingMaterialStatus(false);
    notifyListeners();
  }

  Future<void> updateScrapBlogPosts() async {
    await Future.delayed(const Duration(seconds: 1));
    updateGettingBlogPostsStatus(true);
    try {
      final data = await Scrap.scrapBlogPosts();
      _blogPosts.clear();
      _blogPosts.addAll(data);
      _trySaveCache(_kCacheFeeds, data.map((e) => e.toJson()).toList());
    } catch (_) {}
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
    updateGettingEventsStatus(true);
    try {
      final data = await Scrap.scrapEvents();
      _events.clear();
      _events.addAll(data);
      _trySaveCache(_kCacheEvents, data.map((e) => e.toJson()).toList());
    } catch (_) {}
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
    updateGettingExploreStatus(true);
    try {
      final data = await Scrap.scrapExplores();
      _explores.clear();
      _explores.addAll(data);
      _trySaveCache(_kCacheExplore, data.map((e) => e.toJson()).toList());
    } catch (_) {}
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
              element["mttype"].toString().toLowerCase() == type.toLowerCase() &&
              getContains(element["approve"], 'true'))
          .toSet();
    } else {
      return _materials
          .where((element) =>
              getContains(element["mtsem"], semester) &&
              element["mttype"].toString().toLowerCase() == type.toLowerCase() &&
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
