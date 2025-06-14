import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:soz_muzik/ana_sayfa.dart';
import 'package:soz_muzik/sarkilar.dart';

class Favoriler extends StatefulWidget {
  const Favoriler({super.key});

  @override
  State<Favoriler> createState() => _FavorilerState();
}

class _FavorilerState extends State<Favoriler> {
  List<Sarkilar> _favoriSarkilar = [];
  List<String> _favoriSarkiBasliklari = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFavoriSarkilar();
  }

  Future<void> _loadFavoriSarkilar() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? favoriSarkiBasliklari = prefs.getStringList("favoriler");

    if (favoriSarkiBasliklari != null) {
      setState(() {
        _favoriSarkiBasliklari = favoriSarkiBasliklari;
        _isLoading = true;
      });

      List<Sarkilar> tempSarkilar = [];
      for (String baslik in _favoriSarkiBasliklari) {
        var sarki = await _fetchSarkiByTitle(baslik);
        if (sarki != null) {
          tempSarkilar.add(sarki);
        }
      }

      setState(() {
        _favoriSarkilar = tempSarkilar;
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<Sarkilar?> _fetchSarkiByTitle(String baslik) async {
    String apiKey = 'n-a5Ev8kvhjmAgEibU5rFMpqO-TNtsbmLLzYoBqCRy5is4OKdOTRH4ujVFGDVuu5';
    String apiUrl = 'https://api.genius.com/search?q=$baslik&access_token=$apiKey';

    var response = await http.get(Uri.parse(apiUrl));

    var jsonResponse = json.decode(response.body);
    List hits = jsonResponse['response']['hits'];

    if (hits.isNotEmpty) {
      var sarkiMap = hits[0]['result'] as Map<String, dynamic>;
      return Sarkilar.fromMap(sarkiMap);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: _favoriSarkilar.length,
        itemBuilder: (BuildContext context, int index) {
          var sarki = _favoriSarkilar[index];

          return Card(
            child: ListTile(
              leading: sarki.thumbnailUrl.isNotEmpty
                  ? Image.network(sarki.thumbnailUrl)
                  : null,
              title: Text(sarki.baslik),
              subtitle: Text(sarki.sarkici),
              trailing: IconButton(
                icon: const Icon(
                  Icons.favorite,
                  color: Colors.red,
                ),
                onPressed: () {
                  _favoriTiklandi(sarki);
                },
              ),
              /*onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SarkiDetay(sarki: sarki.toMap()),
                  ),
                );
              },*/
            ),
          );
        },
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Row(
        children: [
          IconButton(
            icon: const Icon(
              Icons.arrow_back
            ),
            onPressed: _anaSayfayaDon,),
          const Text("Favoriler"),
        ],
      ),
      elevation: 1,
    );
  }

  void _anaSayfayaDon(){
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const AnaSayfa(),

      ),
    );
  }

  void _favoriTiklandi(Sarkilar sarki) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? favoriSarkiBasliklari = prefs.getStringList("favoriler");

    if (favoriSarkiBasliklari != null) {
      if (favoriSarkiBasliklari.contains(sarki.baslik)) {
        favoriSarkiBasliklari.remove(sarki.baslik);
      } else {
        favoriSarkiBasliklari.add(sarki.baslik);
      }

      await prefs.setStringList("favoriler", favoriSarkiBasliklari);

      // Reload the list
      setState(() {
        _favoriSarkiBasliklari = favoriSarkiBasliklari;
        _isLoading = true;
        _loadFavoriSarkilar();
      });
    }
  }
}
