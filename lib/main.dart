import 'package:dashboard/widgets/card_widgets/movie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'model/DataClass.dart';
import 'model/firebase.dart';
import 'model/movie.dart';
import 'utils/authentication.dart';
import 'widgets/about_json.dart';
import 'widgets/add_widget_floating_button.dart';
import 'widgets/card_widgets/steam_user.dart';
import 'widgets/card_widgets/weather_5_days.dart';
import 'widgets/dialogTypes/auth_dialog.dart';
import 'widgets/card_widgets/steam_games_news.dart';
import 'widgets/card_widgets/weather.dart';
import 'widgets/dialogTypes/confirm_dialog.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dashboard',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => MyHomePage(),
        '/about.json': (context) => AboutJson()
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Map<String, dynamic> _userInfo;
  Map<String, dynamic> map;
  String _email;
  bool isGoogle = false;
  DataClass _dataClass = DataClass();
  // FirebaseDB firebase = FirebaseDB();

  @override
  void initState() {
    getUserLog();
    // firebase.createData('test', {'test1': 'messageTestWorking'});
    // firebase.readData('test');
    // firebase.deleteData('test');
    Movie movie = Movie();
    // movie.fetchSearchMovie('Mission');
    movie.fetchSearchTvShows('Ben');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    refresh();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Dashboard'),
          // centerTitle: true,
          actions: <Widget>[
            Center(
              child: _email != null
                  ? Text(_email)
                  : blackContainerText('Not connected'),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 5.0, horizontal: 40.0),
              child: FlatButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (_) => _email != null
                          ? ConfirmDialog(logOut: logout, isGoogle: isGoogle)
                          : AuthDialog(cleanWidgets));
                },
                color: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                child: _email != null
                    ? blackContainerText('Logout')
                    : Text(
                        'Login/Sign Up',
                        style: TextStyle(color: Colors.white),
                      ),
              ),
            ),
          ],
        ),
        floatingActionButton: AddWidgetFloatingButton(addUpdateWidget),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: createWidgetAPIs(),
          ),
        ),
      ),
    );
  }

  refresh() {
    getUserLog();
  }

  String getEmailLogged() {
    _email = getEmail();
    _userInfo = getUserInfo();
    isGoogle = _userInfo['isGoogle'];
    Future.delayed(const Duration(hours: 2), () {
      setState(() {
        _dataClass.updateWidgetData();
      });
    });
    setState(() {});
    return _email;
  }

  Future getUserLog() async {
    await getUser().then((_) {
      _email = getEmailLogged();
      _userInfo = getUserInfo();
      isGoogle = _userInfo['isGoogle'] ?? false;
    });
  }

  Container blackContainerText(value) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: Colors.blueGrey,
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Text(
          value,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  void cleanWidgets() {
    _dataClass.clearWidgetData();
    setState(() {});
  }

  void logout(isGoogleSign) {
    isGoogleSign ? signOutGoogle() : signOut();
    cleanWidgets();
  }

  void addUpdateWidget(mapData, index) {
    if (index == -1)
      _dataClass.addWidget(mapData);
    else
      _dataClass.updateWidget(mapData, index);
    setState(() {});
  }

  Wrap createWidgetAPIs() {
    List<Widget> widgets = [];
    List<Map<String, dynamic>> widgetsClass = _dataClass.getWidgetData();
    int index = 0;

    widgetsClass.forEach((value) {
      if (value['type'] == 'weather')
        widgets.add(WeatherCard(value: value, index: index, addUpdateWidget: addUpdateWidget));
      else if (value['type'] == 'weather5days')
        widgets.add(Weather5daysCard(value: value, index: index, addUpdateWidget: addUpdateWidget));
      else if (value['type'] == 'steamUser')
        widgets.add(SteamUserCard(value: value, index: index, addUpdateWidget: addUpdateWidget));
      else if (value['type'] == 'steamGameNews')
        widgets.add(SteamGameNewsCard(value: value, index: index, addUpdateWidget: addUpdateWidget));
      else if (value['type'] == 'movie' || value['type'] == 'tvShow')
        widgets.add(MovieCard(value: value, index: index, addUpdateWidget: addUpdateWidget));
      index++;
    });

    return Wrap(alignment: WrapAlignment.start, children: widgets);
  }
}
