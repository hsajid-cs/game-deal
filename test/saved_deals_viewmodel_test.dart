import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:game_deal/models/deal.dart';
import 'package:game_deal/services/storage_service.dart';
import 'package:game_deal/viewmodels/saved_deals_viewmodel.dart';

import 'saved_deals_viewmodel_test.mocks.dart';

@GenerateMocks([StorageService])
void main() {
  late MockStorageService mockStorageService;
  late SavedDealsViewModel viewModel;

  setUp(() {
    mockStorageService = MockStorageService();
    viewModel = SavedDealsViewModel(storageService: mockStorageService);
  });

  group('SavedDealsViewModel', () {
    test('loadSavedDeals should fetch deals from storage service', () {
      // Arrange
      final deals = [
        Deal(
          id: '1',
          title: 'Saved Game',
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
      ];
      when(mockStorageService.getSavedDeals()).thenReturn(deals);

      // Act
      viewModel.loadSavedDeals();

      // Assert
      expect(viewModel.savedDeals, deals);
      verify(mockStorageService.getSavedDeals()).called(1);
    });

    test('toggleSave should call storage service to save deal if not saved', () async {
      // Arrange
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
      when(mockStorageService.isDealSaved('1')).thenReturn(false);

      // Act
      await viewModel.toggleSave(deal);

      // Assert
      verify(mockStorageService.saveDeal(deal)).called(1);
      verify(mockStorageService.getSavedDeals()).called(1);
    });

    test('toggleSave should call storage service to remove deal if already saved', () async {
      // Arrange
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
      when(mockStorageService.isDealSaved('1')).thenReturn(true);

      // Act
      await viewModel.toggleSave(deal);

      // Assert
      verify(mockStorageService.removeDeal('1')).called(1);
      verify(mockStorageService.getSavedDeals()).called(1);
    });
  });
}