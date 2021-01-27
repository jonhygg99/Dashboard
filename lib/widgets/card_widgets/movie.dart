import 'package:carousel_slider/carousel_slider.dart';
import 'package:dashboard/utils/button_link_launch.dart';
import 'package:dashboard/utils/cardboard.dart';
import 'package:flutter/material.dart';

class MovieCard extends StatefulWidget {
  MovieCard({this.value, this.index, this.addUpdateWidget});
  final Map value;
  final int index;
  final Function addUpdateWidget;
  @override
  _MovieCardState createState() => _MovieCardState();
}

class _MovieCardState extends State<MovieCard> {
  int _currentIndexDot = 0;
  final CarouselController _controller = CarouselController();

  @override
  Widget build(BuildContext context) {
    return Cardboard(
      index: widget.index,
      type: widget.value['type'],
      addUpdateWidget: widget.addUpdateWidget,
      newWidget: Column(
        children: [
          CarouselSlider(
            items: createSteamNewsContainer(widget.value),
            carouselController: _controller,
            options: CarouselOptions(
              height: 210.0,
              enlargeCenterPage: true,
              viewportFraction: 1.0,
              onPageChanged: (index, _) {
                setState(() {
                  _currentIndexDot = index;
                });
              },
            ),
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: createDots()),
        ],
      ),
    );
  }

  List<Widget> createDots() {
    List<Widget> widgets = [];

    for (int i = 0; i < widget.value['title'].length; ++i) {
      widgets.add(Container(
        width: 8.0,
        height: 8.0,
        margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: _currentIndexDot == i
              ? Color.fromRGBO(0, 0, 0, 0.9)
              : Color.fromRGBO(0, 0, 0, 0.4),
        ),
        child: FlatButton(
          onPressed: () => _controller.animateToPage(i),
          child: null,
        ),
      ));
    }
    return widgets;
  }

  List<Widget> createSteamNewsContainer(value) {
    List<Widget> widgets = [];

    for (int i = 0; i < value['title'].length; ++i) {
      widgets.add(SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text(
                value['title'][i],
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20.0),
            Text(value['releaseDate'][i]),
            const SizedBox(height: 20.0),
            Text(value['synopsis'][i]),
          ],
        ),
      ));
    }
    return widgets;
  }
}
