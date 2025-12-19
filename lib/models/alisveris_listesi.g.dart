// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alisveris_listesi.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AlisverisListesiAdapter extends TypeAdapter<AlisverisListesi> {
  @override
  final int typeId = 3;

  @override
  AlisverisListesi read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AlisverisListesi(
      listeAdi: fields[0] as String,
      urunler: (fields[1] as HiveList).castHiveList(),
      kategori: fields[3] as Kategori,
    )..olusturmaTarihi = fields[2] as DateTime;
  }

  @override
  void write(BinaryWriter writer, AlisverisListesi obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.listeAdi)
      ..writeByte(1)
      ..write(obj.urunler)
      ..writeByte(2)
      ..write(obj.olusturmaTarihi)
      ..writeByte(3)
      ..write(obj.kategori);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AlisverisListesiAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class KategoriAdapter extends TypeAdapter<Kategori> {
  @override
  final int typeId = 2;

  @override
  Kategori read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return Kategori.market;
      case 1:
        return Kategori.kirtasiye;
      case 2:
        return Kategori.manav;
      case 3:
        return Kategori.diger;
      default:
        return Kategori.market;
    }
  }

  @override
  void write(BinaryWriter writer, Kategori obj) {
    switch (obj) {
      case Kategori.market:
        writer.writeByte(0);
        break;
      case Kategori.kirtasiye:
        writer.writeByte(1);
        break;
      case Kategori.manav:
        writer.writeByte(2);
        break;
      case Kategori.diger:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is KategoriAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
