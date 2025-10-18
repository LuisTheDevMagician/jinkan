import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/anime_provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/anime_card.dart';
import '../widgets/search_bar_widget.dart';
import 'detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Carregar animes inicialmente
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AnimeProvider>(context, listen: false).fetchAnimes();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final animeProvider = Provider.of<AnimeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Jikan Anime'),
        actions: [
          IconButton(
            icon: Icon(
              themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
            ),
            onPressed: () {
              themeProvider.toggleTheme();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Barra de busca
          SearchBarWidget(
            controller: _searchController,
            onSearch: (query) {
              animeProvider.fetchAnimes(query: query, refresh: true);
            },
            onClear: () {
              _searchController.clear();
              animeProvider.clearSearch();
            },
          ),

          // Lista de animes
          Expanded(
            child: animeProvider.hasError
                ? _buildErrorWidget(animeProvider)
                : animeProvider.animes.isEmpty && animeProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : animeProvider.animes.isEmpty
                ? const Center(child: Text('Nenhum anime encontrado'))
                : Column(
                    children: [
                      Expanded(
                        child: RefreshIndicator(
                          onRefresh: () =>
                              animeProvider.fetchAnimes(refresh: true),
                          child: ListView.builder(
                            padding: const EdgeInsets.all(8),
                            itemCount: animeProvider.animes.length,
                            itemBuilder: (context, index) {
                              final anime = animeProvider.animes[index];
                              return AnimeCard(
                                anime: anime,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          DetailScreen(anime: anime),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ),
                      // Botões de paginação
                      _buildPaginationButtons(animeProvider),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaginationButtons(AnimeProvider provider) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Botão Anterior
          ElevatedButton.icon(
            onPressed: provider.hasPreviousPage && !provider.isLoading
                ? () => provider.loadPreviousPage()
                : null,
            icon: const Icon(Icons.arrow_back),
            label: const Text('Anterior'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
          ),

          // Indicador de página
          if (provider.isLoading)
            const CircularProgressIndicator()
          else
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'Página ${provider.currentPage}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),

          // Botão Próxima
          ElevatedButton.icon(
            onPressed: provider.hasNextPage && !provider.isLoading
                ? () => provider.loadNextPage()
                : null,
            icon: const Icon(Icons.arrow_forward),
            label: const Text('Próxima'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget(AnimeProvider provider) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Erro ao carregar animes',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              provider.errorMessage,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => provider.retry(),
              icon: const Icon(Icons.refresh),
              label: const Text('Tentar Novamente'),
            ),
          ],
        ),
      ),
    );
  }
}
