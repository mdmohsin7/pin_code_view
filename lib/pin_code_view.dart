import 'dart:async';

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
  final ImageProvider backgroundImage;
  final double minWidth;
  final double maxWidth;
  final double keyMaxSize;
  final BoxDecoration keyDecoration, codeDecoration, bulletDecoration;
  final bool showKeyLetters;
  final bool showBullets;
  final double bulletSize;
  final int errorDelaySeconds;
  final Color errorDelayProgressColor;

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
    this.maxWidth = 600,
    this.keyMaxSize = 90,
    this.keyDecoration = const BoxDecoration(
      shape: BoxShape.circle,
      color: Color.fromARGB(40, 0, 0, 0),
    ),
    this.codeDecoration = const BoxDecoration(
      color: Colors.black12,
      border: Border(bottom: BorderSide(color: Colors.white)),
    ),
    this.bulletDecoration = const BoxDecoration(
      color: Colors.white,
      shape: BoxShape.circle,
      border: Border(
        bottom: BorderSide(color: Colors.white),
        top: BorderSide(color: Colors.white),
        left: BorderSide(color: Colors.white),
        right: BorderSide(color: Colors.white),
      ),
    ),
    this.showKeyLetters = true,
    this.showBullets = true,
    this.bulletSize = 20,
    this.backgroundColor,
    this.backgroundImage,
    this.errorDelaySeconds,
    this.errorDelayProgressColor = Colors.white,
  });

  PinCodeState createState() => PinCodeState();
}

class PinCodeState extends State<PinCode> with SingleTickerProviderStateMixin {
  String smsCode = "";
  bool isFailed = false;
  bool isDisabled = false;
  AnimationController delayAnimationController;
  Animation<double> delayAnimation;
  Timer delayTimer;

  @override
  void initState() {
    super.initState();

    if (widget.errorDelaySeconds != null) {
      delayAnimationController = AnimationController(
          vsync: this, duration: Duration(seconds: widget.errorDelaySeconds));
      delayAnimation =
          Tween(begin: 0.0, end: 1.0).animate(delayAnimationController)
            ..addListener(() {
              setState(() {});
            });
    }
  }

  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width;
    double _widgetWidth = _screenWidth * 0.8;
    if (_widgetWidth < widget.minWidth) _widgetWidth = widget.minWidth;
    if (_widgetWidth > widget.maxWidth) _widgetWidth = widget.maxWidth;

    Widget _buildErrorDelayProgress() {
      return Container(
        padding: EdgeInsets.symmetric(vertical: 8),
        width: _widgetWidth * 0.8,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(3),
          child: LinearProgressIndicator(
            value: delayAnimation.value,
            valueColor: AlwaysStoppedAnimation(widget.errorDelayProgressColor),
            backgroundColor: Colors.transparent,
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? Theme.of(context).primaryColor,
        image: widget.backgroundImage != null
            ? DecorationImage(
                image: widget.backgroundImage,
                fit: BoxFit.cover,
              )
            : null,
      ),
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
                        showBullets: widget.showBullets,
                        bulletSize: widget.bulletSize,
                        bulletDecoration: widget.bulletDecoration,
                        codeDecoration: widget.codeDecoration,
                      ),
                      Text(
                        isFailed ? '${widget.error}' : '',
                        style: this.widget.errorTextStyle,
                        textAlign: TextAlign.center,
                      ),
                      widget.errorDelaySeconds != null
                          ? _buildErrorDelayProgress()
                          : Container(),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  CustomKeyboard(
                    isDisabled: isDisabled,
                    textStyle: widget.keyTextStyle,
                    width: _widgetWidth,
                    numPadMaxSize: widget.keyMaxSize,
                    showLetters: widget.showKeyLetters,
                    keyDecoration: widget.keyDecoration,
                    onPressedKey: (key) {
                      if (smsCode.length < widget.codeLength) {
                        setState(() {
                          isFailed = false;
                          smsCode = smsCode + key;
                        });
                      }
                      if (smsCode.length == widget.codeLength) {
                        if (smsCode == widget.correctPin) {
                          widget.onCodeSuccess(smsCode);
                        } else {
                          setState(() {
                            isFailed = true;
                          });
                          if (widget.errorDelaySeconds != null) {
                            setState(() {
                              isDisabled = true;
                            });
                            delayAnimationController.forward();
                            Timer(Duration(seconds: widget.errorDelaySeconds),
                                () {
                              delayAnimationController.reset();
                              setState(() {
                                isDisabled = false;
                                isFailed = false;
                              });
                            });
                          }
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
