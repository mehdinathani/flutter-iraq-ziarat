import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/quran_controller.dart';

class QuranPage extends StatelessWidget {
  QuranPage({super.key});

  final QuranController controller = Get.find<QuranController>();
  final searchQuery = ''.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        title: const Text(
          'Quran',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Get.back(),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search Surah...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 0,
                  horizontal: 20,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                searchQuery.value = value.trim();
              },
            ),
          ),
          Expanded(
            child: Obx(() {
              final filtered =
                  controller.surahList.where((surah) {
                    final query = searchQuery.value.toLowerCase();
                    return surah['name'].toString().toLowerCase().contains(
                      query,
                    );
                  }).toList();

              return ListView.separated(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                itemCount: filtered.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final surah = filtered[index];
                  final isFav = controller.favorites.contains(surah['number']);

                  return Material(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    elevation: 2,
                    child: ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      leading: CircleAvatar(
                        backgroundColor: Colors.lightBlueAccent,
                        child: Text(
                          '${surah['number']}',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      title: Text(
                        surah['name'],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text('Verses: ${surah['verses']}'),
                      trailing: IconButton(
                        icon: Icon(
                          isFav ? Icons.star : Icons.star_border,
                          color: isFav ? Colors.orange : Colors.grey,
                        ),
                        onPressed:
                            () => controller.toggleFavorite(surah['number']),
                      ),
                      onTap:
                          () => controller.openSurah(
                            surah['number'],
                            surah['name'],
                          ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
