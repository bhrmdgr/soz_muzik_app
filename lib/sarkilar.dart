class Sarkilar {
  String sarkiBasligi;
  String sarkici;
  String baslik;
  String thumbnailUrl;
  String imageUrl;
  String yayinTarihi;

  Sarkilar({
    required this.sarkiBasligi,
    required this.sarkici,
    required this.baslik,
    required this.thumbnailUrl,
    required this.imageUrl,
    required this.yayinTarihi,
  });

  Sarkilar.fromMap(Map<String, dynamic> sarkilarMap)
      : sarkiBasligi = sarkilarMap["full_title"] ?? "",
        sarkici = sarkilarMap["artist_names"] ?? "",
        baslik = sarkilarMap["full_title"],
        thumbnailUrl = sarkilarMap["header_image_thumbnail_url"] ?? "",
        imageUrl = sarkilarMap["header_image_url"],
        yayinTarihi = sarkilarMap["release_date_components"]?["year"].toString() ?? "";

  Map<String, dynamic> toMap() {
    return {
      "full_title": sarkiBasligi,
      "artist_names": sarkici,
      "header_image_thumbnail_url": thumbnailUrl,
      "header_image_url": imageUrl,
      "release_date_components": {
        "year": yayinTarihi
      },
    };
  }
}

/*
{
  "meta": {
    "status": 200
  },
  "response": {
    "hits": [
      {
        "highlights": [],
        "index": "song",
        "type": "song",
        "result": {
          "annotation_count": 17,
          "api_path": "/songs/4950084",
          "artist_names": "Genetikk",
          "full_title": "CHOP $uEY by Genetikk",
          "header_image_thumbnail_url": "https://images.genius.com/9792468efbb265f3ec5d9f8834afab80.300x300x1.jpg",
          "header_image_url": "https://images.genius.com/9792468efbb265f3ec5d9f8834afab80.1000x1000x1.jpg",
          "id": 4950084,
          "lyrics_owner_id": 4303832,
          "lyrics_state": "complete",
          "path": "/Genetikk-chop-suey-lyrics",
          "primary_artist_names": "Genetikk",
          "pyongs_count": null,
          "relationships_index_url": "https://genius.com/Genetikk-chop-suey-sample",
          "release_date_components": {
            "year": 2019,
            "month": 10,
            "day": 25
          },
          "release_date_for_display": "October 25, 2019",
          "release_date_with_abbreviated_month_for_display": "Oct. 25, 2019",
          "song_art_image_thumbnail_url": "https://images.genius.com/9792468efbb265f3ec5d9f8834afab80.300x300x1.jpg",
          "song_art_image_url": "https://images.genius.com/9792468efbb265f3ec5d9f8834afab80.1000x1000x1.jpg",
          "stats": {
            "unreviewed_annotations": 17,
            "hot": false,
            "pageviews": 10647
          },
          "title": "CHOP $uEY",
          "title_with_featured": "CHOP $uEY",
          "url": "https://genius.com/Genetikk-chop-suey-lyrics",
          "featured_artists": [],
          "primary_artist": {
            "api_path": "/artists/15329",
            "header_image_url": "https://images.genius.com/59b4056f5dfea2f1e020f2f71ce1385a.900x600x1.jpg",
            "id": 15329,
            "image_url": "https://images.genius.com/59b4056f5dfea2f1e020f2f71ce1385a.900x600x1.jpg",
            "is_meme_verified": false,
            "is_verified": true,
            "name": "Genetikk",
            "url": "https://genius.com/artists/Genetikk",
            "iq": 100
          },
          "primary_artists": [
            {
              "api_path": "/artists/15329",
              "header_image_url": "https://images.genius.com/59b4056f5dfea2f1e020f2f71ce1385a.900x600x1.jpg",
              "id": 15329,
              "image_url": "https://images.genius.com/59b4056f5dfea2f1e020f2f71ce1385a.900x600x1.jpg",
              "is_meme_verified": false,
              "is_verified": true,
              "name": "Genetikk",
              "url": "https://genius.com/artists/Genetikk",
              "iq": 100
            }
          ]
        }
      },
* */