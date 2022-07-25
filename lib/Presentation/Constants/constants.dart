import 'package:flutter/material.dart';

const String mbmEleFcmChannel = "mbm_ele_fcm_channel";

// const String driveImageShowUrl = "https://drive.google.com/uc?export=view&id=";
const String driveImageShowUrl = "https://lh3.googleusercontent.com/d/";
const String defaultDriveImageShowUrl = "14HZftHO6_LaoMOdzcE1t5RmrrpQSCGis";
const String defaultUserDriveImageShowUrl = "1VnGXzQ1HW6W5MZwSQQdJgbqL4dHc30OB";

const List<String> mttypes = [
  'notes',
  'paper',
  'book',
  'file',
  'video',
];

List<String> branches = "CE,CH,MI,EE,CSE,ECE,EEE,ECC,ME,P&I,BCT,IT,PE,AE,AI".split(',');
List<String> semsData =
    "civilsem,mechanicalsem,3sem,4sem,5sem,6sem,7sem,8sem,M1,M2,M3,M4"
        .split(',');
List<String> allBranchSemsData = "civilsem,mechanicalsem,M1,M2,M3,M4".split(',');
List<String> userTypes = "Teacher,Student,Alumni".split(',');

Map<String, IconData> typeIcon = {
  'notes': Icons.note,
  'paper': Icons.assignment,
  'book': Icons.book,
  'file': Icons.file_copy,
  'video': Icons.videocam,
};

const String gdriveUploadClientId =
    "304334437374-vmjld7k1vvc234p9loqtu57kv9a7e2qc.apps.googleusercontent.com";
const String gDriveUploadClientSecreat = "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";
const String gDriveFolder = '17RjQvK979j3RjwjtTBP5LtyEQ9Qh8Qdh';
const String firebaseFCMsenderKey =
    "AAAARtu--_4:APA91bHkPHgeB2vxNtA4T9mYzK6cRWEnl2SAZdtFt6DlXmAK2NEgZ6e6UGPMyqsNcFTUvTGj1YTftdJS8zxE9piJwaohCniPv0pXmYcluDYSIrFEKZPfgYKiQbNN8fXQujypjAGl1c-n";

enum AddMaterialPagePurpose { add, update }

const String feedNotificationChannel = 'feed_notification';
const String progressNotificationChannel = 'progress_channel';
const String groupNotificationChannelKey = 'feed_group_channel';

//sharedprefrences ids
class SP {
  static const String ismeAdmin = "ismeAdmin";
  static const String initialProfileSaved = "initialProfileSaved";
}
