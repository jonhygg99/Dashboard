import 'package:dashboard/model/steam.dart';
import 'package:dashboard/model/weather.dart';
import 'package:dashboard/utils/custom_text_field.dart';
import 'package:flutter/material.dart';

class SteamDialog extends StatefulWidget {
  SteamDialog({this.addUpdateWidget, this.index});
  final Function addUpdateWidget;
  final int index;
  @override
  _SteamDialogState createState() => _SteamDialogState();
}

class _SteamDialogState extends State<SteamDialog> {
  TextEditingController _textController;
  bool _isUser = true;
  bool _submit = false;
  Steam steam = Steam();
  Map<String, dynamic> steamData;
  bool _isFetching = false;

  @override
  void initState() {
    _textController = TextEditingController();
    _textController.text = null;
    super.initState();
  }

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
            minWidth: 470, maxWidth: 470, minHeight: 350, maxHeight: 350),
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            children: [
              Center(
                child: Text(
                  'Steam',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35),
                ),
              ),
              const SizedBox(height: 20.0),
              Center(child: Text('What Steam data you wanna see?')),
              const SizedBox(height: 20.0),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                optionButtons('User profile', _isUser),
                optionButtons('Game news', !_isUser)
              ]),
              const SizedBox(height: 20.0),
              customTextField(
                  inputType: TextInputType.name,
                  controller: _textController,
                  onChange: (value) {
                    setState(() {
                      _submit = false;
                    });
                  },
                  hintText: _isUser ? 'User ID' : 'Game ID',
                  errorText: _submit
                      ? _validateSteamGameNews(
                          _textController.text) // on Submit
                      : null,
                  widgetMaxSize: 100.0),
              const SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // buttonConfirmation('Cancel'),
                  buttonConfirmation('Confirm')
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _validateSteamGameNews(value) {
    value = value.trim();
    String id = _isUser ? 'user' : 'game';

    if (_textController.text != null) {
      if (value.isEmpty) {
        return 'The ' + id + 'ID can\'t be empty';
      }
      if (_submit && steamData['responseCode'] != 200) {
        return 'Enter a correct ' + id + 'ID';
      } else
        _submit = false;
    }
    return null;
  }

  Flexible buttonConfirmation(type) {
    return Flexible(
      flex: 1,
      child: FlatButton(
        minWidth: 150,
        color: Colors.blueGrey[800],
        hoverColor: Colors.blueGrey[900],
        highlightColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
        onPressed: type == 'Confirm'
            ? () async {
                setState(() {
                  _isFetching = true;
                });
                if (_isUser) {
                  await steam
                      .fetchUser(_textController.text)
                      .then((_) => steamData = steam.getUser());
                } else {
                  await steam
                      .fetchGameNews(_textController.text)
                      .then((_) => steamData = steam.getGameNews());
                }
                if (steamData != null &&
                    steamData['responseCode'] == 200) {
                  widget.addUpdateWidget(steamData, widget.index);
                  Navigator.pop(context);
                } else
                  _submit = true;
                setState(() {
                  _isFetching = false;
                });
              }
            : () => Navigator.pop(context),
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: _isFetching
              ? SizedBox(
                  height: 16,
                  width: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Text(
                  type,
                  style: TextStyle(color: Colors.white),
                ),
        ),
      ),
    );
  }

  Widget optionButtons(type, isActive) {
    return FlatButton(
      color: isActive ? Colors.blue: Colors.blueGrey,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      onPressed: () {
        setState(() {
          if ((type == 'User profile' && !isActive) || (type == 'Game news' && !isActive) )
            _isUser = !_isUser;
        });
      },
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Text(
          type,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
