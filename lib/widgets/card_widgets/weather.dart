import 'package:dashboard/utils/cardboard.dart';
import 'package:flutter/material.dart';

class WeatherCard extends StatelessWidget {
  WeatherCard({this.value, this.index, this.addUpdateWidget});
  final Map value;
  final int index;
  final Function addUpdateWidget;

  @override
  Widget build(BuildContext context) {
    return Cardboard(
      index: index,
      type: value['type'],
      addUpdateWidget: addUpdateWidget,
      newWidget: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              value['place'],
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20.0),
            Text(
              value['temperature'].toString() + 'º',
              style: TextStyle(
                fontSize: 70,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20.0),
            Text('The sky is ' + value['description']),
          ],
        ),
      ),
    );
  }
}
