import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:game_deal/models/deal.dart';
import 'package:game_deal/services/api_service.dart';
import 'package:game_deal/services/storage_service.dart';
import 'package:game_deal/viewmodels/home_viewmodel.dart';

import 'home_viewmodel_test.mocks.dart';

@GenerateMocks([ApiService, StorageService])
void main() {
  late MockApiService mockApiService;
  late MockStorageService mockStorageService;
  late HomeViewModel viewModel;

  setUp(() {
    mockApiService = MockApiService();
    mockStorageService = MockStorageService();
    viewModel = HomeViewModel(
      apiService: mockApiService,
      storageService: mockStorageService,
    );
  });

  group('HomeViewModel', () {
    test('fetchDeals should update state correctly when successful', () async {
      // Arrange
      final deals = [
        Deal(
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
        ),
      ];
      when(mockApiService.getDeals(title: null)).thenAnswer((_) async => deals);

      // Act
      await viewModel.fetchDeals();

      // Assert
      expect(viewModel.state, HomeViewState.loaded);
      expect(viewModel.deals, deals);
    });

    test('fetchDeals should update state correctly when error occurs', () async {
      // Arrange
      when(mockApiService.getDeals(title: null)).thenThrow(Exception('Network error'));

      // Act
      await viewModel.fetchDeals();

      // Assert
      expect(viewModel.state, HomeViewState.error);
      expect(viewModel.errorMessage, contains('Exception: Network error'));
    });

    test('searchDeals should call fetchDeals with correct query', () async {
      // Arrange
      final deals = [
        Deal(
          id: '1',
          title: 'Witcher 3',
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
      viewModel.updateSearchQuery('Witcher');
      when(mockApiService.getDeals(title: 'Witcher')).thenAnswer((_) async => deals);

      // Act
      await viewModel.searchDeals();

      // Assert
      verify(mockApiService.getDeals(title: 'Witcher')).called(1);
      expect(viewModel.deals, deals);
    });
  });
}