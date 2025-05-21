import 'package:hive/hive.dart';
import 'deal.dart';

class DealAdapter extends TypeAdapter<Deal> {
  @override
  final int typeId = 0;

  @override
  Deal read(BinaryReader reader) {
    return Deal(
      id: reader.read(),
      title: reader.read(),
      dealID: reader.read(),
      storeID: reader.read(),
      gameID: reader.read(),
      salePrice: reader.read(),
      normalPrice: reader.read(),
      savings: reader.read(),
      steamRatingText: reader.read(),
      steamRatingPercent: reader.read(),
      metacriticScore: reader.read(),
      thumbnailUrl: reader.read(),
    );
  }

  @override
  void write(BinaryWriter writer, Deal obj) {
    writer.write(obj.id);
    writer.write(obj.title);
    writer.write(obj.dealID);
    writer.write(obj.storeID);
    writer.write(obj.gameID);
    writer.write(obj.salePrice);
    writer.write(obj.normalPrice);
    writer.write(obj.savings);
    writer.write(obj.steamRatingText);
    writer.write(obj.steamRatingPercent);
    writer.write(obj.metacriticScore);
    writer.write(obj.thumbnailUrl);
  }
}