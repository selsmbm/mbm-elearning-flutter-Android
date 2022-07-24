import 'package:mbm_elearning/Data/model/mbm_story_model.dart';
import 'package:mbm_elearning/Presentation/Constants/apis.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:developer';

class GetMBMStory{
   static Future<List<MBMStoryModel>> getFeedData() async {
    List<MBMStoryModel> stories = [];
    try {
      http.Response response = await http
          .get(Uri.parse(mbmStoryApi));
      if (response.statusCode == 200) {
        for (Map<String, dynamic> story in json.decode(response.body)) {
          stories.add(MBMStoryModel.fromJson(story));
        }
      }
    } catch (e) {
      log(e.toString());
    }
    return stories;
  }
}