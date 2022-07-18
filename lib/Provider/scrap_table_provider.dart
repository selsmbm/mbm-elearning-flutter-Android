import 'package:flutter/widgets.dart';
import 'package:mbm_elearning/Data/Repository/sheet_scrap.dart';

class ScrapTableProvider with ChangeNotifier {
  final List<Map<String, dynamic>> _materials = [];
  List<Map<String, dynamic>> get materials => _materials;
  bool isGettingData = false;

  bool checkIsNotEmpty() {
    if (_materials.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> scrapMaterial() async {
    if (_materials.isNotEmpty) {
      _materials.clear();
    }
    isGettingData = true;
    _materials.addAll(await Scrap.scrapMaterial());
    isGettingData = false;
    notifyListeners();
  }

  List<Map<String, dynamic>> getMaterialsBySemesterAndBranch(
      String semester, String type,
      {String? branch}) {
    if (branch == null) {
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
