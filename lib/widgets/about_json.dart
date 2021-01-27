import 'package:flutter/material.dart';
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;

class AboutJson extends StatefulWidget {
  @override
  _AboutJsonState createState() => _AboutJsonState();
}

class _AboutJsonState extends State<AboutJson> {
  String json = "Fetching...";

  @override
  void initState() {
    getAboutJson();
    getIp();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body:
        SingleChildScrollView(child: Text(json)),
      ),
    );
  }

  Future<void> getAboutJson() async {
    try {
      json = await rootBundle.loadString('../assets/json/about.json');
      String ip = await getIp();
      json = json.replaceFirst('10.101.53.35', ip);
      json = json.replaceFirst('1531680780', DateTime.now().millisecondsSinceEpoch.toString());
      setState(() {});
    } catch (_) {
      print("Could not load about json");
    }
  }
}

Future<String> getIp() async {
  try {
    const String url = 'https://api.ipify.org';
    var response = await http.get(url);

    if (response.statusCode == 200) {
      // print(response.body);
      return response.body;
    } else {
      // print(response.body);
      return null;
    }
  } catch (exception) {
    print(exception);
    return null;
  }
}
