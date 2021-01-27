import 'package:dashboard/model/API_KEYS.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class Movie {
  String queryTitle;
  int responseCode;
  List title = [];
  List releaseDate = [];
  List synopsis = [];
  List tvTitle = [];
  List tvReleaseDate = [];
  List tvSynopsis = [];

  Future fetchSearchTvShows(query) async {
    queryTitle = query;
    String url =
        'https://api.themoviedb.org/3/search/tv?api_key=$MOVIE_API_KEY&language=en-US&page=1&query=$query&include_adult=false';
    var response = await http.get(url);
    responseCode = response.statusCode;

    if (responseCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      int i = 0;
      for (var news in jsonResponse['results']) {
        title.add(news['name'] ?? '');
        releaseDate.add(news['first_air_date'] ?? '');
        synopsis.add(news['overview'] ?? '');
        if (i++ >= 9) break;
      }
      // for (int i = 0; i < tvTitle.length; i++) {
      //   print(i.toString() + ' title: ' + tvTitle[i] ?? 'nothing');
      //   print(i.toString() + ' releaseDate: ' + tvReleaseDate[i] ?? 'nothing');
      //   print(i.toString() + ' synopsis: ' + tvSynopsis[i] ?? 'nothing');
      // }
    }
  }

  Future fetchSearchMovie(query) async {
    queryTitle = query;
    String url =
        'https://api.themoviedb.org/3/search/movie?api_key=$MOVIE_API_KEY&language=en-US&query=$query&page=1&include_adult=false';
    var response = await http.get(url);
    responseCode = response.statusCode;

    if (responseCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      int i = 0;
      for (var news in jsonResponse['results']) {
        title.add(news['title'] ?? '');
        releaseDate.add(news['release_date'] ?? '');
        synopsis.add(news['overview'] ?? '');
        if (i++ >= 9) break;
      }
      // for (int i = 0; i < title.length; i++) {
      // print(i.toString() + ' title: ' + title[i] ?? 'nothing');
      // print(i.toString() + ' releaseDate: ' + releaseDate[i] ?? 'nothing');
      // print(i.toString() + ' synopsis: ' + synopsis[i] ?? 'nothing');
      // print('The movie: $tmpTitle that was released in: $tmpDate.\n Synopsis: $tmpContent');
      // }
    }
  }

  Map<String, dynamic> getMovies() => {
        'type': 'movie',
        'value': queryTitle,
        'responseCode': responseCode,
        'title': title,
        'releaseDate': releaseDate,
        'synopsis': synopsis
      };

  Map<String, dynamic> getTvShows() => {
        'type': 'tvShow',
        'value': queryTitle,
        'responseCode': responseCode,
        'title': title,
        'releaseDate': releaseDate,
        'synopsis': synopsis
      };
}
