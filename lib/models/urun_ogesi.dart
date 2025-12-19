// lib/models/urun_ogesi.dart
import 'package:hive/hive.dart';

part 'urun_ogesi.g.dart';

@HiveType(typeId: 0)
enum Oncelik {
  @HiveField(0)
  yuksek,
  @HiveField(1)
  orta,
  @HiveField(2)
  dusuk,
}

@HiveType(typeId: 1)
class UrunOgesi extends HiveObject {
  @HiveField(0)
  String ad;

  @HiveField(1)
  int adet;

  @HiveField(2)
  bool tamamlandi;

  @HiveField(3)
  double? fiyat;

  @HiveField(4)
  Oncelik oncelik;

  UrunOgesi({
    required this.ad,
    required this.adet,
    this.tamamlandi = false,
    this.fiyat,
    this.oncelik = Oncelik.orta,
  });

  double get toplamFiyat => (fiyat ?? 0) * adet;
}
