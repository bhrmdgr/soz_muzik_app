import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soz_muzik/sarki_detay.dart';
import 'package:soz_muzik/sarkilar.dart';

class OrtakListe extends StatefulWidget {
  final List<Map<String, dynamic>> _aramaSonuclari = [];
  final List<String> _favoriSarkiBasliklari = [];



  OrtakListe(this._aramaSonuclari, this._favoriSarkiBasliklari, {super.key});

  @override
  State<OrtakListe> createState() => _OrtakListeState();
}

class _OrtakListeState extends State<OrtakListe> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget._aramaSonuclari.length > 10 ? 10 : widget._aramaSonuclari.length,
      itemBuilder: (BuildContext context, int index) {
        var song = widget._aramaSonuclari[index];
        var sarki = Sarkilar.fromMap(song);

        return Card(
          child: ListTile(
            leading: sarki.thumbnailUrl.isNotEmpty
                ? Image.network(sarki.thumbnailUrl)
                : null,
            title: Text(sarki.baslik),
            subtitle: Text(sarki.sarkici),
            trailing: IconButton(
              icon: Icon(
                widget._favoriSarkiBasliklari.contains(sarki.baslik)
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

  void _favoriTiklandi(Sarkilar sarki) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (widget._favoriSarkiBasliklari.contains(sarki.baslik)) {
      widget._favoriSarkiBasliklari.remove(sarki.baslik);
    } else {
      widget._favoriSarkiBasliklari.add(sarki.baslik);
    }

    await prefs.setStringList("favoriler", widget._favoriSarkiBasliklari);

    setState(() {});
  }
}
