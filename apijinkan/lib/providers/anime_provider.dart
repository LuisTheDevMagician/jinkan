import 'package:flutter/material.dart';
import '../models/anime.dart';
import '../services/api_service.dart';

class AnimeProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<Anime> _animes = [];
  bool _isLoading = false;
  bool _hasError = false;
  String _errorMessage = '';
  int _currentPage = 1;
  bool _hasNextPage = true;
  String _searchQuery = '';

  List<Anime> get animes => _animes;
  bool get isLoading => _isLoading;
  bool get hasError => _hasError;
  String get errorMessage => _errorMessage;
  bool get hasNextPage => _hasNextPage;
  bool get hasPreviousPage => _currentPage > 1;
  int get currentPage => _currentPage;
  String get searchQuery => _searchQuery;

  // Buscar animes (primeira página ou busca)
  Future<void> fetchAnimes({String? query, bool refresh = false}) async {
    if (refresh) {
      _currentPage = 1;
      _hasNextPage = true;
    }

    if (query != null) {
      _searchQuery = query;
      _currentPage = 1;
      _hasNextPage = true;
    }

    _isLoading = true;
    _hasError = false;
    _errorMessage = '';
    notifyListeners();

    try {
      final result = await _apiService.fetchAnimes(
        page: _currentPage,
        limit: 10,
        query: _searchQuery.isEmpty ? null : _searchQuery,
      );

      _animes = result['animes'] as List<Anime>;
      _hasNextPage = result['hasNextPage'] as bool;
      _currentPage = result['currentPage'] as int;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _hasError = true;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  // Carregar próxima página
  Future<void> loadNextPage() async {
    if (!_hasNextPage || _isLoading) return;

    _currentPage++;
    await fetchAnimes();
  }

  // Carregar página anterior
  Future<void> loadPreviousPage() async {
    if (_currentPage <= 1 || _isLoading) return;

    _currentPage--;
    await fetchAnimes();
  }

  // Limpar busca
  void clearSearch() {
    _searchQuery = '';
    _currentPage = 1;
    _animes = [];
    _hasNextPage = true;
    fetchAnimes(refresh: true);
  }

  // Tentar novamente após erro
  Future<void> retry() async {
    await fetchAnimes(refresh: true);
  }
}
