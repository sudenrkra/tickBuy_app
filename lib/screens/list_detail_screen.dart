import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/alisveris_listesi.dart';
import '../models/urun_ogesi.dart';
import '../services/list_provider.dart';

class ListDetailScreen extends StatefulWidget {
  final AlisverisListesi liste;

  const ListDetailScreen({super.key, required this.liste});

  @override
  State<ListDetailScreen> createState() => _ListDetailScreenState();
}

class _ListDetailScreenState extends State<ListDetailScreen> {
  void _showAddProductModal(
    BuildContext context,
    ListProvider listProvider,
    AlisverisListesi liste,
  ) {
    final TextEditingController urunAdiController = TextEditingController();
    final TextEditingController adetController = TextEditingController();

    final primaryColor = Theme.of(context).colorScheme.primary;
    final modalBackgroundColor = Colors.white;
    final inputFillColor = Colors.grey.shade100;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: modalBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          top: 20,
          left: 20,
          right: 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Yeni Ürün Ekle',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 20),

            TextField(
              controller: urunAdiController,
              style: const TextStyle(color: Colors.black87, fontSize: 16),
              decoration: InputDecoration(
                labelText: 'Ürün Adı',
                labelStyle: const TextStyle(color: Colors.grey),
                filled: true,
                fillColor: inputFillColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 15),

            TextField(
              controller: adetController,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.black87, fontSize: 16),
              decoration: InputDecoration(
                labelText: 'Adet',
                labelStyle: const TextStyle(color: Colors.grey),
                filled: true,
                fillColor: inputFillColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 25),

            ElevatedButton(
              onPressed: () async {
                final ad = urunAdiController.text.trim();
                final adet = int.tryParse(adetController.text.trim()) ?? 1;

                if (ad.isEmpty) {
                  ScaffoldMessenger.of(ctx).showSnackBar(
                    const SnackBar(content: Text('Ürün adı boş bırakılamaz.')),
                  );
                  return;
                }

                final yeniUrun = UrunOgesi(
                  ad: ad,
                  adet: adet,
                  oncelik: Oncelik.orta,
                  tamamlandi: false,
                );

                final urunlerBox = Hive.box<UrunOgesi>('urunler');
                await urunlerBox.add(yeniUrun);

                liste.urunler.add(yeniUrun);
                await liste.save();
                listProvider.updateList(liste);

                FocusScope.of(ctx).unfocus();
                Navigator.pop(ctx);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text(
                'Ekle',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductSection(
    BuildContext context,
    String title,
    List<UrunOgesi> urunler,
    ListProvider provider,
    AlisverisListesi liste, {
    bool completed = false,
  }) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: completed ? Colors.grey : primaryColor,
          ),
        ),
        const SizedBox(height: 8),

        ...urunler.map(
          (u) => ProductTile(
            urun: u,
            listProvider: provider,
            liste: liste,
            context: context,
          ),
        ),

        const SizedBox(height: 20),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ListProvider>(context);

    final liste = provider.listeler.firstWhere(
      (l) => l.key == widget.liste.key,
      orElse: () => widget.liste,
    );

    final primaryColor = Theme.of(context).colorScheme.primary;

    final aktif = liste.urunler.where((u) => !u.tamamlandi).toList();
    final tamamlanan = liste.urunler.where((u) => u.tamamlandi).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 7, sigmaY: 7),
            child: Container(color: primaryColor),
          ),
        ),
        title: Text(
          liste.listeAdi,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        foregroundColor: Colors.white,
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (aktif.isNotEmpty)
            _buildProductSection(
              context,
              "Alınacak Ürünler (${aktif.length})",
              aktif,
              provider,
              liste,
            ),

          if (tamamlanan.isNotEmpty)
            _buildProductSection(
              context,
              "Tamamlanan Ürünler (${tamamlanan.length})",
              tamamlanan,
              provider,
              liste,
              completed: true,
            ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        onPressed: () => _showAddProductModal(context, provider, liste),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

class ProductTile extends StatelessWidget {
  final UrunOgesi urun;
  final ListProvider listProvider;
  final AlisverisListesi liste;
  final BuildContext context;

  const ProductTile({
    super.key,
    required this.urun,
    required this.listProvider,
    required this.liste,
    required this.context,
  });

  void _toggle() {
    urun.tamamlandi = !urun.tamamlandi;
    urun.save();
    listProvider.updateList(liste);
  }

  void _increase() {
    urun.adet++;
    urun.save();
    listProvider.updateList(liste);
  }

  void _decrease() {
    if (urun.adet > 1) {
      urun.adet--;
      urun.save();
      listProvider.updateList(liste);
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    final isAcil = urun.oncelik == Oncelik.yuksek && !urun.tamamlandi;
    final textColor = Colors.black87;
    final cardColor = Colors.white;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 7),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: isAcil
                ? Colors.red.withOpacity(0.15)
                : Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
        border: isAcil
            ? Border(
                left: BorderSide(color: Colors.redAccent.shade700, width: 8),
              )
            : null,
      ),
      child: ListTile(
        title: Row(
          children: [
            if (isAcil)
              const Padding(
                padding: EdgeInsets.only(right: 6),
                child: Icon(
                  Icons.priority_high_rounded,
                  color: Colors.redAccent,
                  size: 18,
                ),
              ),

            Text(
              urun.ad,
              style: TextStyle(
                fontSize: 16,
                fontWeight: isAcil ? FontWeight.w900 : FontWeight.w600,
                decoration: urun.tamamlandi ? TextDecoration.lineThrough : null,
                color: urun.tamamlandi ? Colors.grey : textColor,
              ),
            ),
          ],
        ),
        subtitle: Text(
          urun.fiyat != null
              ? '${urun.fiyat!.toStringAsFixed(2)} TL (Tahmini)'
              : '',
          style: TextStyle(fontSize: 12, color: textColor.withOpacity(0.6)),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.remove_circle_outline),
              onPressed: urun.tamamlandi ? null : _decrease,
              color: urun.tamamlandi ? Colors.grey : primaryColor,
            ),
            Text(
              "${urun.adet}",
              style: TextStyle(
                fontSize: 16,
                color: textColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.add_circle_outline),
              onPressed: urun.tamamlandi ? null : _increase,
              color: urun.tamamlandi ? Colors.grey : primaryColor,
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
              onPressed: () => listProvider.deleteUrun(liste, urun),
            ),
            Checkbox(
              value: urun.tamamlandi,
              onChanged: (_) => _toggle(),
              activeColor: urun.tamamlandi
                  ? Colors.greenAccent.shade700
                  : primaryColor,
              checkColor: Colors.white,
            ),
          ],
        ),
        onTap: _toggle,
      ),
    );
  }
}
