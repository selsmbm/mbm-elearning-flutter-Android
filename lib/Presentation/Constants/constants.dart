import 'package:flutter/material.dart';

const String getMaterialApi =
    "https://script.google.com/macros/s/AKfycbzq2WZOV3jG9ifOpdPJR713DhLd99PhA1Cea9o7HbGCmMi4txQEoN5KpYUzXJiZU-Y/exec";
const String getMaterialTable =
    "https://docs.google.com/spreadsheets/d/e/2PACX-1vTGOH3yf_in_iZeit55eYBfwr2TKUQdBNj_PZCISFq6LqEFwXjbEwEYzNFsVX5YAK9SjoJwB5UCRsJs/pubhtml";
const String addMaterialApi =
    "https://script.google.com/macros/s/AKfycbzsre6Iu4Wu2r9yqE-xuCzVlFl0knMw7lMPx73CEFM5MwZbkCWIU0bA82WhQxn9BIfMaQ/exec";
const String updateMaterialApi =
    "https://script.google.com/macros/s/AKfycbxYaxsj37TceUnPzOzG4IjF37487DfExQgx4mdR59UwiEN3YedTZJISPNb840OZiqiYlA/exec";
const String deleteMaterialApi =
    "https://script.google.com/macros/s/AKfycbxlNiBQOGReRMX2AIUpB_0QQxHKEjPYfPPMrumXdsVxwtkTdG7wTRd5z1-G6jgUHtT4/exec";
const String getBlogTable =
    "https://docs.google.com/spreadsheets/d/e/2PACX-1vRkeaR_JfcrXsMLGndnFKscZdBuz5OcLsPVxpiFjIMwiLRLUbtd4BVbUwiznM3UBT2WPetmzJiqjort/pubhtml";
const String getExploreTable =
    "https://docs.google.com/spreadsheets/d/e/2PACX-1vRGkXFR5XPh0OZZ2S59V4m046O-DqxHCbQEcXsq5jEmR6HCR2dn5LuY9wiyZIqKLFTwcZaiAPsrWzFt/pubhtml";
const String getEventsTable =
    "https://docs.google.com/spreadsheets/d/e/2PACX-1vRG3L745bIvLQy70gC3hkLf8gVWklhUBrAM9lQUx-Eeu3QFBg7HdlFJKf7pKFKvsojwL5jrtJ6BqoCL/pubhtml";
const String getUsefulLinksTable =
    "https://docs.google.com/spreadsheets/d/e/2PACX-1vR63HgTfZci0afiD0vM2HLI7PQaihT2wiaJoFNZ-ShB-JfgGUSAxh1igrMmkidahZnPjdx8yO3wEwU0/pubhtml";

const String driveImageShowUrl = "https://drive.google.com/uc?export=view&id=";
const String defaultDriveImageShowUrl = "13iSBQONd0uYpSRbGuITbaWVXxI_xm5JN";

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
