# Jikan Anime App

Aplicativo Flutter para explorar animes usando a API Jikan (MyAnimeList).

# LINKS:

Linkedin: https://www.linkedin.com/pulse/consumo-de-api-com-flutter-luis-eduardo-aifhf/

Youtube: https://youtu.be/j1Kd66gZ-B8

## 📱 Funcionalidades

- **Splash Screen**: Tela inicial com logo animada
- **Lista de Animes**: Exibição paginada de 10 animes por página
- **Busca**: Barra de busca para filtrar animes remotamente
- **Detalhes**: Tela completa com informações detalhadas do anime
- **Tema Claro/Escuro**: Alternância entre temas com persistência
- **Tratamento de Erros**: Indicadores de carregamento e mensagens de erro com opção de tentar novamente
- **Pull to Refresh**: Atualização da lista puxando para baixo

## 🏗️ Estrutura do Projeto

```
lib/
├── models/          # Modelos de dados
│   └── anime.dart
├── providers/       # Gerenciamento de estado (Provider)
│   ├── anime_provider.dart
│   └── theme_provider.dart
├── screens/         # Telas do aplicativo
│   ├── splash_screen.dart
│   ├── home_screen.dart
│   └── detail_screen.dart
├── services/        # Serviços de API
│   └── api_service.dart
├── widgets/         # Widgets reutilizáveis
│   ├── anime_card.dart
│   └── search_bar_widget.dart
└── main.dart        # Ponto de entrada
```

## 📋 Informações Exibidas

### Lista Principal
- Imagem do anime
- Título em inglês
- Título em japonês
- Tipo (TV, Movie, etc)
- Fonte
- Número de episódios
- Status

### Tela de Detalhes
- Duração
- Classificação
- Score
- Número de pessoas que avaliaram
- Ranking
- Popularidade
- Membros
- Favoritos
- Sinopse
- Background
- Temporada e ano
- Gêneros
- Gêneros explícitos
- Temas

## 🚀 Como Executar

1. **Instalar dependências**:
```bash
flutter pub get
```

2. **Executar o app**:
```bash
flutter run
```

## 📦 Dependências

- **provider**: Gerenciamento de estado
- **http**: Requisições HTTP
- **shared_preferences**: Persistência de preferências
- **cached_network_image**: Cache de imagens

## 🎨 Temas

O app suporta tema claro e escuro, com alternância através do botão no AppBar. A preferência é salva localmente e restaurada ao reiniciar o app.

## 🌐 API

Este app utiliza a [Jikan API](https://jikan.moe/) - uma API não oficial do MyAnimeList.

**Endpoint principal**: `https://api.jikan.moe/v4/anime`

## ⚠️ Observações

- A API Jikan tem limite de requisições. Em caso de erro 429, aguarde alguns segundos.
- As imagens são carregadas de URLs externas e ficam em cache.
