import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ButtonLinkLaunch extends StatelessWidget {
  ButtonLinkLaunch(this.url);
  final String url;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      color: Colors.blue,
      hoverColor: Colors.lightBlue,
      highlightColor: Colors.lightBlueAccent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25.0),
      ),
      onPressed: () {
        _launchInBrowser(url);
      },
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Text(
          'Go to page',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Future<void> _launchInBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
