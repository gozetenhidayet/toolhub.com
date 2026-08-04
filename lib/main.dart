import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'app.dart';
import 'services/consent_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // UMP consent is checked before ad requests. Mobile Ads initializes early,
  // but ad widgets still wait until ConsentService.canRequestAds() is true.
  await MobileAds.instance.initialize();

  runApp(
    ToolnovaApp(
      consentService: ConsentService(),
    ),
  );
}
