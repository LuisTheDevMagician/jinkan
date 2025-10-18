import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/anime.dart';

class ApiService {
  static const String baseUrl = 'https://api.jikan.moe/v4';

  // Buscar lista de animes com paginação
  Future<Map<String, dynamic>> fetchAnimes({
    int page = 1,
    int limit = 10,
    String? query,
  }) async {
    try {
      String url = '$baseUrl/anime?page=$page&limit=$limit';
      if (query != null && query.isNotEmpty) {
        url += '&q=$query';
      }

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<Anime> animes = (data['data'] as List)
            .map((animeJson) => Anime.fromJson(animeJson))
            .toList();

        return {
          'animes': animes,
          'hasNextPage': data['pagination']?['has_next_page'] ?? false,
          'currentPage': data['pagination']?['current_page'] ?? 1,
        };
      } else if (response.statusCode == 429) {
        throw Exception('Muitas requisições. Por favor, aguarde um momento.');
      } else {
        throw Exception('Falha ao carregar animes: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro ao buscar animes: $e');
    }
  }

  // Buscar anime por ID
  Future<Anime> fetchAnimeById(int id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/anime/$id'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Anime.fromJson(data['data']);
      } else if (response.statusCode == 429) {
        throw Exception('Muitas requisições. Por favor, aguarde um momento.');
      } else {
        throw Exception('Falha ao carregar anime: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro ao buscar anime: $e');
    }
  }
}
