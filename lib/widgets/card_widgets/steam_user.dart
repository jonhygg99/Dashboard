import 'package:dashboard/utils/button_link_launch.dart';
import 'package:dashboard/utils/cardboard.dart';
import 'package:flutter/material.dart';

class SteamUserCard extends StatelessWidget {
  SteamUserCard({this.value, this.index, this.addUpdateWidget});
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
              value['name'],
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20.0),
            Text(
              getStatus(),
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20.0),
            ButtonLinkLaunch(value['personUrl']),
          ],
        ),
      ),
    );
  }

  String getStatus() {
    switch (value['state']) {
      case 0:
        return 'Offline';
      case 1:
        return 'Online';
      case 2:
        return 'Busy';
      case 3:
        return 'Away';
      case 4:
        return 'Snooze';
      case 5:
        return 'Looking to trade';
      case 6:
        return 'Looking to play';
      default:
        return 'No status identified';
    }
  }
}
