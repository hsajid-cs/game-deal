import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/deal.dart';
import '../../viewmodels/home_viewmodel.dart';

class DealCard extends StatelessWidget {
  final Deal deal;

  const DealCard({Key? key, required this.deal}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<HomeViewModel>(context, listen: false);

    final normalPrice = double.tryParse(deal.normalPrice) ?? 0.0;
    final salePrice = double.tryParse(deal.salePrice) ?? 0.0;
    final amountSaved = normalPrice - salePrice;
    final savePercent = ((amountSaved / normalPrice) * 100).clamp(0, 100).toStringAsFixed(1);

    final ratingPercent = int.tryParse(deal.steamRatingPercent) ?? 0;
    final starCount = (ratingPercent / 20).round().clamp(0, 5);

    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Game Thumbnail
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                deal.thumbnailUrl,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 80,
                  height: 80,
                  color: Colors.grey[300],
                  child: const Icon(Icons.image_not_supported),
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Game Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    deal.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),

                  // Price row
                  Row(
                    children: [
                      Text(
                        'Price: ',
                        style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                      ),
                      Text(
                        '\$${deal.normalPrice}',
                        style: const TextStyle(
                          decoration: TextDecoration.lineThrough,
                          color: Colors.red,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '\$${deal.salePrice}',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),

                  // You Save
                  Text(
                    'You Save: $savePercent%',
                    style: const TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 4),

                  // Star Rating
                  Row(
                    children: [
                      const Text('Rating: ', style: TextStyle(fontSize: 13)),
                      ...List.generate(starCount, (index) => const Icon(Icons.star, color: Colors.amber, size: 16)),
                      ...List.generate(5 - starCount, (index) => const Icon(Icons.star_border, color: Colors.amber, size: 16)),
                    ],
                  ),
                ],
              ),
            ),

            // Bookmark Icon
            Consumer<HomeViewModel>(
              builder: (context, viewModel, _) {
                final isSaved = viewModel.isDealSaved(deal.id);
                return IconButton(
                  icon: Icon(
                    isSaved ? Icons.bookmark : Icons.bookmark_border,
                    color: isSaved ? Colors.blue : Colors.grey,
                  ),
                  onPressed: () {
                    viewModel.toggleSaveDeal(deal);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}