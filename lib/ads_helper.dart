import 'package:unity_ads_plugin/unity_ads.dart';

String appGameId = "4523993";

showUnityInitAds() {
  UnityAds.showVideoAd(
    placementId: 'Rewarded_Android',
    listener: (state, args) {
      if (state == UnityAdState.complete) {
        print('User watched a video. User should get a reward!');
      } else if (state == UnityAdState.skipped) {
        print('User cancel video.');
      } 
    },
  );
}
