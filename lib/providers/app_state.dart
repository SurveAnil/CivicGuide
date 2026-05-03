// ignore_for_file: public_member_api_docs
import 'package:flutter/material.dart';
import '../models/country_mode.dart';
import '../core/analytics.dart';

class AppState extends ChangeNotifier {
  CountryMode _country = CountryMode.india;
  String _language = 'English';
  String _locationCode = '';
  bool _isGuest = false;
  int _currentTabIndex = 0;
  Map<String, bool> _checklistProgress = {};

  CountryMode get country => _country;
  String get language => _language;
  String get locationCode => _locationCode;
  bool get isGuest => _isGuest;
  int get currentTabIndex => _currentTabIndex;
  Map<String, bool> get checklistProgress => _checklistProgress;
  
  void setTabIndex(int index) {
    if (_currentTabIndex != index) {
      _currentTabIndex = index;
      AnalyticsEngine.logScreenOpen('tab_$index');
      notifyListeners();
    }
  }

  void toggleChecklistItem(String id, bool completed) {
    if (_checklistProgress[id] != completed) {
      _checklistProgress[id] = completed;
      AnalyticsEngine.logChecklistAction(id, completed);
      notifyListeners();
    }
  }

  void setChecklistProgress(Map<String, bool> progress) {
    // Deep equality check for map
    bool changed = _checklistProgress.length != progress.length;
    if (!changed) {
      for (var key in progress.keys) {
        if (_checklistProgress[key] != progress[key]) {
          changed = true;
          break;
        }
      }
    }

    if (changed) {
      _checklistProgress = Map.from(progress);
      notifyListeners();
    }
  }

  CountryConfig get countryConfig =>
      _country == CountryMode.india ? CountryConfig.india : CountryConfig.us;

  void setCountry(CountryMode mode) {
    if (_country != mode) {
      _country = mode;
      _locationCode = '';
      AnalyticsEngine.logCountrySelection(mode.toString());
      notifyListeners();
    }
  }

  void setLanguage(String lang) {
    if (_language != lang) {
      _language = lang;
      AnalyticsEngine.logLanguageSelection(lang);
      notifyListeners();
    }
  }

  void setLocationCode(String code) {
    if (_locationCode != code) {
      _locationCode = code;
      notifyListeners();
    }
  }

  void setGuest(bool guest) {
    if (_isGuest != guest) {
      _isGuest = guest;
      notifyListeners();
    }
  }
}
