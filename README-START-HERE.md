# Toolnova Mobile — Flutter Starter

This starter contains a professional Android + iOS shell for Toolnova.

## Included now

- Native mobile home screen
- All 35 tools organized under 6 categories
- Native search
- Favorites stored on-device
- Recent-tool history
- Smooth fade + slide transitions
- Haptic feedback
- Light and dark mode
- Safe-area support
- Mobile-friendly navigation
- Restricted Toolnova WebView
- Network error and reload state
- Google UMP consent flow
- Adaptive AdMob banner using official Google demo IDs
- Privacy-options entry point when required
- Full-screen ads disabled by default
- Android and iOS AdMob setup snippets
- app-ads.txt template
- Play Store / App Store release checklists

## Important architecture note

This package is the first production foundation. The mobile shell is native,
but the current 35 tool engines load from `https://toolnova.tools/` inside a
restricted WebView. Before store release, test every tool carefully and add more
native app-specific value where possible (native file picker/share, offline
calculators, native PDF/OCR workflows). A simple low-value website wrapper can
be rejected by an app store.

## Recommended project identity

- App name: Toolnova
- Android application ID: `tools.toolnova.mobile`
- iOS bundle ID: `tools.toolnova.mobile`
- Developer website: `https://toolnova.tools/`
- Privacy policy: `https://toolnova.tools/privacy-policy.html`
- Support: your public support email

## Setup on Mac

Install current Flutter, Android Studio and Xcode first.

Create the platform project:

```bash
flutter create --org tools.toolnova --platforms=android,ios toolnova_mobile
cd toolnova_mobile
```

Copy this starter's `lib/`, `pubspec.yaml`, and `analysis_options.yaml` into the
new project, replacing the generated versions.

Then run:

```bash
flutter pub get
flutter doctor
flutter run
```

## AdMob setup

1. During development, keep the included Google demo IDs.
2. Add the Android test App ID snippet from:
   `platform_snippets/AndroidManifest-meta-data.xml`
3. Add the iOS test App ID snippet from:
   `platform_snippets/Info.plist-snippet.xml`
4. Create your own Android and iOS apps in AdMob before production.
5. Replace every demo ID before store release.
6. Configure Privacy & messaging in AdMob.
7. Publish `app-ads.txt` at the developer-domain root.

## Current ad layout

- Adaptive banner: Home and Categories only.
- No ad in upload, tool-processing, results or download controls.
- Interstitial: disabled.
- App-open ad: disabled.
- Rewarded ad: disabled.

This protects user experience while the app is tested. Full-screen formats
should only be introduced at natural transition points with conservative
frequency rules.

## Smooth transitions

- Main tabs: 240 ms fade + slight horizontal movement
- Tool opening: 260 ms fade + slight slide
- Favorites: 180 ms scale animation
- Material 3 Android transitions
- Native Cupertino back transition on iOS

## Files to review first

- `lib/config/ad_config.dart`
- `lib/data/tool_catalog.dart`
- `lib/services/consent_service.dart`
- `lib/widgets/adaptive_banner.dart`
- `store_checklists/RELEASE-CHECKLIST.md`
