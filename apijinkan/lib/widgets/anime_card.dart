import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/anime.dart';

class AnimeCard extends StatelessWidget {
  final Anime anime;
  final VoidCallback onTap;

  const AnimeCard({super.key, required this.anime, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Imagem do anime
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CachedNetworkImage(
                  imageUrl: anime.images.jpg.imageUrl ?? '',
                  width: 100,
                  height: 140,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    width: 100,
                    height: 140,
                    color: Colors.grey[300],
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                  errorWidget: (context, url, error) => Container(
                    width: 100,
                    height: 140,
                    color: Colors.grey[300],
                    child: const Icon(Icons.error),
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Informações do anime
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Título em inglês
                    Text(
                      anime.titleEnglish ?? anime.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),

                    // Título em japonês
                    if (anime.titleJapanese != null)
                      Text(
                        anime.titleJapanese!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    const SizedBox(height: 8),

                    // Tipo
                    if (anime.type != null)
                      _buildInfoChip(
                        context,
                        icon: Icons.tv,
                        label: anime.type!,
                      ),
                    const SizedBox(height: 4),

                    // Fonte
                    if (anime.source != null)
                      _buildInfoChip(
                        context,
                        icon: Icons.source,
                        label: anime.source!,
                      ),
                    const SizedBox(height: 4),

                    // Episódios
                    if (anime.episodes != null)
                      _buildInfoChip(
                        context,
                        icon: Icons.movie,
                        label: '${anime.episodes} eps',
                      ),
                    const SizedBox(height: 4),

                    // Status
                    if (anime.status != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _getStatusColor(anime.status!),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          anime.status!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              // Ícone de seta
              const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(
    BuildContext context, {
    required IconData icon,
    required String label,
  }) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.grey[600]),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'finished airing':
      case 'finished':
        return Colors.green;
      case 'currently airing':
      case 'airing':
        return Colors.blue;
      case 'not yet aired':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}
