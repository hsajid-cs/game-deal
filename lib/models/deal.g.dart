// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'deal.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DealAdapter extends TypeAdapter<Deal> {
  @override
  final int typeId = 0;

  @override
  Deal read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Deal(
      id: fields[0] as String,
      title: fields[1] as String,
      dealID: fields[2] as String,
      storeID: fields[3] as String,
      gameID: fields[4] as String,
      salePrice: fields[5] as String,
      normalPrice: fields[6] as String,
      savings: fields[7] as String,
      steamRatingText: fields[8] as String,
      steamRatingPercent: fields[9] as String,
      metacriticScore: fields[10] as String,
      thumbnailUrl: fields[11] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Deal obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.dealID)
      ..writeByte(3)
      ..write(obj.storeID)
      ..writeByte(4)
      ..write(obj.gameID)
      ..writeByte(5)
      ..write(obj.salePrice)
      ..writeByte(6)
      ..write(obj.normalPrice)
      ..writeByte(7)
      ..write(obj.savings)
      ..writeByte(8)
      ..write(obj.steamRatingText)
      ..writeByte(9)
      ..write(obj.steamRatingPercent)
      ..writeByte(10)
      ..write(obj.metacriticScore)
      ..writeByte(11)
      ..write(obj.thumbnailUrl);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DealAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
