import 'package:flutter/material.dart';
import '../models/deal.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';

enum HomeViewState { initial, loading, loaded, error }

class HomeViewModel extends ChangeNotifier {
  final ApiService _apiService;
  final StorageService _storageService;
  
  List<Deal> _deals = [];
  List<Deal> get deals => _deals;
  
  String _searchQuery = '';
  String get searchQuery => _searchQuery;
  
  HomeViewState _state = HomeViewState.initial;
  HomeViewState get state => _state;
  
  String _errorMessage = '';
  String get errorMessage => _errorMessage;
  
  HomeViewModel({
    required ApiService apiService,
    required StorageService storageService,
  })  : _apiService = apiService,
        _storageService = storageService;
  
  Future<void> fetchDeals() async {
    try {
      _state = HomeViewState.loading;
      notifyListeners();
      
      _deals = await _apiService.getDeals(title: _searchQuery.isEmpty ? null : _searchQuery);
      
      _state = HomeViewState.loaded;
    } catch (e) {
      _state = HomeViewState.error;
      _errorMessage = e.toString();
    } finally {
      notifyListeners();
    }
  }
  
  void updateSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }
  
  Future<void> searchDeals() async {
    await fetchDeals();
  }
  
  bool isDealSaved(String dealId) {
    return _storageService.isDealSaved(dealId);
  }
  
  Future<void> toggleSaveDeal(Deal deal) async {
    if (isDealSaved(deal.id)) {
      await _storageService.removeDeal(deal.id);
    } else {
      await _storageService.saveDeal(deal);
    }
    notifyListeners();
  }
}