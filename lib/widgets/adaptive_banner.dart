import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../config/ad_config.dart';
import '../services/consent_service.dart';

class AdaptiveBanner extends StatefulWidget {
  const AdaptiveBanner({
    required this.consentService,
    super.key,
  });

  final ConsentService consentService;

  @override
  State<AdaptiveBanner> createState() => _AdaptiveBannerState();
}

class _AdaptiveBannerState extends State<AdaptiveBanner> {
  BannerAd? _bannerAd;
  bool _attempted = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_attempted && AdConfig.enableBannerAds) {
      _attempted = true;
      _load();
    }
  }

  Future<void> _load() async {
    if (!await widget.consentService.canRequestAds() || !mounted) {
      return;
    }

    final width = MediaQuery.sizeOf(context).width.truncate();
    final size = await AdSize.getLargeAnchoredAdaptiveBannerAdSize(width);
    if (size == null || !mounted) {
      return;
    }

    final ad = BannerAd(
      adUnitId: AdConfig.bannerAdUnitId,
      request: const AdRequest(),
      size: size,
      listener: BannerAdListener(
        onAdLoaded: (loadedAd) {
          if (!mounted) {
            loadedAd.dispose();
            return;
          }
          setState(() => _bannerAd = loadedAd as BannerAd);
        },
        onAdFailedToLoad: (failedAd, error) {
          failedAd.dispose();
          debugPrint('Banner failed to load: $error');
        },
      ),
    );

    await ad.load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ad = _bannerAd;
    if (ad == null) {
      return const SizedBox.shrink();
    }

    return Semantics(
      label: 'Advertisement',
      container: true,
      child: ColoredBox(
        color: Theme.of(context).colorScheme.surface,
        child: SafeArea(
          top: false,
          child: Center(
            child: SizedBox(
              width: ad.size.width.toDouble(),
              height: ad.size.height.toDouble(),
              child: AdWidget(ad: ad),
            ),
          ),
        ),
      ),
    );
  }
}
