import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';

FirebaseAnalytics analytics = FirebaseAnalytics();
FirebaseAnalyticsObserver observer =
    FirebaseAnalyticsObserver(analytics: analytics);

class AnalyticsClass {
  Future<void> setCurrentScreen(String screenName, String screenClass) async {
    await analytics.setCurrentScreen(
      screenName: screenName,
      screenClassOverride: screenClass,
    );
  }

}
