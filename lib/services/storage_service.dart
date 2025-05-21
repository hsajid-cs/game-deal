import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/deal.dart';

class StorageService {
  static const String dealsBoxName = 'saved_deals';
  
  Future<void> initHive() async {
    await Hive.initFlutter();
    Hive.registerAdapter(DealAdapter());
    await Hive.openBox<Deal>(dealsBoxName);
  }
  
  Future<void> saveDeal(Deal deal) async {
    final box = Hive.box<Deal>(dealsBoxName);
    await box.put(deal.id, deal);
  }
  
  Future<void> removeDeal(String dealId) async {
    final box = Hive.box<Deal>(dealsBoxName);
    await box.delete(dealId);
  }
  
  List<Deal> getSavedDeals() {
    final box = Hive.box<Deal>(dealsBoxName);
    return box.values.toList();
  }
  
  bool isDealSaved(String dealId) {
    final box = Hive.box<Deal>(dealsBoxName);
    return box.containsKey(dealId);
  }
}