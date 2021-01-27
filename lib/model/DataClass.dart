import 'movie.dart';
import 'steam.dart';
import 'weather.dart';

class DataClass {
  List<Map<String, dynamic>> _widgetsClass = [];
  Weather _weather = Weather();
  Steam _steam = Steam();
  Movie _movie = Movie();

  void addWidget(mapData) => _widgetsClass.add(mapData);

  void updateWidget(mapData, index) => _widgetsClass[index] = mapData;

  List<Map<String, dynamic>> getWidgetData() => _widgetsClass;

  void clearWidgetData() => _widgetsClass.clear();

  void updateWidgetData() async {
    for (var w in _widgetsClass) {
      print(w['value']);
      if (w['type'] == 'weather') {
        await _weather
            .fetchWeather(w['value'])
            .then((_) => w = _weather.getWeather());
      } else if (w['type'] == 'weather5days') {
        await _weather
            .fetchFiveDayForecast(w['value'])
            .then((_) => w = _weather.getFiveDayForecast());
      } else if (w['type'] == 'steamUser') {
        await _steam.fetchUser(w['value'])
            .then((_) => w = _steam.getUser());
      } else if (w['type'] == 'steamGameNews') {
        await _steam
            .fetchGameNews(w['value'])
            .then((_) => w = _steam.getGameNews());
      } else if (w['type'] == 'movie') {
        await _movie
            .fetchSearchMovie(w['value'])
            .then((_) => w = _movie.getMovies());
      } else if (w['type'] == 'tvShow') {
        await _movie
            .fetchSearchTvShows(w['value'])
            .then((_) => w = _movie.getTvShows());
      }
    }
  }
}
