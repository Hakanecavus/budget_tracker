import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdProvider with ChangeNotifier {
  InterstitialAd? _interstitialAd;
  int _transactionActionCount = 0;
  bool _isAdLoaded = false;

  int get transactionActionCount => _transactionActionCount;

  AdProvider() {
    _loadInterstitialAd();
  }

  // Test Ad Unit IDs
  String get interstitialAdUnitId {
    // if (Platform.isAndroid) {
    //   return 'ca-app-pub-3940256099942544/1033173712';
    // } else if (Platform.isIOS) {
    //   return 'ca-app-pub-3940256099942544/4411468910';
    // } else {
    //   throw UnsupportedError('Unsupported platform');
    // }
    return Platform.isAndroid
        ? 'ca-app-pub-4328553347790791/1953004551'
        : 'ca-app-pub-4328553347790791/4780130830';
  }

  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          _interstitialAd = ad;
          _isAdLoaded = true;
          debugPrint('InterstitialAd loaded.');
        },
        onAdFailedToLoad: (LoadAdError error) {
          debugPrint('InterstitialAd failed to load: $error');
          _interstitialAd = null;
          _isAdLoaded = false;
        },
      ),
    );
  }

  void incrementTransactionActionCount() {
    _transactionActionCount++;
    debugPrint('Transaction action count: $_transactionActionCount');
    if (_transactionActionCount >= 2) {
      if (_isAdLoaded && _interstitialAd != null) {
        _showInterstitialAd();
      } else {
        debugPrint('Ad not loaded yet, resetting count anyway or waiting?');
        // If ad is not loaded, we might want to reset count anyway or keep it at 2 to try next time.
        // User said "after adding or updating 2 transactions".
        // Let's reset and try to load again.
        _transactionActionCount = 0;
        _loadInterstitialAd();
      }
    }
    notifyListeners();
  }

  void _showInterstitialAd() {
    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        debugPrint('Ad dismissed.');
        ad.dispose();
        _transactionActionCount = 0;
        _isAdLoaded = false;
        _loadInterstitialAd();
        notifyListeners();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        debugPrint('Ad failed to show: $error');
        ad.dispose();
        _transactionActionCount = 0;
        _isAdLoaded = false;
        _loadInterstitialAd();
        notifyListeners();
      },
    );
    _interstitialAd!.show();
    _interstitialAd = null;
  }

  @override
  void dispose() {
    _interstitialAd?.dispose();
    super.dispose();
  }
}
