import 'package:flutter/material.dart';

class CustomKeyboard extends StatefulWidget {
  final Function onBackPressed, onPressedKey;
  final TextStyle textStyle;

  CustomKeyboard({
    this.onBackPressed,
    this.onPressedKey,
    this.textStyle,
  });

  CustomKeyboardState createState() => CustomKeyboardState();
}

class CustomKeyboardState extends State<CustomKeyboard> {
  String code = "";

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            NumPad(
              widget: widget,
              digit: '1',
            ),
            NumPad(
              widget: widget,
              digit: '2',
            ),
            NumPad(
              widget: widget,
              digit: '3',
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            NumPad(
              widget: widget,
              digit: '4',
            ),
            NumPad(
              widget: widget,
              digit: '5',
            ),
            NumPad(
              widget: widget,
              digit: '6',
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            NumPad(
              widget: widget,
              digit: '7',
            ),
            NumPad(
              widget: widget,
              digit: '8',
            ),
            NumPad(
              widget: widget,
              digit: '9',
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
    @required this.widget,
  }) : super(key: key);

  final CustomKeyboard widget;
  final String digit;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Container(
          child: Material(
            color: Colors.transparent,
            child: icon != null && icon is Text
                ? Container(
                    height: 48,
                    width: 48,
                    child: Center(
                        child: icon != null
                            ? icon
                            : Text(digit, style: widget.textStyle)),
                  )
                : InkWell(
                    borderRadius: BorderRadius.all(Radius.circular(48)),
                    onTap: () => icon != null
                        ? icon is Icon ? widget.onBackPressed() : null
                        : widget.onPressedKey(digit),
                    child: Container(
                      height: 48,
                      width: 48,
                      child: Center(
                          child: icon != null
                              ? icon
                              : Text(digit, style: widget.textStyle)),
                    )),
          ),
        ),
      ),
    );
  }
}
