import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/saved_deals_viewmodel.dart';
import 'widgets/deal_card.dart';
import '../models/deal.dart';

class SavedDealsView extends StatefulWidget {
  const SavedDealsView({Key? key}) : super(key: key);

  @override
  State<SavedDealsView> createState() => _SavedDealsViewState();
}

class _SavedDealsViewState extends State<SavedDealsView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<SavedDealsViewModel>(context, listen: false).loadSavedDeals();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Deals'),
      ),
      body: Consumer<SavedDealsViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.savedDeals.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.bookmark_border, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text(
                    'No saved deals',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Browse Deals'),
                  ),
                ],
              ),
            );
          }
          
          return ListView.builder(
            itemCount: viewModel.savedDeals.length,
            itemBuilder: (context, index) {
              Deal deal = viewModel.savedDeals[index];
              return Dismissible(
                key: Key(deal.id),
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                direction: DismissDirection.endToStart,
                onDismissed: (direction) {
                  viewModel.removeDeal(deal.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${deal.title} removed from saved deals'),
                      action: SnackBarAction(
                        label: 'Undo',
                        onPressed: () {
                          viewModel.toggleSave(deal);
                        },
                      ),
                    ),
                  );
                },
                child: SavedDealCard(deal: deal),
              );
            },
          );
        },
      ),
    );
  }
}

class SavedDealCard extends StatelessWidget {
  final Deal deal;
  
  const SavedDealCard({Key? key, required this.deal}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<SavedDealsViewModel>(context, listen: false);
    
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                deal.thumbnailUrl,
                width: 100,
                height: 45,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 100,
                  height: 45,
                  color: Colors.grey[300],
                  child: const Icon(Icons.image_not_supported),
                ),
              ),
            ),
            const SizedBox(width: 12),
            
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    deal.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        '\$${deal.salePrice}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '\$${deal.normalPrice}',
                        style: const TextStyle(
                          decoration: TextDecoration.lineThrough,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            IconButton(
              icon: const Icon(Icons.bookmark, color: Colors.blue),
              onPressed: () {
                viewModel.removeDeal(deal.id);
              },
            ),
          ],
        ),
      ),
    );
  }
}