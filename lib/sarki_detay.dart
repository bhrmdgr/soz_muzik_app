import 'package:flutter/material.dart';

class SarkiDetay extends StatelessWidget {
  final Map<String, dynamic> sarki;

  const SarkiDetay({super.key, required this.sarki});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          sarki['title'] ?? 'Şarkı Detayları',
          style: const TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.black87,
        automaticallyImplyLeading: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/back_wallpaper.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: _buildBodyColumn(),
        ),
      ),
    );
  }

  Widget _buildBodyColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (sarki['song_art_image_url'] != null)
          Padding(
            padding: const EdgeInsets.all(50.0),
            child: Image.network(
              sarki['song_art_image_url'] ?? '',
              fit: BoxFit.cover,
              width: double.infinity,
              height: 400,
              alignment: Alignment.center,
            ),
          ),
        const SizedBox(height: 16),
        Text(
          sarki['title'] ?? 'No Title',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          sarki['primary_artist']?['name'] ?? 'Unknown Artist',
          style: const TextStyle(
            fontSize: 18,
            fontStyle: FontStyle.italic,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          sarki['release_date_for_display'] ?? 'Unknown Release Date',
          style: const TextStyle(fontSize: 16, color: Colors.white),
        ),
        const SizedBox(height: 16),
        if (sarki['lyrics'] != null)
          Expanded(
            child: SingleChildScrollView(
              child: Text(
                sarki['lyrics'] ?? 'No Lyrics',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
      ],
    );
  }
}
