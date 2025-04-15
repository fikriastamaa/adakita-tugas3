class SitusModel {
  final int id;
  final String namaSitus;
  final String url;
  final String gambarUrl;
  bool isFavorite; // <-- tambahkan ini!

  SitusModel({
    required this.id,
    required this.namaSitus,
    required this.url,
    required this.gambarUrl,
    this.isFavorite = false, // <-- default-nya false
  });
}
