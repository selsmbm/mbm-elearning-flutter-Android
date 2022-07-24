import 'dart:developer';

import 'package:flutter_fcm_wrapper/exception/flutter_fcm_wrapper_invalid_data_exception.dart';
import 'package:flutter_fcm_wrapper/exception/flutter_fcm_wrapper_respond_exception.dart';
import 'package:flutter_fcm_wrapper/flutter_fcm_wrapper.dart';
import 'package:mbm_elearning/Presentation/Constants/constants.dart';

class FirebaseNotiSender {
  static Future send(
      {String? title,
      String? desc,
      required String topic,
      String? iconImageCompleteUrl}) async {
    FlutterFCMWrapper flutterFCMWrapper = const FlutterFCMWrapper(
      apiKey: firebaseFCMsenderKey,
      enableLog: false,
      enableServerRespondLog: false,
    );
    try {
      String result = await flutterFCMWrapper.sendTopicMessage(
        topicName: topic,
        title: title,
        body: desc,
        isHighPriority: true,
        collapseKey: "feed_collapse_key",
        badge: 1,
        data: {
          "image": iconImageCompleteUrl ??
              "http://mbm.ac.in/wp-content/uploads/2022/03/MBMU-Logo-150x150.png",
        },
        androidChannelID: feedNotificationChannel,
        clickAction: "FLUTTER_NOTIFICATION_CLICK",
        icon: iconImageCompleteUrl ??
            "http://mbm.ac.in/wp-content/uploads/2022/03/MBMU-Logo-150x150.png",
      );
    } on FlutterFCMWrapperInvalidDataException catch (e) {
      log(e.toString());
    } on FlutterFCMWrapperRespondException catch (e) {
      log(e.toString());
    }
  }
}
