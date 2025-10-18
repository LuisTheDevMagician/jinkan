class Anime {
  final int malId;
  final String? url;
  final AnimeImages images;
  final String title;
  final String? titleEnglish;
  final String? titleJapanese;
  final String? type;
  final String? source;
  final int? episodes;
  final String? status;
  final String? duration;
  final String? rating;
  final double? score;
  final int? scoredBy;
  final int? rank;
  final int? popularity;
  final int? members;
  final int? favorites;
  final String? synopsis;
  final String? background;
  final String? season;
  final int? year;
  final List<Genre> genres;
  final List<Genre> explicitGenres;
  final List<Genre> themes;

  Anime({
    required this.malId,
    this.url,
    required this.images,
    required this.title,
    this.titleEnglish,
    this.titleJapanese,
    this.type,
    this.source,
    this.episodes,
    this.status,
    this.duration,
    this.rating,
    this.score,
    this.scoredBy,
    this.rank,
    this.popularity,
    this.members,
    this.favorites,
    this.synopsis,
    this.background,
    this.season,
    this.year,
    this.genres = const [],
    this.explicitGenres = const [],
    this.themes = const [],
  });

  factory Anime.fromJson(Map<String, dynamic> json) {
    return Anime(
      malId: json['mal_id'] ?? 0,
      url: json['url'],
      images: AnimeImages.fromJson(json['images'] ?? {}),
      title: json['title'] ?? 'Unknown',
      titleEnglish: json['title_english'],
      titleJapanese: json['title_japanese'],
      type: json['type'],
      source: json['source'],
      episodes: json['episodes'],
      status: json['status'],
      duration: json['duration'],
      rating: json['rating'],
      score: json['score']?.toDouble(),
      scoredBy: json['scored_by'],
      rank: json['rank'],
      popularity: json['popularity'],
      members: json['members'],
      favorites: json['favorites'],
      synopsis: json['synopsis'],
      background: json['background'],
      season: json['season'],
      year: json['year'],
      genres:
          (json['genres'] as List?)?.map((g) => Genre.fromJson(g)).toList() ??
          [],
      explicitGenres:
          (json['explicit_genres'] as List?)
              ?.map((g) => Genre.fromJson(g))
              .toList() ??
          [],
      themes:
          (json['themes'] as List?)?.map((g) => Genre.fromJson(g)).toList() ??
          [],
    );
  }
}

class AnimeImages {
  final ImageUrls jpg;
  final ImageUrls? webp;

  AnimeImages({required this.jpg, this.webp});

  factory AnimeImages.fromJson(Map<String, dynamic> json) {
    return AnimeImages(
      jpg: ImageUrls.fromJson(json['jpg'] ?? {}),
      webp: json['webp'] != null ? ImageUrls.fromJson(json['webp']) : null,
    );
  }
}

class ImageUrls {
  final String? imageUrl;
  final String? smallImageUrl;
  final String? largeImageUrl;

  ImageUrls({this.imageUrl, this.smallImageUrl, this.largeImageUrl});

  factory ImageUrls.fromJson(Map<String, dynamic> json) {
    return ImageUrls(
      imageUrl: json['image_url'],
      smallImageUrl: json['small_image_url'],
      largeImageUrl: json['large_image_url'],
    );
  }
}

class Genre {
  final int malId;
  final String type;
  final String name;
  final String url;

  Genre({
    required this.malId,
    required this.type,
    required this.name,
    required this.url,
  });

  factory Genre.fromJson(Map<String, dynamic> json) {
    return Genre(
      malId: json['mal_id'] ?? 0,
      type: json['type'] ?? '',
      name: json['name'] ?? '',
      url: json['url'] ?? '',
    );
  }
}
