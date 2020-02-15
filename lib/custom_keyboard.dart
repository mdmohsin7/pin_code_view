import 'package:flutter/material.dart';

class CustomKeyboard extends StatefulWidget {
  final Function onBackPressed, onPressedKey;
  final TextStyle textStyle;
  final double width;
  final double numPadMaxSize;
  final bool showLetters;
  final BoxDecoration keyDecoration;

  CustomKeyboard({
    this.onBackPressed,
    this.onPressedKey,
    this.textStyle,
    this.width,
    this.numPadMaxSize,
    this.keyDecoration,
    this.showLetters,
  });

  CustomKeyboardState createState() => CustomKeyboardState();
}

class CustomKeyboardState extends State<CustomKeyboard> {
  String code = "";

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            NumPad(
              widget: widget,
              digit: '1',
            ),
            NumPad(
              widget: widget,
              digit: '2',
              letters: 'ABC',
            ),
            NumPad(
              widget: widget,
              digit: '3',
              letters: 'DEF',
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            NumPad(
              widget: widget,
              digit: '4',
              letters: 'GHI',
            ),
            NumPad(
              widget: widget,
              digit: '5',
              letters: 'JKL',
            ),
            NumPad(
              widget: widget,
              digit: '6',
              letters: 'MNO',
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            NumPad(
              widget: widget,
              digit: '7',
              letters: 'PQRS',
            ),
            NumPad(
              widget: widget,
              digit: '8',
              letters: 'TUV',
            ),
            NumPad(
              widget: widget,
              digit: '9',
              letters: 'WXYZ',
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            NumPad(
              widget: widget,
              icon: Text(
                '',
                style: widget.textStyle,
              ),
            ),
            NumPad(
              widget: widget,
              digit: '0',
            ),
            NumPad(
              widget: widget,
              icon: Icon(
                Icons.backspace,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class NumPad extends StatelessWidget {
  const NumPad({
    Key key,
    this.digit,
    this.icon,
    this.letters,
    @required this.widget,
  }) : super(key: key);

  final CustomKeyboard widget;
  final String digit;
  final String letters;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    final double _gapSize = widget.width * 0.05;
    double _numPadSize = (widget.width - _gapSize * 3) / 3;
    if (_numPadSize > widget.numPadMaxSize) _numPadSize = widget.numPadMaxSize;
    final double _screenWidth = MediaQuery.of(context).size.width;
    if (_numPadSize > _screenWidth * 0.2) _numPadSize = _screenWidth * 0.2;
    final bool _isCircle = widget.keyDecoration.shape == BoxShape.circle;

    return Container(
      padding: EdgeInsets.all(_gapSize / 2),
      child: Material(
        color: Colors.transparent,
        child: icon != null && icon is Text
            ? Container(
                height: _numPadSize,
                width: _numPadSize,
                child: Center(
                    child: icon != null
                        ? icon
                        : Text(digit, style: widget.textStyle)),
              )
            : InkWell(
                borderRadius: _isCircle
                    ? BorderRadius.circular(_numPadSize / 2)
                    : widget.keyDecoration.borderRadius,
                onTap: () => icon != null
                    ? icon is Icon ? widget.onBackPressed() : null
                    : widget.onPressedKey(digit),
                child: Container(
                  decoration: widget.keyDecoration.copyWith(
                    color: icon is Icon
                        ? Colors.transparent
                        : widget.keyDecoration.color,
                  ),
                  height: _numPadSize,
                  width: _numPadSize,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        icon != null
                            ? icon
                            : Text(digit, style: widget.textStyle),
                        widget.showLetters
                            ? Text(
                                letters != null ? letters : ' ',
                                style: TextStyle(
                                  color: widget.textStyle.color,
                                  fontSize: widget.textStyle.fontSize / 2.5,
                                ),
                              )
                            : Container(),
                      ],
                    ),
                  ),
                )),
      ),
    );
  }
}
