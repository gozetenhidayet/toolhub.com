import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class ConsentService {
  bool _requested = false;

  Future<bool> gatherConsent() async {
    if (_requested) {
      return ConsentInformation.instance.canRequestAds();
    }
    _requested = true;

    final completer = Completer<bool>();
    final params = ConsentRequestParameters();

    ConsentInformation.instance.requestConsentInfoUpdate(
      params,
      () async {
        ConsentForm.loadAndShowConsentFormIfRequired((formError) async {
          if (formError != null) {
            debugPrint(
              'Consent form error ${formError.errorCode}: '
              '${formError.message}',
            );
          }
          completer.complete(
            await ConsentInformation.instance.canRequestAds(),
          );
        });
      },
      (formError) async {
        debugPrint(
          'Consent update error ${formError.errorCode}: '
          '${formError.message}',
        );
        completer.complete(
          await ConsentInformation.instance.canRequestAds(),
        );
      },
    );

    return completer.future;
  }

  Future<bool> canRequestAds() async {
    await gatherConsent();
    return ConsentInformation.instance.canRequestAds();
  }

  Future<bool> isPrivacyOptionsRequired() async {
    await gatherConsent();
    return ConsentInformation.instance
            .getPrivacyOptionsRequirementStatus() ==
        PrivacyOptionsRequirementStatus.required;
  }

  void showPrivacyOptions() {
    ConsentForm.showPrivacyOptionsForm((formError) {
      if (formError != null) {
        debugPrint(
          'Privacy options error ${formError.errorCode}: '
          '${formError.message}',
        );
      }
    });
  }
}
