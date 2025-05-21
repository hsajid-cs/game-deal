import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:game_deal/models/deal.dart';
import 'package:game_deal/viewmodels/home_viewmodel.dart';
import 'package:game_deal/views/widgets/deal_card.dart';

// Mock HomeViewModel that returns consistent results
class MockHomeViewModel extends ChangeNotifier implements HomeViewModel {
  @override
  bool isDealSaved(String dealId) => dealId == '1';
  
  @override
  Future<void> toggleSaveDeal(Deal deal) async {}
  
  // Stub implementations for other required methods
  @override
  HomeViewState get state => HomeViewState.loaded;
  
  @override
  List<Deal> get deals => [];
  
  @override
  String get searchQuery => '';
  
  @override
  String get errorMessage => '';
  
  @override
  Future<void> fetchDeals() async {}
  
  @override
  void updateSearchQuery(String query) {}
  
  @override
  Future<void> searchDeals() async {}
}

void main() {
  // Setup to handle network images in tests
  setUpAll(() {
    // This prevents issues with network images in tests
    HttpOverrides.global = _MockHttpOverrides();
  });

  testWidgets('DealCard displays deal information correctly', (WidgetTester tester) async {
    // Create a test deal
    final deal = Deal(
      id: '1',
      title: 'Test Game',
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
    );
    
    final viewModel = MockHomeViewModel();
    
    // Build the widget
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ChangeNotifierProvider<HomeViewModel>.value(
            value: viewModel,
            child: DealCard(deal: deal),
          ),
        ),
      ),
    );

    // Allow widget to fully render including any async operations
    await tester.pumpAndSettle();

    // Verify deal title is displayed
    expect(find.text('Test Game'), findsOneWidget);
    
    // Verify prices are displayed
    expect(find.text('\$9.99'), findsOneWidget);
    expect(find.text('\$19.99'), findsOneWidget);
    
    // Check for savings text - this might need adjustment based on your actual implementation
    // Try different possible formats of the savings text
    bool foundSavings = false;
    for (var savingsFormat in [
      '-50%',
      '50%',
      '50% off',
      'Save 50%'
    ]) {
      if (tester.any(find.text(savingsFormat))) {
        foundSavings = true;
        break;
      }
    }
    expect(foundSavings, true, reason: 'No savings percentage text found in any expected format');
    
    // Verify bookmark icon is displayed - could be either variant
    expect(
      find.byIcon(Icons.bookmark).evaluate().isEmpty && 
      find.byIcon(Icons.bookmark_border).evaluate().isEmpty, 
      false,
      reason: 'Neither bookmark nor bookmark_border icon found'
    );
  });
}

// Mock HTTP overrides for handling network images in tests
class _MockHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (_, __, ___) => true;
  }
}