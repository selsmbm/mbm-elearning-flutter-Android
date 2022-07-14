import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';

FirebaseAnalytics analytics = FirebaseAnalytics.instance;
FirebaseAnalyticsObserver observer =
    FirebaseAnalyticsObserver(analytics: analytics);

Future<void> setCurrentScreenInGoogleAnalytics(String screenName) async {
  await analytics.setCurrentScreen(
    screenName: screenName,
    screenClassOverride: '$screenName class',
  );
}

Future<void> setUserIdInGoogleAnalytics(
    String userId, String userName, String value) async {
  await analytics.setUserId(id: userId);
  await analytics.setUserProperty(name: userName, value: value);
}
