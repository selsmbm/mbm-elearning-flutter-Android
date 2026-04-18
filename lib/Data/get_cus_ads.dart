import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mbm_elearning/Data/network/api_debug_logger.dart';

getCusAdsDataRequest() async {
  List outData = [];
  try {
    final uri = Uri.parse(
        'https://script.google.com/macros/s/AKfycby9JlmwmNy_yqid-gpjON2TZGRAyxfaAG5ptze2ma6O2GFXnhnsH8dvKVrm0Rr0LBkWpQ/exec');
    ApiDebugLogger.logRequest(method: 'GET', uri: uri);
    http.Response response = await http.get(uri);
    ApiDebugLogger.logResponse(
      method: 'GET',
      uri: uri,
      statusCode: response.statusCode,
      reasonPhrase: response.reasonPhrase,
      headers: response.headers,
      body: response.body,
    );
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
