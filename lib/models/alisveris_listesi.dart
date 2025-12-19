// lib/models/alisveris_listesi.dart
import 'package:hive/hive.dart';
import 'urun_ogesi.dart';

part 'alisveris_listesi.g.dart';

@HiveType(typeId: 2)
enum Kategori {
  @HiveField(0)
  market,
  @HiveField(1)
  kirtasiye,
  @HiveField(2)
  manav,
  @HiveField(3)
  diger,
}

@HiveType(typeId: 3)
class AlisverisListesi extends HiveObject {
  @HiveField(0)
  String listeAdi;

  @HiveField(1)
  HiveList<UrunOgesi> urunler;

  @HiveField(2)
  DateTime olusturmaTarihi;

  @HiveField(3)
  Kategori kategori;

  AlisverisListesi({
    required this.listeAdi,
    required this.urunler,
    this.kategori = Kategori.market,
  }) : olusturmaTarihi = DateTime.now();

  int get aktifUrunSayisi {
    return urunler.where((u) => !u.tamamlandi).length;
  }

  double get toplamListeFiyati {
    return urunler.fold(0.0, (sum, u) => sum + u.toplamFiyat);
  }
}
