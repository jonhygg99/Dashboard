import 'package:dashboard/model/API_KEYS.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class Steam {
  String id;
  int responseCode;
  List title = [];
  List newsUrl = [];
  List content = [];
  int state;
  String name;
  String personUrl;

  Future fetchUser(userId) async {
    id = userId;
    String url =
        'https://cors-anywhere.herokuapp.com/http://api.steampowered.com/ISteamUser/GetPlayerSummaries/v0002/?key=$STEAM_KEY&steamids=$userId';
    //he user's current status. 0 - Offline, 1 - Online, 2 - Busy, 3 - Away, 4 - Snooze, 5 - looking to trade, 6 - looking to play.
    // If the player's profile is private, this will always be "0", except if the user has set their status to looking to trade or looking to play,
    // because a bug makes those status appear even if the profile is private.
    var response = await http.get(url);
    responseCode = response.statusCode;
    if (responseCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      state = jsonResponse['response']['players'][0]['personastate'];
      name = jsonResponse['response']['players'][0]['personaname'];
      personUrl = jsonResponse['response']['players'][0]['profileurl'];
      print('$name is: $state. To know more go to $personUrl');
      // print(response.body);
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  Future fetchGameNews(appId) async {
    id = appId;
    String url =
        'https://cors-anywhere.herokuapp.com/http://api.steampowered.com/ISteamNews/GetNewsForApp/v0002/?appid=$appId&count=3&maxlength=100&format=json';
    var response = await http.get(url);
    responseCode = response.statusCode;

    if (responseCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      int i = 0;

      for (var news in jsonResponse['appnews']['newsitems']) {
        title.add(news['title']);
        newsUrl.add(news['url']);
        content.add(news['contents']);
        if (i++ > 1) break;
      }
      // print('$title\n');
      // print('$newsUrl\n');
      // print('$content\n');
    }
  }

  Map<String, dynamic> getUser() => {
        'type': 'steamUser',
        'value': id,
        'responseCode': responseCode,
        'state': state,
        'name': name,
        'personUrl': personUrl
      };

  Map<String, dynamic> getGameNews() => {
        'type': 'steamGameNews',
        'value': id,
        'responseCode': responseCode,
        'title': title,
        'newsUrl': newsUrl,
        'content': content
      };
}

class SummaryGames {
  SummaryGames();
}
