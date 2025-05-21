import 'package:hive/hive.dart';

part 'deal.g.dart';

@HiveType(typeId: 0)
class Deal {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String title;
  
  @HiveField(2)
  final String dealID;
  
  @HiveField(3)
  final String storeID;
  
  @HiveField(4)
  final String gameID;
  
  @HiveField(5)
  final String salePrice;
  
  @HiveField(6)
  final String normalPrice;
  
  @HiveField(7)
  final String savings;
  
  @HiveField(8)
  final String steamRatingText;
  
  @HiveField(9)
  final String steamRatingPercent;
  
  @HiveField(10)
  final String metacriticScore;
  
  @HiveField(11)
  final String thumbnailUrl;
  
  Deal({
    required this.id,
    required this.title,
    required this.dealID,
    required this.storeID,
    required this.gameID,
    required this.salePrice,
    required this.normalPrice,
    required this.savings,
    required this.steamRatingText,
    required this.steamRatingPercent,
    required this.metacriticScore,
    required this.thumbnailUrl,
  });
  
  factory Deal.fromJson(Map<String, dynamic> json) {
    return Deal(
      id: json['dealID'] ?? '',
      title: json['title'] ?? '',
      dealID: json['dealID'] ?? '',
      storeID: json['storeID'] ?? '',
      gameID: json['gameID'] ?? '',
      salePrice: json['salePrice'] ?? '',
      normalPrice: json['normalPrice'] ?? '',
      savings: json['savings'] ?? '',
      steamRatingText: json['steamRatingText'] ?? '',
      steamRatingPercent: json['steamRatingPercent'] ?? '',
      metacriticScore: json['metacriticScore'] ?? '',
      thumbnailUrl: json['thumb'] ?? '',
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'dealID': dealID,
      'storeID': storeID,
      'gameID': gameID,
      'salePrice': salePrice,
      'normalPrice': normalPrice,
      'savings': savings,
      'steamRatingText': steamRatingText,
      'steamRatingPercent': steamRatingPercent,
      'metacriticScore': metacriticScore,
      'thumbnailUrl': thumbnailUrl,
    };
  }
}