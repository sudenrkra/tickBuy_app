import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/alisveris_listesi.dart';
import '../models/urun_ogesi.dart';
import '../services/list_provider.dart';

class ListCreateScreen extends StatefulWidget {
  final ListProvider listProvider;

  const ListCreateScreen({super.key, required this.listProvider});

  @override
  State<ListCreateScreen> createState() => _ListCreateScreenState();
}

class _ListCreateScreenState extends State<ListCreateScreen> {
  final _listNameController = TextEditingController();
  final _urunAdiController = TextEditingController();
  final _adetController = TextEditingController();
  final _fiyatController = TextEditingController();

  List<UrunOgesi> geciciUrunListesi = [];
  Kategori secilenKategori = Kategori.market;

  bool acilMi = false;

  void _urunEkle() {
    final ad = _urunAdiController.text.trim();
    final adet = int.tryParse(_adetController.text.trim()) ?? 1;
    final fiyat = double.tryParse(_fiyatController.text.trim());

    if (ad.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Ürün adı boş olamaz')));
      return;
    }

    final urun = UrunOgesi(
      ad: ad,
      adet: adet,
      fiyat: fiyat,
      oncelik: acilMi ? Oncelik.yuksek : Oncelik.orta,
      tamamlandi: false,
    );

    setState(() {
      geciciUrunListesi.add(urun);
      _urunAdiController.clear();
      _adetController.clear();
      _fiyatController.clear();
      acilMi = false;
    });
  }

  void _listeyiKaydet() {
    final box = Hive.box<UrunOgesi>('urunler');

    for (var urun in geciciUrunListesi) {
      box.add(urun);
    }

    final hiveList = HiveList<UrunOgesi>(box)..addAll(geciciUrunListesi);

    final liste = AlisverisListesi(
      listeAdi: _listNameController.text.trim(),
      urunler: hiveList,
      kategori: secilenKategori,
    );

    widget.listProvider.addList(liste);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: primary,
        title: const Text(
          'Yeni Liste',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        foregroundColor: Colors.white,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _title("Liste Bilgileri"),
                  const SizedBox(height: 12),
                  _field(_listNameController, "Liste Adı"),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<Kategori>(
                    dropdownColor: Colors.white,
                    style: const TextStyle(color: Colors.black87),
                    value: secilenKategori,
                    decoration: _dropdownDeco("Kategori"),
                    items: Kategori.values.map((k) {
                      return DropdownMenuItem(
                        value: k,
                        child: Text(k.name.toUpperCase()),
                      );
                    }).toList(),
                    onChanged: (v) => setState(() => secilenKategori = v!),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            _card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _title("Ürün Ekle"),
                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Expanded(child: _field(_urunAdiController, "Ürün")),
                      const SizedBox(width: 8),
                      SizedBox(
                        width: 70,
                        child: _field(
                          _adetController,
                          "Adet",
                          type: TextInputType.number,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  _field(
                    _fiyatController,
                    "Fiyat (opsiyonel)",
                    type: TextInputType.number,
                  ),

                  const SizedBox(height: 10),

                  Row(
                    children: [
                      OutlinedButton.icon(
                        onPressed: () => setState(() => acilMi = !acilMi),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            color: acilMi ? Colors.red : Colors.grey.shade300,
                          ),
                        ),
                        icon: Icon(
                          Icons.priority_high,
                          color: acilMi ? Colors.red : Colors.grey,
                        ),
                        label: Text(
                          "ACİL",
                          style: TextStyle(
                            color: acilMi ? Colors.red : Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: _urunEkle,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primary,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text("Ekle"),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            if (geciciUrunListesi.isNotEmpty) ...[
              const SizedBox(height: 20),
              _card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _title("Eklenen Ürünler"),
                    const SizedBox(height: 10),
                    ...geciciUrunListesi.map((urun) {
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          "${urun.ad} (${urun.adet})",
                          style: const TextStyle(color: Colors.black87),
                        ),
                        trailing: IconButton(
                          icon: const Icon(
                            Icons.close,
                            color: Colors.redAccent,
                          ),
                          onPressed: () {
                            setState(() {
                              geciciUrunListesi.remove(urun);
                            });
                          },
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _listeyiKaydet,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  "Listeyi Kaydet",
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _card({required Widget child}) {
    return Card(
      color: Colors.white,
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(padding: const EdgeInsets.all(14), child: child),
    );
  }

  Widget _title(String t) => Text(
    t,
    style: const TextStyle(
      fontSize: 17,
      fontWeight: FontWeight.bold,
      color: Colors.black87,
    ),
  );

  Widget _field(TextEditingController c, String label, {TextInputType? type}) {
    return TextField(
      controller: c,
      keyboardType: type,
      style: const TextStyle(color: Colors.black87),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.grey),
        filled: true,
        fillColor: const Color(0xFFFAFAFA),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
      ),
    );
  }

  InputDecoration _dropdownDeco(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.grey),
      filled: true,
      fillColor: const Color(0xFFFAFAFA),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade200),
      ),
    );
  }
}
