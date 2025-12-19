// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'urun_ogesi.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UrunOgesiAdapter extends TypeAdapter<UrunOgesi> {
  @override
  final int typeId = 1;

  @override
  UrunOgesi read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UrunOgesi(
      ad: fields[0] as String,
      adet: fields[1] as int,
      tamamlandi: fields[2] as bool,
      fiyat: fields[3] as double?,
      oncelik: fields[4] as Oncelik,
    );
  }

  @override
  void write(BinaryWriter writer, UrunOgesi obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.ad)
      ..writeByte(1)
      ..write(obj.adet)
      ..writeByte(2)
      ..write(obj.tamamlandi)
      ..writeByte(3)
      ..write(obj.fiyat)
      ..writeByte(4)
      ..write(obj.oncelik);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UrunOgesiAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class OncelikAdapter extends TypeAdapter<Oncelik> {
  @override
  final int typeId = 0;

  @override
  Oncelik read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return Oncelik.yuksek;
      case 1:
        return Oncelik.orta;
      case 2:
        return Oncelik.dusuk;
      default:
        return Oncelik.yuksek;
    }
  }

  @override
  void write(BinaryWriter writer, Oncelik obj) {
    switch (obj) {
      case Oncelik.yuksek:
        writer.writeByte(0);
        break;
      case Oncelik.orta:
        writer.writeByte(1);
        break;
      case Oncelik.dusuk:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OncelikAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
