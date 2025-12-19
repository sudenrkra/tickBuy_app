// lib/services/list_provider.dart

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/alisveris_listesi.dart';
import '../models/urun_ogesi.dart';

class ListProvider extends ChangeNotifier {
  Box<AlisverisListesi> get listelerBox => Hive.box<AlisverisListesi>('lists');

  List<AlisverisListesi> get listeler {
    var sortedList = listelerBox.values.toList()
      ..sort((a, b) => b.olusturmaTarihi.compareTo(a.olusturmaTarihi));
    return sortedList;
  }

  void addList(AlisverisListesi yeniListe) {
    // Listeyi Hive kutusuna ekle.
    listelerBox.add(yeniListe);
    notifyListeners();
  }

  void updateList(AlisverisListesi guncelListe) {
    //  Listenin kendisini kaydetmek yerine,
    // anahtarını (key) kullanarak kutuya geri koyuyoruz (put).

    if (guncelListe.key != null) {
      // Listeyi kendi anahtarına (key) geri koyarak güncelle
      listelerBox.put(guncelListe.key, guncelListe);
    } else {
      // Eğer liste henüz kaydedilmemişse (key null ise) normal ekleme yap.
      // Bu durum normalde olmamalı, ama güvenliğimiz için ekleyelim.
      listelerBox.add(guncelListe);
    }

    notifyListeners();
  }

  void deleteList(AlisverisListesi silinecekListe) {
    silinecekListe.delete();
    notifyListeners();
  }

  void deleteUrun(AlisverisListesi liste, UrunOgesi urun) {
    // HiveList'ten objeyi kaldır.
    liste.urunler.remove(urun);

    // Ana listeyi güncelle (kaydet ve dinleyicileri uyar).
    updateList(liste);

    // Ürünü kendi kutusundan sil (istenirse, veri tabanında yer kaplamaması için).
    urun.delete();
  }

  // Uygulama genelinde toplam aktif ürün sayısını hesaplayan getter.
  int get toplamAktifUrunSayisi {
    return listeler.fold(0, (sum, liste) => sum + liste.aktifUrunSayisi);
  }
}
