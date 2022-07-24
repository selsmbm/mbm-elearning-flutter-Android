import 'package:flutter/material.dart';
import 'package:mbm_elearning/Data/Repository/get_mbm_story.dart';
import 'package:mbm_elearning/Data/model/mbm_story_model.dart';
import 'package:mbm_elearning/Presentation/Constants/Colors.dart';
import 'package:url_launcher/url_launcher.dart';

class MBMStories extends StatefulWidget {
  const MBMStories({Key? key}) : super(key: key);
  @override
  _MBMStoriesState createState() => _MBMStoriesState();
}

class _MBMStoriesState extends State<MBMStories> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('MBM Stories'),
      ),
      body: FutureBuilder<List<MBMStoryModel>>(
        future: GetMBMStory.getFeedData(),
        builder: ((context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            List<MBMStoryModel> stories = snapshot.data;
            return ListView.builder(
              itemCount: stories.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () {
                    launch(stories[index].link!);
                  },
                  leading: const CircleAvatar(
                    radius: 23,
                    backgroundColor: rPrimaryLiteColor,
                    child: Icon(
                      Icons.feed_outlined,
                      color: rPrimaryColor,
                    ),
                  ),
                  title: Text(stories[index].title!),
                  subtitle: Text(stories[index].date!.split("T").join(" ")),
                );
              },
            );
          }
        }),
      ),
    );
  }
}
