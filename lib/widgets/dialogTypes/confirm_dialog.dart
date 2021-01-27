import 'package:flutter/material.dart';

class ConfirmDialog extends StatefulWidget {
  ConfirmDialog({this.logOut, this.isGoogle});
  final Function logOut;
  final bool isGoogle;
  @override
  _ConfirmDialogState createState() => _ConfirmDialogState();
}

class _ConfirmDialogState extends State<ConfirmDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 15.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10.0),
        ),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
            maxWidth: 100, minWidth: 100, maxHeight: 140, minHeight: 140),
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            children: [
              Text('Are you sure you want to log out?'),
              const SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [buttonConfirm('No'), buttonConfirm('Yes')],
              )
            ],
          ),
        ),
      ),
    );
  }

  Flexible buttonConfirm(type) {
    return Flexible(
      flex: 1,
      child: FlatButton(
        minWidth: 100,
        color: type == 'Yes' ? Colors.red : Colors.blueGrey[800],
        hoverColor: type == 'Yes' ? Colors.redAccent : Colors.blueGrey[900],
        highlightColor: type == 'Yes' ? Colors.redAccent[900] : Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
        onPressed: type == 'Yes'
            ? () {
                widget.logOut(widget.isGoogle);
                Navigator.pop(context);
              }
            : () => Navigator.pop(context),
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Text(
            type,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
