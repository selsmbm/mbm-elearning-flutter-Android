import 'package:flutter/material.dart';
import 'package:mbm_elearning/Data/googleAnalytics.dart';
import 'package:mbm_elearning/Presentation/Constants/Colors.dart';
import 'package:mbm_elearning/Presentation/Constants/constants.dart';
import 'package:mbm_elearning/Presentation/Screens/Dashboard/Home/dashboard.dart';
import 'package:url_launcher/url_launcher.dart';

class BookmarkPage extends StatefulWidget {
  const BookmarkPage({Key? key}) : super(key: key);

  @override
  _BookmarkPageState createState() => _BookmarkPageState();
}

class _BookmarkPageState extends State<BookmarkPage> {
  @override
  void initState() {
    super.initState();
    setCurrentScreenInGoogleAnalytics('material Page');
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Bookmark',
        ),
      ),
      body: FutureBuilder(
        future: localDbConnect.getBookMarkMt(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.isNotEmpty) {
              List material = snapshot.data ?? [];
              return SafeArea(
                child: Center(
                  child: ListView.builder(
                    itemCount: material.length,
                    physics: const ClampingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return ListTile(
                        onTap: () async {
                          launch(material[index]['url']);
                        },
                        leading: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: rPrimaryLiteColor,
                          ),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
                            child: Icon(
                              Icons.bookmark,
                              color: rPrimaryColor,
                            ),
                          ),
                        ),
                        title: Text(
                          material[index]['title'],
                        ),
                        trailing: IconButton(
                          onPressed: () {
                            setState(() {});
                            localDbConnect.deleteMt(material[index]['id']);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Material removed successfully'),
                              ),
                            );
                          },
                          icon: const Icon(
                            Icons.delete_outline,
                            size: 25,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Subject: ${material[index]['subject'].toUpperCase()}',
                            ),
                            Text(
                              'Sem: ${material[index]['sem'].toUpperCase()}',
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              );
            } else {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      'No data available',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
