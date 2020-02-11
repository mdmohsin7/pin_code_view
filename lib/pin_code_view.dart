import 'package:flutter/material.dart';
import './custom_keyboard.dart';
import './code_view.dart';

class PinCode extends StatefulWidget {
  final Text title, subTitle;
  final String error, correctPin;
  final Function onCodeSuccess, onCodeFail;
  final int codeLength;
  final TextStyle keyTextStyle, codeTextStyle, errorTextStyle;
  final bool obscurePin;
  final Color backgroundColor;
  final double minWidth;
  final double maxWidth;

  PinCode({
    this.title,
    this.correctPin = "****", // Default Value, use onCodeFail as onEnteredPin
    this.error = '',
    this.subTitle,
    this.codeLength = 6,
    this.obscurePin = false,
    this.onCodeSuccess,
    this.onCodeFail,
    this.errorTextStyle = const TextStyle(color: Colors.red, fontSize: 15),
    this.keyTextStyle = const TextStyle(color: Colors.white, fontSize: 25.0),
    this.codeTextStyle = const TextStyle(
        color: Colors.white, fontSize: 25.0, fontWeight: FontWeight.bold),
    this.minWidth = 300,
    this.maxWidth = 500,
    this.backgroundColor,
  });

  PinCodeState createState() => PinCodeState();
}

class PinCodeState extends State<PinCode> {
  String smsCode = "";

  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width;
    double _widgetWidth = _screenWidth * 0.8;
    if (_widgetWidth < widget.minWidth) _widgetWidth = widget.minWidth;
    if (_widgetWidth > widget.maxWidth) _widgetWidth = widget.maxWidth;

    return Container(
      color: widget.backgroundColor ?? Theme.of(context).primaryColor,
      height: double.infinity,
      child: Container(
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Container(
            width: _widgetWidth,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 45,
                  ),
                  Column(
                    children: <Widget>[
                      widget.title,
                      SizedBox(
                        height: 4,
                      ),
                      widget.subTitle,
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Column(
                    children: <Widget>[
                      CodeView(
                        codeTextStyle: widget.codeTextStyle,
                        code: smsCode,
                        obscurePin: widget.obscurePin,
                        length: widget.codeLength,
                        width: _widgetWidth,
                      ),
                      Text(
                        '${widget.error}',
                        style: this.widget.errorTextStyle,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  CustomKeyboard(
                    textStyle: widget.keyTextStyle,
                    onPressedKey: (key) {
                      if (smsCode.length < widget.codeLength) {
                        setState(() {
                          smsCode = smsCode + key;
                        });
                      }
                      if (smsCode.length == widget.codeLength) {
                        if (smsCode == widget.correctPin) {
                          widget.onCodeSuccess(smsCode);
                        } else {
                          widget.onCodeFail(smsCode);
                          smsCode = "";
                        }
                      }
                    },
                    onBackPressed: () {
                      int codeLength = smsCode.length;
                      if (codeLength > 0)
                        setState(() {
                          smsCode = smsCode.substring(0, codeLength - 1);
                        });
                    },
                  ),
                  SizedBox(
                    height: 30,
                  ),
                ]),
          ),
        ),
      ),
    );
  }
}
