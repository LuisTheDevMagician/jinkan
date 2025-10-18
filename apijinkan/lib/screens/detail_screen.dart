import 'package:flutter/material.dart';
import '../models/anime.dart';
import 'package:cached_network_image/cached_network_image.dart';

class DetailScreen extends StatelessWidget {
  final Anime anime;

  const DetailScreen({super.key, required this.anime});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar com imagem
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                anime.titleEnglish ?? anime.title,
                style: const TextStyle(
                  shadows: [
                    Shadow(
                      offset: Offset(0, 1),
                      blurRadius: 3.0,
                      color: Colors.black87,
                    ),
                  ],
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  CachedNetworkImage(
                    imageUrl:
                        anime.images.jpg.largeImageUrl ??
                        anime.images.jpg.imageUrl ??
                        '',
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: Colors.grey[300],
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: Colors.grey[300],
                      child: const Icon(Icons.error),
                    ),
                  ),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.black54],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Conteúdo
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Título japonês
                  if (anime.titleJapanese != null)
                    Text(
                      anime.titleJapanese!,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  const SizedBox(height: 16),

                  // Estatísticas
                  _buildStatsRow(context),
                  const SizedBox(height: 16),

                  // Informações básicas
                  _buildInfoCard(context),
                  const SizedBox(height: 16),

                  // Sinopse
                  if (anime.synopsis != null) ...[
                    Text(
                      'Sinopse',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      anime.synopsis!,
                      style: Theme.of(context).textTheme.bodyLarge,
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Background
                  if (anime.background != null &&
                      anime.background!.isNotEmpty) ...[
                    Text(
                      'Background',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      anime.background!,
                      style: Theme.of(context).textTheme.bodyLarge,
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Gêneros
                  if (anime.genres.isNotEmpty) ...[
                    Text(
                      'Gêneros',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: anime.genres
                          .map(
                            (genre) => Chip(
                              label: Text(genre.name),
                              backgroundColor: Colors.blue.shade100,
                            ),
                          )
                          .toList(),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Gêneros explícitos
                  if (anime.explicitGenres.isNotEmpty) ...[
                    Text(
                      'Gêneros Explícitos',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: anime.explicitGenres
                          .map(
                            (genre) => Chip(
                              label: Text(genre.name),
                              backgroundColor: Colors.red.shade100,
                            ),
                          )
                          .toList(),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Temas
                  if (anime.themes.isNotEmpty) ...[
                    Text(
                      'Temas',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: anime.themes
                          .map(
                            (theme) => Chip(
                              label: Text(theme.name),
                              backgroundColor: Colors.purple.shade100,
                            ),
                          )
                          .toList(),
                    ),
                    const SizedBox(height: 16),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildStatItem(
          context,
          icon: Icons.star,
          label: 'Score',
          value: anime.score?.toString() ?? 'N/A',
          color: Colors.amber,
        ),
        _buildStatItem(
          context,
          icon: Icons.people,
          label: 'Membros',
          value: _formatNumber(anime.members),
          color: Colors.blue,
        ),
        _buildStatItem(
          context,
          icon: Icons.favorite,
          label: 'Favoritos',
          value: _formatNumber(anime.favorites),
          color: Colors.red,
        ),
      ],
    );
  }

  Widget _buildStatItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: 32),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }

  Widget _buildInfoCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildInfoRow(context, 'Tipo', anime.type ?? 'N/A'),
            _buildInfoRow(
              context,
              'Episódios',
              anime.episodes?.toString() ?? 'N/A',
            ),
            _buildInfoRow(context, 'Status', anime.status ?? 'N/A'),
            _buildInfoRow(context, 'Duração', anime.duration ?? 'N/A'),
            _buildInfoRow(context, 'Classificação', anime.rating ?? 'N/A'),
            _buildInfoRow(
              context,
              'Temporada',
              anime.season != null && anime.year != null
                  ? '${anime.season} ${anime.year}'
                  : 'N/A',
            ),
            _buildInfoRow(context, 'Ranking', anime.rank?.toString() ?? 'N/A'),
            _buildInfoRow(
              context,
              'Popularidade',
              anime.popularity?.toString() ?? 'N/A',
            ),
            _buildInfoRow(
              context,
              'Avaliado por',
              _formatNumber(anime.scoredBy),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          Flexible(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  String _formatNumber(int? number) {
    if (number == null) return 'N/A';
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toString();
  }
}
