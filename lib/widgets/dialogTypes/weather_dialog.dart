import 'package:dashboard/model/weather.dart';
import 'package:dashboard/utils/custom_text_field.dart';
import 'package:flutter/material.dart';

class WeatherDialog extends StatefulWidget {
  WeatherDialog({this.addUpdateWidget, this.index});
  final Function addUpdateWidget;
  final int index;
  @override
  _WeatherDialogState createState() => _WeatherDialogState();
}

class _WeatherDialogState extends State<WeatherDialog> {
  TextEditingController _textController;
  bool _isCurrentWeather = true;
  bool _submit = false;
  Weather weather = Weather();
  Map<String, dynamic> weatherInfo;
  bool _isfetching = false;

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
                  'Weather',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35),
                ),
              ),
              const SizedBox(height: 20.0),
              Center(child: Text('What place do you wanna see the weather?')),
              const SizedBox(height: 20.0),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                optionButtons('Current weather', _isCurrentWeather),
                optionButtons(
                    'Next 5 day weather prediction', !_isCurrentWeather)
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
                  hintText: 'Place',
                  errorText: _submit
                      ? _validateWeatherPlace(_textController.text) // on Submit
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

  String _validateWeatherPlace(value) {
    value = value.trim();

    if (_textController.text != null) {
      if (value.isEmpty) {
        return 'The place can\'t be empty';
      }
      if (_submit && weatherInfo['responseCode'] != 200) {
        return 'Enter a correct place';
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
                setState(() => _isfetching = true);
                if (_isCurrentWeather) {
                  await weather
                      .fetchWeather(_textController.text)
                      .then((_) => weatherInfo = weather.getWeather());
                } else {
                  await weather
                      .fetchFiveDayForecast(_textController.text)
                      .then((_) => weatherInfo = weather.getFiveDayForecast());
                }
                if (weatherInfo != null && weatherInfo['responseCode'] == 200) {
                  widget.addUpdateWidget(weatherInfo, widget.index);
                  Navigator.pop(context);
                } else
                  _submit = true;
                setState(() => _isfetching = false);
              }
            : () => Navigator.pop(context),
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: _isfetching
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
      color: isActive ? Colors.blue : Colors.blueGrey,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      onPressed: () {
        setState(() {
          if ((type == 'Current weather' && !isActive) ||
              (type == 'Next 5 day weather prediction' && !isActive))
            _isCurrentWeather = !_isCurrentWeather;
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
