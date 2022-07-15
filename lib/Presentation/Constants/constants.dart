import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const String getMaterialApi =
    "https://script.google.com/macros/s/AKfycbzq2WZOV3jG9ifOpdPJR713DhLd99PhA1Cea9o7HbGCmMi4txQEoN5KpYUzXJiZU-Y/exec";
const String addMaterialApi =
    "https://script.google.com/macros/s/AKfycbwzl-Od3VwUFZm6KW1xiW9PbWZPbXG6a-__v9ovjeaIahG4NSlWMyltV0_zQczpRpX6sQ/exec";
const String updateMaterialApi =
    "https://script.google.com/macros/s/AKfycbxr3O95T32qb3YBVWxuDXGJ4pp0wwN3WJ5tFZ5Yw3dJ3hUrjJxtbqFRNUjjxGnmFb0oeA/exec";
const String deleteMaterialApi =
    "https://script.google.com/macros/s/AKfycbxtKxqcTnJMwho0r2tvr3EOqFhIxlDDdbSSMH8XhYNPaXvM7Y0lvY3-fBEiND2TnsIL/exec";

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
