import 'package:flutter/material.dart';
import '../models/situs_model.dart';
import 'package:url_launcher/url_launcher.dart';

class SitusCard extends StatelessWidget {
  final SitusModel situs;
  final VoidCallback onFavoriteToggle;

  const SitusCard({
    super.key,
    required this.situs,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Image.network(situs.gambarUrl, width: 50, height: 50),
        title: Text(situs.namaSitus),
        subtitle: Text(situs.url),
        trailing: IconButton(
          icon: Icon(
            situs.isFavorite ? Icons.favorite : Icons.favorite_border,
            color: situs.isFavorite ? Colors.red : null,
          ),
          onPressed: onFavoriteToggle,
        ),
        onTap: () async {
          final uri = Uri.parse(situs.url);
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri);
          }
        },
      ),
    );
  }
}
