import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soz_muzik/sarkilar.dart';
import 'dart:convert';
import 'favoriler.dart';
import 'sarki_detay.dart';

class AnaSayfa extends StatefulWidget {
  const AnaSayfa({super.key});

  @override
  State<AnaSayfa> createState() => _AnaSayfaState();
}

class _AnaSayfaState extends State<AnaSayfa> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _aramaSonuclari = [];
  final List<String> _favoriSarkiBasliklari = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      _favorileriCihazHafizasindanCek();
    });


  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Container(
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
    );
  }

  Widget _buildBodyColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        IconButton(
          icon: const Icon(
            Icons.favorite,
            color: Colors.red,
            size: 40,
          ),
          onPressed: () {
            _buildFavoriButton(context);
          },
        ),
        const SizedBox(height: 20),
        _buildBodyRow(),
        const SizedBox(height: 20),
        _buildAramaSonuclariText(),
        const SizedBox(height: 20),
        Expanded(child: _buildAramaSonucList()),
      ],
    );
  }

  Widget _buildAramaSonucList() {
    return ListView.builder(
      itemCount: _aramaSonuclari.length > 10 ? 10 : _aramaSonuclari.length,
      itemBuilder: (BuildContext context, int index) {
        var song = _aramaSonuclari[index];
        var sarki = Sarkilar.fromMap(song);
        print(song);

        return Card(
          child: ListTile(
            leading: sarki.thumbnailUrl.isNotEmpty
                ? Image.network(sarki.thumbnailUrl)
                : null,
            title: Text(sarki.baslik),
            subtitle: Text(sarki.sarkici),
            trailing: IconButton(
              icon: Icon(
                _favoriSarkiBasliklari.contains(sarki.baslik)
                    ? Icons.favorite
                    : Icons.favorite_border,
                color: Colors.red,
              ),
              onPressed: () {
                _favoriTiklandi(sarki);
              },
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SarkiDetay(sarki: song),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildAramaSonuclariText() {
    return const Center(
      child: Text(
        "Arama Sonuçları",
        style: TextStyle(
          fontSize: 20,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildBodyRow() {
    return Row(
      children: [
        Expanded(
          flex: 9,
          child: _buildSearchBar(),
        ),
        Expanded(
          flex: 1,
          child: _buildIconButton(),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      controller: _searchController,
      decoration: InputDecoration(
        hintText: "Şarkı Sözlerini Girin",
        fillColor: Colors.white,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }

  Widget _buildIconButton() {
    return IconButton(
      icon: const Icon(Icons.search),
      color: Colors.white,
      onPressed: () {
        _buildSearchButton(context);
      },
    );
  }

  void _buildFavoriButton(BuildContext context) {
    _favorilerSafasiniAc(context);

  }

  void _favorilerSafasiniAc(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const Favoriler(),

      ),
    );
  }



  Future<void> _buildSearchButton(BuildContext context) async {
    String query = _searchController.text;
    String apiKey = 'n-a5Ev8kvhjmAgEibU5rFMpqO-TNtsbmLLzYoBqCRy5is4OKdOTRH4ujVFGDVuu5';
    String apiUrl = 'https://api.genius.com/search?q=$query&access_token=$apiKey';

    var response = await http.get(Uri.parse(apiUrl));

    var jsonResponse = json.decode(response.body);
    List hits = jsonResponse['response']['hits'];

    setState(() {
      _aramaSonuclari = hits.map<Map<String, dynamic>>((hit) => hit['result'] as Map<String, dynamic>).toList();
    });
  }

  void _favoriTiklandi(Sarkilar sarki) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (_favoriSarkiBasliklari.contains(sarki.baslik)) {
      _favoriSarkiBasliklari.remove(sarki.baslik);
      print("SARKİ BASARİYLA silindi");
    } else {
      _favoriSarkiBasliklari.add(sarki.baslik);
      print("SARKİ BASARİYLA EKLENDİ");
    }

    await prefs.setStringList("favoriler", _favoriSarkiBasliklari);

    setState(() {});
  }

  Future<void> _favorileriCihazHafizasindanCek() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? favoriler = prefs.getStringList("favoriler");

    if(favoriler != null){
      for(String baslik in favoriler){
        _favoriSarkiBasliklari.add(baslik);
      }
      print("_favorileriCihazHafizasindanCek calisti");
    }
  }

}
