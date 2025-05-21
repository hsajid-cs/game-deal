import 'package:flutter/material.dart';
import '../models/deal.dart';
import '../services/storage_service.dart';

class SavedDealsViewModel extends ChangeNotifier {
  final StorageService _storageService;
  
  List<Deal> _savedDeals = [];
  List<Deal> get savedDeals => _savedDeals;
  
  SavedDealsViewModel({required StorageService storageService}) 
      : _storageService = storageService;
  
  void loadSavedDeals() {
    _savedDeals = _storageService.getSavedDeals();
    notifyListeners();
  }
  
  Future<void> removeDeal(String dealId) async {
    await _storageService.removeDeal(dealId);
    loadSavedDeals();
  }
  
  bool isSaved(String dealId) {
    return _storageService.isDealSaved(dealId);
  }
  
  Future<void> toggleSave(Deal deal) async {
    if (isSaved(deal.id)) {
      await _storageService.removeDeal(deal.id);
    } else {
      await _storageService.saveDeal(deal);
    }
    loadSavedDeals();
  }
}