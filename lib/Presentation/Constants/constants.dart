import 'package:flutter/material.dart';

const String getMaterialApi =
    "https://script.google.com/macros/s/AKfycbzq2WZOV3jG9ifOpdPJR713DhLd99PhA1Cea9o7HbGCmMi4txQEoN5KpYUzXJiZU-Y/exec";
const String addMaterialApi =
    "https://script.google.com/macros/s/AKfycbzsre6Iu4Wu2r9yqE-xuCzVlFl0knMw7lMPx73CEFM5MwZbkCWIU0bA82WhQxn9BIfMaQ/exec";
const String updateMaterialApi =
    "https://script.google.com/macros/s/AKfycbxYaxsj37TceUnPzOzG4IjF37487DfExQgx4mdR59UwiEN3YedTZJISPNb840OZiqiYlA/exec";
const String deleteMaterialApi =
    "https://script.google.com/macros/s/AKfycbxlNiBQOGReRMX2AIUpB_0QQxHKEjPYfPPMrumXdsVxwtkTdG7wTRd5z1-G6jgUHtT4/exec";

const List<String> mttypes = [
  'notes',
  'paper',
  'book',
  'file',
  'video',
];

List branches = "CE,CH,MI,EE,CSE,ECE,EEE,ECC,ME,P&I,BCT,IT,PE,AE,AI".split(',');
List semsData =
    "civilsem,mechanicalsem,3sem,4sem,5sem,6sem,7sem,8sem,M1,M2,M3,M4"
        .split(',');
List allBranchSemsData = "civilsem,mechanicalsem,M1,M2,M3,M4".split(',');

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

enum AddMaterialPagePurpose { add, update }
