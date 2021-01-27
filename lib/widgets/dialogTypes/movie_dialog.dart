import 'package:dashboard/model/movie.dart';
import 'package:dashboard/model/weather.dart';
import 'package:dashboard/utils/custom_text_field.dart';
import 'package:flutter/material.dart';

class MovieDialog extends StatefulWidget {
  MovieDialog({this.addUpdateWidget, this.index});
  final Function addUpdateWidget;
  final int index;
  @override
  _MovieDialogState createState() => _MovieDialogState();
}

class _MovieDialogState extends State<MovieDialog> {
  TextEditingController _textController;
  bool _isMovie = true;
  bool _submit = false;
  Movie movie = Movie();
  Map<String, dynamic> movieInfo;
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
                  'Movie',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35),
                ),
              ),
              const SizedBox(height: 20.0),
              Center(child: Text('What do you wanna see?')),
              const SizedBox(height: 20.0),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                optionButtons('Movie', _isMovie),
                optionButtons('TV Show', !_isMovie)
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
                  hintText: _isMovie ? 'Movie' : 'TV Show',
                  errorText: _submit
                      ? _validateMovieTvShow(_textController.text) // on Submit
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

  String _validateMovieTvShow(value) {
    value = value.trim();
    final String type = _isMovie ? 'movie' : 'tv show';

    if (_textController.text != null) {
      if (value.isEmpty) {
        return 'The $type can\'t be empty';
      }
      if (_submit && movieInfo['responseCode'] != 200) {
        return 'Enter a correct $type';
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
                setState(() => _isFetching = true);
                if (_isMovie) {
                  await movie
                      .fetchSearchMovie(_textController.text)
                      .then((_) => movieInfo = movie.getMovies());
                } else {
                  await movie
                      .fetchSearchTvShows(_textController.text)
                      .then((_) => movieInfo = movie.getTvShows());
                }
                if (movieInfo != null && movieInfo['responseCode'] == 200) {
                  widget.addUpdateWidget(movieInfo, widget.index);
                  Navigator.pop(context);
                } else {
                  _submit = true;
                }
                setState(() => _isFetching = false);
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
      color: isActive ? Colors.blue : Colors.blueGrey,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      onPressed: () {
        setState(() {
          if ((type == 'Movie' && !isActive) ||
              (type == 'TV Show' && !isActive)) _isMovie = !_isMovie;
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
