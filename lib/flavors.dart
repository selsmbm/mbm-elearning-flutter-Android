enum Flavor {
  MPROD,
  MDEV,
}

class Flavors {
  static Flavor? appFlavor;

  static String get title {
    switch (appFlavor) {
      case Flavor.MPROD:
        return 'MBM Elearning';
      case Flavor.MDEV:
        return 'MBM Elearning Dev';
      default:
        return 'title';
    }
  }

  static String get package {
    switch (appFlavor) {
      case Flavor.MPROD:
        return 'com.mbm.elereaning.mbmecj';
      case Flavor.MDEV:
        return 'com.mbm.elereaning.mbmecj.dev';
      default:
        return 'com.mbm.elereaning.mbmecj';
    }
  }
}
