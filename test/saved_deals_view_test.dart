import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:game_deal/models/deal.dart';
import 'package:game_deal/viewmodels/saved_deals_viewmodel.dart';
import 'package:game_deal/views/saved_deals_view.dart';

class MockSavedDealsViewModel extends Mock implements SavedDealsViewModel {
  List<Deal> _savedDeals = [];
  
  @override
  List<Deal> get savedDeals => _savedDeals;
  
  void setSavedDeals(List<Deal> deals) {
    _savedDeals = deals;
    notifyListeners();
  }
  
  @override
  void loadSavedDeals() {}
  
  @override
  Future<void> removeDeal(String dealId) async {
    _savedDeals.removeWhere((deal) => deal.id == dealId);
    notifyListeners();
  }
}

void main() {
  testWidgets('SavedDealsView displays empty state when no saved deals', (WidgetTester tester) async {
    final mockViewModel = MockSavedDealsViewModel();
    mockViewModel.setSavedDeals([]);
    
    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider<SavedDealsViewModel>.value(
          value: mockViewModel,
          child: const SavedDealsView(),
        ),
      ),
    );

    // Verify empty state is displayed
    expect(find.text('No saved deals'), findsOneWidget);
    expect(find.text('Browse Deals'), findsOneWidget);
  });

  testWidgets('SavedDealsView displays list of saved deals', (WidgetTester tester) async {
    final mockViewModel = MockSavedDealsViewModel();
    mockViewModel.setSavedDeals([
      Deal(
        id: '1',
        title: 'Saved Game 1',
        dealID: '1',
        storeID: '1',
        gameID: '1',
        salePrice: '9.99',
        normalPrice: '19.99',
        savings: '50',
        steamRatingText: 'Very Positive',
        steamRatingPercent: '85',
        metacriticScore: '75',
        thumbnailUrl: 'http://example.com/thumb.jpg',
      ),
      Deal(
        id: '2',
        title: 'Saved Game 2',
        dealID: '2',
        storeID: '1',
        gameID: '2',
        salePrice: '14.99',
        normalPrice: '29.99',
        savings: '50',
        steamRatingText: 'Positive',
        steamRatingPercent: '80',
        metacriticScore: '70',
        thumbnailUrl: 'http://example.com/thumb2.jpg',
      ),
    ]);
    
    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider<SavedDealsViewModel>.value(
          value: mockViewModel,
          child: const SavedDealsView(),
        ),
      ),
    );

    // Verify saved deals are displayed
    expect(find.text('Saved Game 1'), findsOneWidget);
    expect(find.text('Saved Game 2'), findsOneWidget);
  });
}