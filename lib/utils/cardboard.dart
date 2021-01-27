import 'package:dashboard/widgets/dialogTypes/movie_dialog.dart';
import 'package:dashboard/widgets/dialogTypes/steam_dialog.dart';
import 'package:dashboard/widgets/dialogTypes/weather_dialog.dart';
import 'package:flutter/material.dart';

class Cardboard extends StatefulWidget {
  Cardboard({this.index, this.type, this.newWidget, this.addUpdateWidget});
  final int index;
  final String type;
  final Widget newWidget;
  final Function addUpdateWidget;

  @override
  _CardboardState createState() => _CardboardState();
}

class _CardboardState extends State<Cardboard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: ConstrainedBox(
        constraints: BoxConstraints(
            minWidth: 200, maxWidth: 300, minHeight: 300, maxHeight: 300),
        child: Card(
          elevation: 15.0,
          color: Colors.white70,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Stack(alignment: Alignment.center, children: [
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: editButton(widget.index, widget.type),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Padding(
                  padding: const EdgeInsets.all(25.0), child: widget.newWidget),
            ),
          ]),
        ),
      ),
    );
  }

  Widget editButton(index, type) {
    return IconButton(
      icon: Icon(Icons.edit),
      color: Colors.blueGrey,
      onPressed: () {
        if (type == 'weather' || type == 'weather5days')
          showDialog(
              context: context,
              builder: (_) => WeatherDialog(
                  addUpdateWidget: widget.addUpdateWidget, index: index));
        else if (type == 'steamUser' || type == 'steamGameNews')
          showDialog(
              context: context,
              builder: (_) =>
                  SteamDialog(addUpdateWidget: widget.addUpdateWidget, index: index));
        else if (type == 'movie' || type == 'tvShow')
          showDialog(
              context: context,
              builder: (_) =>
                  MovieDialog(addUpdateWidget: widget.addUpdateWidget, index: index));
      },
    );
  }
}
