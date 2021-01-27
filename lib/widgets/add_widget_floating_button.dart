import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'dialogTypes/movie_dialog.dart';
import 'dialogTypes/steam_dialog.dart';
import 'dialogTypes/weather_dialog.dart';

class AddWidgetFloatingButton extends StatefulWidget {
  AddWidgetFloatingButton(this.addUpdateWidget);
  final Function addUpdateWidget;

  @override
  _AddWidgetFloatingButtonState createState() =>
      _AddWidgetFloatingButtonState();
}

class _AddWidgetFloatingButtonState extends State<AddWidgetFloatingButton>
    with SingleTickerProviderStateMixin {
  bool isOpened = false;
  AnimationController _animationController;
  Animation<Color> _buttonColor;
  Animation<double> _animateIcon;
  Animation<double> _translateButton;
  Curve _curve = Curves.easeOut;
  double _fabHeight = 56.0;

  @override
  initState() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500))
          ..addListener(() {
            setState(() {});
          });
    _animateIcon =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _buttonColor = ColorTween(
      begin: Colors.blue,
      end: Colors.red,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.00,
        1.00,
        curve: Curves.linear,
      ),
    ));
    _translateButton = Tween<double>(
      begin: _fabHeight,
      end: -14.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.0,
        0.75,
        curve: _curve,
      ),
    ));
    super.initState();
  }

  @override
  dispose() {
    _animationController.dispose();
    super.dispose();
  }

  animate() {
    if (!isOpened) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
    isOpened = !isOpened;
  }

  Widget movie() {
    return Container(
      child: FloatingActionButton(
        onPressed: () => showDialog(
            context: context,
            builder: (_) =>
                MovieDialog(addUpdateWidget: widget.addUpdateWidget, index: -1)),
        tooltip: 'Movie & TV Shows',
        child: Icon(Icons.movie),
      ),
    );
  }

  Widget weather() {
    return Container(
      child: FloatingActionButton(
        onPressed: () => showDialog(
            context: context,
            builder: (_) => WeatherDialog(
                addUpdateWidget: widget.addUpdateWidget, index: -1)),
        tooltip: 'Weather',
        child: FaIcon(FontAwesomeIcons.cloudSun),
      ),
    );
  }

  Widget steam() {
    return Container(
      child: FloatingActionButton(
        onPressed: () => showDialog(
            context: context,
            builder: (_) => SteamDialog(
                addUpdateWidget: widget.addUpdateWidget, index: -1)),
        tooltip: 'Steam',
        child: FaIcon(FontAwesomeIcons.steam),
      ),
    );
  }

  Widget toggle() {
    return Container(
      child: FloatingActionButton(
        backgroundColor: _buttonColor.value,
        onPressed: animate,
        tooltip: 'Toggle',
        child: AnimatedIcon(
          icon: AnimatedIcons.menu_close,
          progress: _animateIcon,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Transform(
          transform: Matrix4.translationValues(
            0.0,
            _translateButton.value * 3.0,
            0.0,
          ),
          child: movie(),
        ),
        Transform(
          transform: Matrix4.translationValues(
            0.0,
            _translateButton.value * 2.0,
            0.0,
          ),
          child: weather(),
        ),
        Transform(
          transform: Matrix4.translationValues(
            0.0,
            _translateButton.value,
            0.0,
          ),
          child: steam(),
        ),
        toggle(),
      ],
    );
  }
}
