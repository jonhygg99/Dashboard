import 'package:dashboard/utils/cardboard.dart';
import 'package:flutter/material.dart';

class Weather5daysCard extends StatelessWidget {
  Weather5daysCard({this.value, this.index, this.addUpdateWidget});
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
            Text('The next 5 day forecast in'),
            const SizedBox(height: 10.0),
            Text(
              value['place'],
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  value['temperature'].toString() + 'º',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  value['wind'].toString() + 'm/s',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30.0),
            Text('The sky is ' + value['description']),
          ],
        ),
      ),
    );
  }
}
