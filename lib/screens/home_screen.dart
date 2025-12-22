import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/list_provider.dart';
import '../models/alisveris_listesi.dart';
import 'list_create_screen.dart';
import 'list_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final listProvider = Provider.of<ListProvider>(context);
    final listeler = listProvider.listeler;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
            child: Container(color: primaryColor),
          ),
        ),
        title: const Text(
          '🛒 Alışveriş Listelerim',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        foregroundColor: Colors.white,
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Text(
                'Toplam ${listProvider.toplamAktifUrunSayisi} Ürün',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white70,
                ),
              ),
            ),
          ),
        ],
      ),

      body: listeler.isEmpty
          ? Center(
              child: Text(
                'Henüz listeniz yok. Yeni bir liste ekleyin!',
                style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              itemCount: listeler.length,
              itemBuilder: (context, index) {
                final liste = listeler[index];

                return Dismissible(
                  key: Key(liste.key.toString()),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    listProvider.deleteList(liste);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("${liste.listeAdi} silindi")),
                    );
                  },
                  background: Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: ListCard(liste: liste, listProvider: listProvider),
                  ),
                );
              },
            ),

      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(
          left: 20,
          right: 20,
          bottom: 25,
          top: 10,
        ),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    ListCreateScreen(listProvider: listProvider),
              ),
            );
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
            height: 65,
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: primaryColor.withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: const Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_circle_outline, size: 28, color: Colors.white),
                  SizedBox(width: 10),
                  Text(
                    "YENİ LİSTE OLUŞTUR",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ListCard extends StatelessWidget {
  final AlisverisListesi liste;
  final ListProvider listProvider;

  const ListCard({super.key, required this.liste, required this.listProvider});

  @override
  Widget build(BuildContext context) {
    final int toplamUrun = liste.urunler.length;
    final double yuzde = toplamUrun > 0
        ? (toplamUrun - liste.aktifUrunSayisi) / toplamUrun
        : 0;
    final int yuzdeInt = (yuzde * 100).toInt();

    final primaryColor = Theme.of(context).colorScheme.primary;

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ListDetailScreen(liste: liste),
          ),
        );
      },
      child: Card(
        elevation: 4,
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      liste.listeAdi,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 19,
                        color: Colors.black87,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Kalan Ürün: ${liste.aktifUrunSayisi}',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    height: 60,
                    width: 60,
                    child: CircularProgressIndicator(
                      value: yuzde,
                      strokeWidth: 6,
                      backgroundColor: Colors.grey.shade100,
                      color: primaryColor,
                    ),
                  ),
                  Text(
                    '$yuzdeInt%',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
