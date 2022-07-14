import 'dart:convert';

import 'package:http/http.dart' as http;

getCusAdsDataRequest() async {
  List outData = [];
  try {
    http.Response response = await http.get(Uri.parse(
        'https://script.google.com/macros/s/AKfycby9JlmwmNy_yqid-gpjON2TZGRAyxfaAG5ptze2ma6O2GFXnhnsH8dvKVrm0Rr0LBkWpQ/exec'));
    if (response.statusCode == 200) {
      for (var d in json.decode(response.body)) {
        if (d['image'] != 'imageUrl') {
          outData.add(d);
        }
      }
      return outData;
    }
  } on Exception catch (e) {
    print(e);
    print('network error');
  }
}
