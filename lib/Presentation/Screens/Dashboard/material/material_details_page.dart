import 'package:flutter/material.dart';
import 'package:mbm_elearning/Data/LocalDbConnect.dart';
import 'package:mbm_elearning/Presentation/Constants/Colors.dart';
import 'package:mbm_elearning/Presentation/Constants/constants.dart';
import 'package:mbm_elearning/Presentation/Screens/Dashboard/Home/dashboard.dart';
import 'package:url_launcher/url_launcher.dart';

class MaterialDetailsPage extends StatefulWidget {
  const MaterialDetailsPage(
      {Key? key, required this.material, required this.isMe})
      : super(key: key);
  final Map material;
  final bool isMe;

  @override
  State<MaterialDetailsPage> createState() => _MaterialDetailsPageState();
}

class _MaterialDetailsPageState extends State<MaterialDetailsPage> {
  @override
  Widget build(BuildContext context) {
    print(widget.material);
    DateTime time =
        DateTime.fromMillisecondsSinceEpoch(widget.material['time'] * 1000);
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                launch(widget.material['mturl']);
              },
              child: Text(
                widget.material['mtname'],
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: rPrimaryLiteColor,
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    child: Row(
                      children: [
                        Icon(
                          typeIcon[widget.material['mttype']],
                          color: rPrimaryColor,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          widget.material['mttype'],
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  children: [
                    // IconButton(
                    //   onPressed: () {},
                    //   icon: Icon(Icons.edit),
                    // ),
                    IconButton(
                      onPressed: () {
                        launch(widget.material['mturl']);
                      },
                      icon: Icon(Icons.open_in_browser),
                    ),
                    IconButton(
                      onPressed: () {
                        localDbConnect.addBookMarkMt(
                          BookMarkMt(
                            title: widget.material['mtname'],
                            url: widget.material['mturl'],
                            subject: widget.material['mtsub'],
                            type: widget.material['mttype'],
                            sem: widget.material['mtsem'],
                            branch: widget.material['branch'],
                          ),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Material add to bookmark',
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pushNamed(context, 'bookmark');
                                  },
                                  child: const Text(
                                    'check',
                                    style: TextStyle(color: Colors.blueAccent),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.bookmark_border_outlined,
                        size: 25,
                      ),
                    ),
                    if (widget.isMe)
                      Tooltip(
                        message: widget.material['approve']
                            ? "Material is live to everyone"
                            : "Material is pending for approval",
                        child: CircleAvatar(
                          radius: 8,
                          backgroundColor: widget.material['approve']
                              ? Colors.green
                              : Colors.red,
                        ),
                      )
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              "Subject: ${widget.material['mtsub']}",
              style: TextStyle(
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                Row(children: [
                  Icon(
                    Icons.timer,
                    size: 15,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    "${time.day}/${time.month}/${time.year} ${time.hour}:${time.minute}",
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ]),
                const SizedBox(width: 5),
                Row(children: [
                  Icon(
                    Icons.school,
                    size: 15,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    widget.material['mtsem'],
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ]),
                const SizedBox(width: 5),
                Row(children: [
                  Icon(
                    Icons.margin,
                    size: 15,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    " ${allBranchSemsData.contains(widget.material['mtsem']) ? "All" : widget.material['branch']}",
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ]),
              ],
            ),
            const SizedBox(height: 10),
            if (widget.material['desc'] != '')
              Text(
                widget.material['desc'],
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
            if (widget.material['uploaded_by_user'] != "N/A")
              ListTile(
                onTap: () {},
                leading: CircleAvatar(
                  backgroundColor: rPrimaryLiteColor,
                  child: Text(
                    widget.material['uploaded_by_user'].substring(0, 1) ?? 'U',
                    style: TextStyle(
                      fontSize: 25,
                      color: rTextColor,
                    ),
                  ),
                ),
                title: Text(
                  '${widget.material['uploaded_by_user'] ?? 'Unknown'}',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  '${widget.material['uploaded_by_user_uid'] ?? 'N/A'}',
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 11,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
