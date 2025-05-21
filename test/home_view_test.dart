import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/home_viewmodel.dart';
import 'widgets/deal_card.dart';
import 'widgets/search_bar.dart';
import 'saved_deals_view.dart';
import 'package:intl/intl.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  String currentDateTime = '';
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _updateDateTime();

    // Update time every second
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateDateTime();
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<HomeViewModel>(context, listen: false).fetchDeals();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _updateDateTime() {
    final now = DateTime.now().toUtc();
    final formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
    setState(() {
      currentDateTime = formatter.format(now);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Game Deals'),
        actions: [
          // Current Date/Time display
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('UTC Time', style: TextStyle(fontSize: 10)),
                  Text(currentDateTime, style: const TextStyle(fontSize: 12)),
                  Text('User: hsajid-cs', style: const TextStyle(fontSize: 10)),
                ],
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.bookmarks),
            onPressed: () async {
              // Navigate to saved deals and await its completion
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SavedDealsView()),
              );

              // Force refresh when returning to this screen
              Provider.of<HomeViewModel>(
                context,
                listen: false,
              ).notifyListeners();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          const SearchBarWidget(),
          Expanded(
            child: Consumer<HomeViewModel>(
              builder: (context, viewModel, child) {
                switch (viewModel.state) {
                  case HomeViewState.loading:
                    return const Center(child: CircularProgressIndicator());

                  case HomeViewState.loaded:
                    if (viewModel.deals.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.search_off,
                              size: 64,
                              color: Colors.grey,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              viewModel.searchQuery.isEmpty
                                  ? 'No deals available'
                                  : 'No results for "${viewModel.searchQuery}"',
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return RefreshIndicator(
                      onRefresh: () => viewModel.fetchDeals(),
                      child: ListView.builder(
                        itemCount: viewModel.deals.length,
                        itemBuilder: (context, index) {
                          return DealCard(deal: viewModel.deals[index]);
                        },
                      ),
                    );

                  case HomeViewState.error:
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            size: 64,
                            color: Colors.red,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Error: ${viewModel.errorMessage}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 18),
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton(
                            onPressed: () => viewModel.fetchDeals(),
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );

                  default:
                    return const SizedBox.shrink();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
