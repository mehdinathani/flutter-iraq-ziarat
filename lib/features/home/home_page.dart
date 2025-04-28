import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA), // Soft background
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        title: const Hero(
          tag: 'appLogo',
          child: Text(
            'Rehnuma-e-Safar',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 24,
              letterSpacing: 1.2,
            ),
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.black87),
            onPressed: () {
              Get.snackbar(
                'Coming Soon',
                'Settings will be available soon!',
                snackPosition: SnackPosition.BOTTOM,
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            _buildCard(
              title: 'Quran 📖',
              color: Colors.lightBlueAccent,
              onTap: () {
                Get.toNamed('/quran');
              },
            ),
            _buildCard(
              title: 'Iraq Ziyarat 🇮🇶',
              color: Colors.orangeAccent,
              onTap: () {
                Get.toNamed('/ziarat');
              },
            ),
            _buildCard(
              title: 'Dua 📿',
              color: Colors.deepPurpleAccent,
              onTap: () {
                Get.snackbar(
                  'Coming Soon',
                  'Duas will be added soon!',
                  snackPosition: SnackPosition.BOTTOM,
                );
              },
            ),
            _buildCard(
              title: 'Favorites ⭐',
              color: Colors.greenAccent,
              onTap: () {
                Get.snackbar(
                  'Coming Soon',
                  'Favorites will be available soon!',
                  snackPosition: SnackPosition.BOTTOM,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard({
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Ink(
        decoration: BoxDecoration(
          color: color.withOpacity(0.8),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.4),
              blurRadius: 10,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                height: 1.2,
                letterSpacing: 1.1,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
