import 'dart:io';

class AdConfig {
  const AdConfig._();

  // Keep production full-screen ads OFF until frequency and natural transition
  // rules have been tested. This starter only enables an adaptive banner.
  static const bool enableBannerAds = true;
  static const bool enableInterstitialAds = false;
  static const bool enableAppOpenAds = false;
  static const bool enableRewardedAds = false;

  // Official Google demo IDs for development only.
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/9214589741';
    }
    if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/2435281174';
    }
    throw UnsupportedError('Toolnova ads support Android and iOS only.');
  }

  static const String privacyPolicyUrl =
      'https://toolnova.tools/privacy-policy.html';
  static const String termsUrl = 'https://toolnova.tools/terms.html';
}
